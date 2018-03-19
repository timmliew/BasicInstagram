//
//  HomeTableViewController.swift
//  InstagramClone
//
//  Created by Timothy Liew on 3/15/18.
//  Copyright © 2018 Tim Liew. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

protocol NewsFeedCellProtocol {
    func showProfile(_ name: String, _ userId: String)
}

class HomeTableViewController: UITableViewController, NewsFeedCellProtocol {
    
    private var posts = [Posts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        self.tableView.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
                
        Database.database().reference().child("photoPosts").observe(.childAdded)
        {(snapshot) in
            
            DispatchQueue.main.async {
                let newPost = Posts(snapshot: snapshot)
                self.posts.insert(newPost, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .top)
                self.tableView.estimatedRowHeight = 578.0
                self.tableView.rowHeight = UITableViewAutomaticDimension
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       return self.posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath) as! NewsFeedCell
        cell.post = self.posts[indexPath.row]
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    @IBAction func logout(){
        FBSDKLoginManager().logOut()
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let home = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(home, animated: true, completion: nil)
    }
    
    func showProfile(_ name: String, _ userId: String) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let profile = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        profile.name = name
        profile.id = userId
        self.navigationController?.pushViewController(profile, animated: true)
    }


    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
}
