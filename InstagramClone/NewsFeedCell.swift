//
//  Cell.swift
//  InstagramClone
//
//  Created by Timothy Liew on 3/15/18.
//  Copyright © 2018 Tim Liew. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class NewsFeedCell: UITableViewCell {
    
    @IBOutlet var userPic: UIImageView!
    @IBOutlet var userName: UIButton!
    @IBOutlet var postedImageView: UIImageView!
    @IBOutlet var message: UILabel!
    @IBOutlet var likeCount: UILabel!
    
    @IBOutlet var favoriteButton: UIButton!
    private var isPressed = false
    private let selfId = Auth.auth().currentUser?.uid
    var delegate: NewsFeedCellProtocol!

    var post: Posts! {
        didSet {
            self.updateUI()
        }
    }
    
    private func updateUI(){
        self.message.text = post.caption
        self.userName.setTitle(post.userName, for: .normal)
        
        if let imageURL = post.imageURL {
            let downloadTask = Storage.storage().reference(forURL: imageURL).getData(maxSize: 2 * 1024 * 1024) { data, error in
                if let error = error {
                    print("There is an error downloading image! : \(error)")
                } else {
                    print("Image downloaded successfully!")
                    DispatchQueue.main.async {
                        self.postedImageView.image = UIImage(data: data!)
                    }
                }
            }
        }
    }
    
    
    @IBAction func favoriteAction(_ sender: Any) {
        let image: UIImage!
        isPressed = !isPressed
        if isPressed {
            image = UIImage(named:"heart-colored-icon")
            favoriteButton.setImage(image, for: .normal)
            self.addLikes()
        } else {
            image = UIImage(named:"heart-icon")
            favoriteButton.setImage(image, for: .normal)
            self.removeLikes()
        }
        
    }
    
    private func addLikes(){
        let ref = Database.database().reference().child("photoPosts")
        let keyToPost = ref.child("photoPosts").childByAutoId().key
        ref.child(self.post.postId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let post = snapshot.value as? [String : AnyObject] {
                let updateLikes: [String : Any] = ["peopleWhoLike/\(keyToPost)" : self.post.userId]
                ref.child(self.post.postId).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
                    
                    if error == nil {
                        ref.child(self.post.postId).observeSingleEvent(of: .value, with: { (snap) in
                            if let properties = snap.value as? [String : AnyObject] {
                                if let likes = properties["peopleWhoLike"] as? [String : AnyObject] {
                                    print("liked success")
                                    let count = likes.count
                                    self.likeCount.text = "\(count) Likes"
                                }
                            }
                        })
                    }
                })
            }
        })
        ref.removeAllObservers()
    }
    
    private func removeLikes() {
        print("remove")
        let ref = Database.database().reference().child("photoPosts")
        let keyToPost = ref.child("photoPosts").childByAutoId().key
        ref.child(self.post.postId).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value)
            guard let result = snapshot.value as? [String : AnyObject] else {
                print("no result found")
                return
            }
            
            guard let peopleWhoLike = result["peopleWhoLike"] as? [String:AnyObject] else {
                print("no people who like found")
                return
            }
            
            
            for (id,person) in peopleWhoLike {
                print("id: \(id), person: \(person), myid: \(self.selfId)")
                if person as? String == self.selfId {
                    ref.child(self.post.postId).child("peopleWhoLike").child(id).removeValue(completionBlock: { (error, reff) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        if error == nil {
                            ref.child(self.post.postId).observeSingleEvent(of: .value, with: { (snap) in
                                if let prop = snap.value as? [String : AnyObject] {
                                    if let likes = prop["peopleWhoLike"] as? [String : AnyObject] {
                                        let count = likes.count
                                        self.likeCount.text = "\(count) Likes"
                                        ref.child(self.post.postId).updateChildValues(["likes" : count])
                                    }else {
                                        self.likeCount.text = "0 Likes"
                                        ref.child(self.post.postId).updateChildValues(["likes" : 0])
                                    }
                                }
                            })
                        }
                    })
                    break
                    
                } else {
                    print("different person")
                }
            }
        })
        ref.removeAllObservers()
    }
    
    @IBAction func userProfile(_ sender: Any) {
        self.delegate.showProfile(self.post.userName, self.post.userId)
    }
    
}
