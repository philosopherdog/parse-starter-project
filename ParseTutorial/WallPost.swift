/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

final class WallPost: PFObject {
  
  // MARK: - Properties
  @NSManaged var image: PFFile
  @NSManaged var user: PFUser
  @NSManaged var comment: String?
  
  // MARK: - Initializers
  init(image: PFFile, user: PFUser, comment: String?) {
    super.init()
    self.image = image
    self.user = user
    self.comment = comment
  }
  
  // Required otherwise the application crashes
  override init() {
    super.init()
  }
  
  // MARK: - Overridden
  override class func query() -> PFQuery<PFObject>? {
    let query = PFQuery(className: WallPost.parseClassName())
    query.includeKey("user")
    query.order(byDescending: "createdAt")
    return query
  }
}

// MARK: - PFSubclassing
extension WallPost: PFSubclassing {
  
  static func parseClassName() -> String {
    return "WallPost"
  }
}
