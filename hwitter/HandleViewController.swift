//
//  HandleViewController.swift
//  hwitter
//
//  Created by Lei Jin on 2020/10/8.
//  Copyright © 2020 Lei Jin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HandleViewController: UIViewController {

    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var handle: UITextField!
    @IBOutlet weak var startTweeting: UIBarButtonItem!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    var user:User!
    var rootRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.user = Auth.auth().currentUser
        
    }
    

    @IBAction func didTapBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func didTapStartTweeting(_ sender: Any) {
        
        guard let _user = self.user else{
            return
        }
        // TODO:- remove for fake problem
        guard let _handle = self.handle.text else {
            return
        }
        guard let _fullName = self.fullName.text else{
            return
        }
        // TODO: end
        
        _ = self.rootRef.child("handles").child(_handle).observe(.value, with: {(snapshot) in
            
            if(!snapshot.exists()){
                self.rootRef.child("user_profiles").child(_user.uid).child("handle").setValue(_handle.lowercased())
                self.rootRef.child("user_profiles").child(_user.uid).child("name").setValue(_fullName)
                self.rootRef.child("handles").child(_handle).setValue(_user.uid)
                
                self.performSegue(withIdentifier: "HomeViewSegue", sender: nil)
            }
            else{
                self.errorMessage.text = "Handle already in use!"
            }
        })
        	
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
