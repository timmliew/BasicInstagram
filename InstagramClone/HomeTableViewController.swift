//
//  HomeTableViewController.swift
//  InstagramClone
//
//  Created by Timothy Liew on 3/15/18.
//  Copyright © 2018 Tim Liew. All rights reserved.
//

import UIKit
import Firebase

struct Profile {
    var name = ""
    var text = ""
    var imageLink = ""
    var photoImage = UIImage(named: "user")
}

class HomeTableViewController: UITableViewController {

    private var posts = [Posts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        let refreshControl = UIRefreshControl()
        self.tableView.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        
        
        Database.database().reference().child("photoPosts").observe(.childAdded)
        {(snapshot) in
            
            DispatchQueue.main.async {
                let newPost = Posts(snapshot: snapshot)
                print(self.posts.count)
                self.posts.insert(newPost, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .top)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! Cell
        
        cell.post = self.posts[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }


    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
}
