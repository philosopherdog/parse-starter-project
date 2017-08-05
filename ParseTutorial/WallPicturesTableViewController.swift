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
}

// MARK: - LifeCycle

extension WallPicturesTableViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    handleFetch()
  }
  
  func handleFetch() {
    DataManager.fetchAllPosts {[unowned self] (wallPosts, error: Error?) in
      if let error = error {
        self.showErrorView(error)
        return
      }
      guard let wallPosts = wallPosts else {
        let wallPostsError = R.error(with: "There was a problem, try again")
        self.showErrorView(wallPostsError)
        return
      }
      self.wallPosts = wallPosts
    }
  }
}


// MARK: - UITableViewDataSource

extension WallPicturesTableViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return wallPosts.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WallPostTableViewCell
    let wallPost = wallPosts[indexPath.row]
    
    DataManager.fetch(wallPost.image) { (image: UIImage?, error: Error?) in
      if let error = error {
        print(#line, error)
        return
      }
      guard let theImage = image else {
        return
      }
      
      cell.imageView?.image = theImage
    }
    return cell
  }
}

// MARK: - IBActions

extension WallPicturesTableViewController {
  @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
    PFUser.logOut()
    navigationController?.popToRootViewController(animated: true)
  }
}
