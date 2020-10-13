//
//  ViewController.swift
//  hwitter
//
//  Created by Lei Jin on 2020/10/8.
//  Copyright © 2020 Lei Jin. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener({(auth, user) in
            if let _ = user{
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarControllerView")
                homeViewController.modalPresentationStyle = .fullScreen
                self.present(homeViewController, animated: true, completion: nil)
            }
        })
    }


}

