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

final class UploadImageViewController: UIViewController {
  
  // MARK: - Properties
  var username: String?
  
  // MARK: - IBOutlets
  @IBOutlet weak var imageToUpload: UIImageView!
  @IBOutlet weak var commentTextField: UITextField!
  @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
}

// MARK: - IBActions
extension UploadImageViewController {
  
  @IBAction func selectPicturePressed(_ sender: AnyObject) {
    // Open a UIImagePickerController to select the picture
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .photoLibrary
    present(imagePicker, animated: true)
  }
  
  @IBAction func sendPressed(_ sender: UIBarButtonItem) {
    commentTextField.resignFirstResponder()
    
    // Disable the send button until we are ready
    navigationItem.rightBarButtonItem?.isEnabled = false
    
    loadingSpinner.startAnimating()
    
    guard let uploadImage = imageToUpload.image,
      let pictureData = UIImagePNGRepresentation(uploadImage),
      let file = PFFile(name: "image", data: pictureData) else {
        return
    }
    
    guard let commentText = commentTextField.text else {
      return
    }
    
    DataManager.upload(file, and: commentText) {[unowned self] (success: Bool, error: Error?) in
      if let error = error {
        self.showErrorView(error)
      }
      if success == false {
        let successError = R.error(with: "Something went wrong, try again.")
        self.showErrorView(successError)
      }
      self.navigationController?.popViewController(animated: true)
    }
  }
}

// MARK: - UIImagePickerControllerDelegate

extension UploadImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
    imageToUpload.image = image
    picker.dismiss(animated: true, completion: nil)
  }
}
