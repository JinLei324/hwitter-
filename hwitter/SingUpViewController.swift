//
//  SingUpViewController.swift
//  hwitter
//
//  Created by Lei Jin on 2020/10/8.
//  Copyright © 2020 Lei Jin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SingUpViewController: UIViewController {

    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUp: UIBarButtonItem!
    
    @IBOutlet weak var errorMessage: UILabel!
    var databaseRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        signUp.isEnabled = false
    }
    // MARK:- Tap Signup and Cancel button
    
    @IBAction func didTapSignUp(_ sender: Any) {
        signUp.isEnabled = false
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { authResult, error in
            
            if let _eror = error{
                self.errorMessage.text = _eror.localizedDescription
            }else{
                self.errorMessage.text = "Registered Succefully"
                Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!) { [weak self] authResult, error in
                  guard let strongSelf = self else { return }
                  if(error == nil){
                    
                    strongSelf.databaseRef.child("user_profiles").child((authResult?.user.uid)!).setValue(["email": strongSelf.email.text!])
                     
                    strongSelf.performSegue(withIdentifier: "HandleViewSegue", sender: nil)
                 }
                }
                
            }
          
            
        }
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Text Changed
    @IBAction func textDidChange(_ sender: UITextField) {
        guard let emailText = email.text else {
            return
        }
        guard let passwordText = password.text else{
            return
        }
        if(emailText.count > 0 && passwordText.count > 0){
            signUp.isEnabled = true
        }
        else{
            signUp.isEnabled = false
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
