//
//  Util.swift
//  ParseTutorial
//
//  Created by steve on 2017-08-05.
//  Copyright © 2017 Ron Kliffer. All rights reserved.
//

import Foundation

// MARK: - Resources

class R {
  static let wallPicturesTableViewController = "WallPicturesTableViewController"
  
  static func error(with message: String) -> Error {
    let error = NSError(domain: "Custom", code: 100, userInfo: ["error" : message]) as Error
    return error
  }
  
  static let wallPost = "WallPost"
}


