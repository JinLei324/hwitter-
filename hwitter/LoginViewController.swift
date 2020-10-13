//
//  LoginViewController.swift
//  hwitter
//
//  Created by Lei Jin on 2020/10/8.
//  Copyright © 2020 Lei Jin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var logIn: UIBarButtonItem!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    var rootRef:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        logIn.isEnabled = false
        rootRef = Database.database().reference()
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        print("abc")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        guard self.rootRef != nil else {
            return
        }
        
        Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!) { [weak self] authResult, error in
            
            
            guard let strongSelf = self else { return }
            
            if(error == nil){
                
                guard let userid = authResult?.user.uid else{
                    return
                }
                
                strongSelf.rootRef.child("user_profiles").child(userid).child("handle").observe(.value, with: { (snapshot) in
                
                    if(!snapshot.exists()){
                        
                        strongSelf.performSegue(withIdentifier: "HandleViewSegue", sender: nil)
                    }
                    else{
                        
                        strongSelf.performSegue(withIdentifier: "HomeViewSegue", sender: nil)
                    }
                })
            
            }
            else{
                
                strongSelf.errorMessage.text = error?.localizedDescription
            }
            
         
        }
        
    }
    
    @IBAction func didTextChange(_ sender: Any) {
        guard let emailText = email.text else {
            return
        }
        guard let passwordText = password.text else{
            return
        }
        if(emailText.count > 0 && passwordText.count > 0){
            logIn.isEnabled = true
        }
        else{
            logIn.isEnabled = false
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
