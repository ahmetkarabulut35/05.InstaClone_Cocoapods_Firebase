//
//  UploadViewController.swift
//  InstaClone
//
//  Created by ACK Catalina on 12.06.2021.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        uploadButton.isEnabled = false
    }
    
    @objc func chooseImage () {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        uploadButton.isEnabled = true
    }

    @IBAction func uploadButtonClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let imageData = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(imageData, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error")
                }
                else {
                    imageReference.downloadURL { (url, error) in
                        if error != nil {
                            self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error")
                        } else {
                            let imageUrl = url?.absoluteString
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            let firestorePost = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email!, "postDescription" : self.descriptionTextField.text!, "postDate" : FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]
                            
                            _ = firestoreDatabase.collection("Posts").addDocument(data: firestorePost) { (error) in
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                }
                                else {
                                    self.imageView.image = UIImage(named : "select.jpeg")
                                    self.descriptionTextField.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                    self.uploadButton.isEnabled = false
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func makeAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
