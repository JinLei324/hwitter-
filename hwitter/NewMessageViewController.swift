//
//  NewMessageViewController.swift
//  hwitter
//
//  Created by Lei Jin on 2020/10/9.
//  Copyright © 2020 Lei Jin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class NewMessageViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    var databaseRef = Database.database().reference()
    var loggedInUser:User!
    
    @IBOutlet weak var newHweetTextView: UITextView!
    
    @IBOutlet weak var newHweetToolbar: UIToolbar!
    
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    
    var toolbarBottomConstraintInitialValue = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newHweetToolbar.isHidden = true
        // Do any additional setup after loading the view.
        newHweetTextView.becomeFirstResponder()
        self.loggedInUser = Auth.auth().currentUser
        newHweetTextView.textContainerInset=UIEdgeInsets(top: 30, left: 20, bottom: 20, right: 20)
        newHweetTextView.text = "What's Happening?"
        newHweetTextView.textColor = UIColor.lightGray
        
    }
    override func viewDidAppear(_ animated: Bool) {
        enableKeyboardHideOnTap()
        self.toolbarBottomConstraintInitialValue = toolbarBottomConstraint.constant
    }
    private func enableKeyboardHideOnTap(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(NewMessageViewController.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(NewMessageViewController.keyboardWillHide),
            name:UIResponder.keyboardWillHideNotification,
            object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewMessageViewController.hideKeyboard))
        self.view.addGestureRecognizer(tap)

    }
    
    @objc func keyboardWillShow(notification:Notification){
        guard let info = notification.userInfo else{
            return
        }
        guard let keyboardRectValue = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        guard let duration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) else {
            return
        }
        
        let keyboardHeight = keyboardRectValue.height
        UIView.animate(withDuration: duration){
            self.toolbarBottomConstraint.constant=keyboardHeight
            self.newHweetToolbar.isHidden = false
            self.view.layoutIfNeeded()
        }
        
    }
    @objc func keyboardWillHide(notification:Notification){
        guard let info = notification.userInfo else{
            return
        }
        
        guard let duration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) else {
            return
        }
        
        UIView.animate(withDuration: duration){
            self.toolbarBottomConstraint.constant=0
            self.newHweetToolbar.isHidden = true
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.textColor == UIColor.lightGray){
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    @IBAction func didTapHweet(_ sender: Any) {
        guard let _hweettext = newHweetTextView.text else{
            return
        }
        if(_hweettext.count == 0){
            return
        }
        guard let key = self.databaseRef.child("hweets").childByAutoId().key else {return}
        let post = ["text":_hweettext,
                    "timestamp":NSDate().timeIntervalSince1970] as [String : Any]
        
               
        let childUpdates = ["/hweets/\(self.loggedInUser.uid)/\(key)/": post]
        self.databaseRef.updateChildValues(childUpdates)
        dismiss(animated: true, completion: nil)
    }
    
}
