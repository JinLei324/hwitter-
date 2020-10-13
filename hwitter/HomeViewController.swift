//
//  HomeViewController.swift
//  hwitter
//
//  Created by Lei Jin on 2020/10/8.
//  Copyright © 2020 Lei Jin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var databaseRef = Database.database().reference()
    var loggedInUser:User!
    var loggedInUserData:[String:AnyObject]!

    var  hweets = [[String:AnyObject]]()
    
    @IBOutlet weak var aivLoading: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.aivLoading.startAnimating()
        self.loggedInUser=Auth.auth().currentUser
        
        self.databaseRef.child("user_profiles").child(self.loggedInUser.uid).observe(.value, with: { (snapshot) in
        
            self.loggedInUserData = snapshot.value as? [String:AnyObject]
            
            self.databaseRef.child("hweets/\(self.loggedInUser.uid)").observe(.childAdded, with: {(snapshot) in
                self.hweets.append(snapshot.value as! [String:AnyObject])
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                self.aivLoading.stopAnimating()
                self.tableView.setContentOffset(.zero, animated: true)
                
            }){error in
                print(error.localizedDescription)
            }
            
        })

    }
    
    // MARK: - table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hweets.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HomeViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeViewTableViewCell", for: indexPath) as! HomeViewTableViewCell
        let hweet = hweets[self.hweets.count - 1 - indexPath.row]["text"] as! String
        let pic = self.loggedInUserData["profile_pic"] as? String
        cell.configure(profilePic: pic, name: self.loggedInUserData["name"] as! String, handle: self.loggedInUserData["handle"] as! String, hweet: hweet)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        return
            
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
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
