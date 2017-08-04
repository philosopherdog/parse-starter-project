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

final class LoginViewController: UIViewController {
  
  // MARK: - Segue Identifiers
  fileprivate enum Segue {
    static let scrollViewWallSegue = "LoginSuccesful"
    static let tableViewWallSegue = "LoginSuccesfulTable"
  }
  
  // MARK: - IBOutlets
  @IBOutlet weak var userTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
}

// MARK: - Life Cycle
extension LoginViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Check if user exists and logged in
    guard let user = PFUser.current(), user.isAuthenticated else {
      return
    }
    
    performSegue(withIdentifier: Segue.scrollViewWallSegue, sender: nil)
  }
}

// MARK: - IBActions
private extension LoginViewController {
  
  @IBAction func loginTapped(_ sender: AnyObject) {
    guard let username = userTextField.text,
      let password = passwordTextField.text else {
        displayAlertController(NSLocalizedString("Missing Information", comment: ""),
                               message: NSLocalizedString("Username and Password fields cannot be empty. Please enter and try again!", comment: ""))
        return
    }
    
    PFUser.logInWithUsername(inBackground: username, password: password) { [unowned self] user, error in
      guard let _ = user else {
        self.showErrorView(error)
        return
      }
      self.performSegue(withIdentifier: Segue.tableViewWallSegue, sender: nil)
    }
  }
}

// MARK: - Private
private extension LoginViewController {
  
  /**
   Helper method to present a **UIAlertController** to the user
   
   - parameter title: Title for the controller
   - parameter message: Message displayed inside the controller
   */
  func displayAlertController(_ title: String, message: String) {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    controller.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .cancel))
    present(controller, animated: true)
  }
}
