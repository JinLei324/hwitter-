//
//  MeViewController.swift
//  hwitter
//
//  Created by Lei Jin on 2020/10/9.
//  Copyright © 2020 Lei Jin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class MeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var hweetsContainer: UIView!
    @IBOutlet weak var mediaContainer: UIView!
    @IBOutlet weak var likesContainer: UIView!
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var handle: UILabel!
    
    @IBOutlet weak var about: UITextField!
    
    @IBOutlet weak var imageLoader: UIActivityIndicatorView!
    
    var loggedInUser:User!
    var databaseRef = Database.database().reference()
    var storageRef = Storage.storage().reference()
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageLoader.stopAnimating()
        self.loggedInUser = Auth.auth().currentUser
        self.databaseRef.child("user_profiles").child(self.loggedInUser.uid).observe(.value, with: { snapshot in
            
            let userInfo = snapshot.value as! [String:AnyObject]
            self.name.text = userInfo["name"] as? String
            
            guard let _handle = userInfo["handle"] as? String else{
                return
            }
            self.handle.text = "@"+_handle
            
            if(userInfo["about"] !== nil){
                self.about.text = userInfo["about"] as? String
            }
            
            if(userInfo["profile_pic"] !== nil){
                self.profilePicture.downloaded(from: (userInfo["profile_pic"] as? String)!, indicator:self.imageLoader)
                
            }
        })
    }
    

    @IBAction func showComponents(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex{
        case 0:
            UIView.animate(withDuration: 0.5) {
                self.hweetsContainer.alpha = 1
                self.mediaContainer.alpha = 0
                self.likesContainer.alpha = 0
                
            }
            break
        case 1:
            UIView.animate(withDuration: 0.5) {
                self.hweetsContainer.alpha = 0
                self.mediaContainer.alpha = 1
                self.likesContainer.alpha = 0
                
            }
            break
        case 2:
            UIView.animate(withDuration: 0.5) {
                self.hweetsContainer.alpha = 0
                self.mediaContainer.alpha = 0
                self.likesContainer.alpha = 1
                
            }
            break
        default:
            return
        }
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        
        try! Auth.auth().signOut()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let welcomeViewController = mainStoryboard.instantiateViewController(withIdentifier: "WelcomeControllerView")
        welcomeViewController.modalPresentationStyle = .fullScreen
        self.present(welcomeViewController, animated: true, completion: nil)
    }
   
    
    @IBAction func didTapProfilePic(_ sender: UITapGestureRecognizer) {
        let myActionSheet = UIAlertController(title: "Profile Picture", message: "Select", preferredStyle: .actionSheet)
        
        let viewPicture = UIAlertAction(title: "View Picture", style: .default, handler: { action in
            
            let imageView = sender.view as! UIImageView
            let newImageView = UIImageView()
            self.setProfilePicture(newImageView, imageToSet: imageView.image!)
            newImageView.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullScreenImage))
            newImageView.addGestureRecognizer(tap)
            self.view.addSubview(newImageView)
            
        })
        let photoGallery = UIAlertAction(title: "Photos", style: .default, handler: { action in
            
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            
            
        })
        
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { action in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        })
        
        
        myActionSheet.addAction(viewPicture)
        myActionSheet.addAction(photoGallery)
        myActionSheet.addAction(camera)
        myActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(myActionSheet, animated: true, completion: nil)
    }
    @objc func dismissFullScreenImage(sender:UITapGestureRecognizer){
        sender.view?.removeFromSuperview()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.imageLoader.startAnimating()
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        setProfilePicture(self.profilePicture, imageToSet: image)
        
        if let imageData = self.profilePicture.image!.pngData(){
            let profilePicStorageRef = storageRef.child("/user_profiles/\(self.loggedInUser.uid)/profile_pic.png")
            
            let uploadTask = profilePicStorageRef.putData(imageData, metadata: nil){ metadata, error in
                
                profilePicStorageRef.downloadURL { (url, error) in
                    
                    guard let downloadURL = url else {
                        return
                    }
                    self.databaseRef.child("user_profiles").child(self.loggedInUser.uid).child("profile_pic").setValue(downloadURL.absoluteString)
                    self.imageLoader.stopAnimating()
                    
                }
            }
            
            
        }
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    func setProfilePicture(_ imageView: UIImageView, imageToSet:UIImage){
        imageView.frame = self.view.frame
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.image = imageToSet
    }
}
