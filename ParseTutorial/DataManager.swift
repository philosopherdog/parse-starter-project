//
//  DataManager.swift
//  ParseTutorial
//
//  Created by steve on 2017-08-05.
//  Copyright © 2017 Ron Kliffer. All rights reserved.
//

import Foundation

class DataManager {
  
  static func checkUserLoginState(completion:(Bool) -> Void) {
    completion(PFUser.current()?.isAuthenticated ?? false)
  }
  
  static func login(with userName: String, and password: String, completion:@escaping (Bool, Error?)-> Void) {
    PFUser.logInWithUsername(inBackground: userName, password: password) { user, error in
      guard let _ = user else {
        completion(false, error)
        return
      }
      completion(true, nil)
      
    }
  }
  
  static func fetchAllPosts(with completion: @escaping ([WallPost]?, Error?) -> Void ) {
    
    var result: [WallPost]? = nil
    var theError: Error? = nil
    
    guard let query = WallPost.query() else {
      theError = R.error(with: "Couldn't generate a query, please try again.")
      completion(result, theError)
      return
    }
    
    query.findObjectsInBackground {(objects: [PFObject]?, error: Error?) in
      guard let objects = objects as? [WallPost] else {
        theError = error
        completion(result, theError)
        return
      }
      result = objects
      completion(result, theError)
    }
  }
  
  static func upload(_ file: PFFile, and comment: String, completion:@escaping (Bool, Error?) -> Void) {
    var theError: Error? = nil
    var theSuccess: Bool = false
    defer {
      completion(theSuccess, theError)
    }
    
    DataManager.checkUserLoginState(completion: { (loggedIn: Bool) in
      if !loggedIn {
        theError = R.error(with: "No current user")
        return
      }
    })
    
    let user = PFUser.current()!
    
    file.saveInBackground({ success, error in
      if error != nil {
        theError = error
        return
      }
      
      guard success == true else {
        theError = R.error(with: "File upload not successful, try again")
        return
      }
      
      let wallPost = WallPost(image: file, user: user, comment: comment)
      
      wallPost.saveInBackground { success, error in
        defer {
          completion(success, error)
        }
      }
    }, progressBlock: { percent in
      print("Uploaded: \(percent)%")
    })
  }
  
  static func fetch(_ image: PFFile,  completion: @escaping (UIImage?, Error?)-> Void) {
    
    image.getDataInBackground { (data: Data?, error: Error?) in
      
      if error != nil || data == nil {
        return completion(nil, nil)
      }
      
      guard let data = data else {
        return
      }
      guard let theImage = UIImage(data: data) else {
        return
      }
      completion(theImage, nil)
    }
  }
}
