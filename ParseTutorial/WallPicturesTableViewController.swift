//
//  WallPicturesTableViewController.swift
//  ParseTutorial
//
//  Created by steve on 2017-08-04.
//  Copyright © 2017 Ron Kliffer. All rights reserved.
//

import UIKit

class WallPicturesTableViewController: UITableViewController {
  
  var wallPosts: [WallPost] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // fetch the WallPost Object
    fetchWallPostObjects()
  }
  
  func fetchWallPostObjects() {
    guard let query = WallPost.query() else {
      return
    }
    
    query.findObjectsInBackground { [unowned self] (objects, error: Error?) in
      guard let objects = objects as? [WallPost] else {
        self.showErrorView(error)
        return
      }
      self.wallPosts = objects
    }
  }
  
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return wallPosts.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WallPostTableViewCell
   let wallPost = wallPosts[indexPath.row]
    wallPost.image.getDataInBackground { data, error in
      guard let data = data,
        let image = UIImage(data: data) else {
          return
      }
      cell.postImage.image = image
   }

    return cell
  }
  
  @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
    PFUser.logOut()
    navigationController?.popToRootViewController(animated: true)
  }
  
  
  
  
  
  
  
}
