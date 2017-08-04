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

import UIKit

final class RegisterViewController: UIViewController {
  
  // MARK: - Segue Identifiers
  fileprivate enum Segue {
    static let tableViewWallSegue = "SignupSuccesfulTable"
  }
  
  // MARK: - IBOutlets
  @IBOutlet weak var userTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
}

// MARK: - IBActions
private extension RegisterViewController {
  
  @IBAction func signUpPressed(_ sender: AnyObject) {
    let user = PFUser()
    user.username = userTextField.text
    user.password = passwordTextField.text
    user.signUpInBackground { [unowned self] succeeded, error in
      guard succeeded == true else {
        self.showErrorView(error)
        return
      }
      // Successful registration, display the wall
      self.performSegue(withIdentifier: Segue.tableViewWallSegue, sender: nil)
    }
  }
}
