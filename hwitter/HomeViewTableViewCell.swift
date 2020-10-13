//
//  HomeViewTableViewCell.swift
//  hwitter
//
//  Created by Lei Jin on 2020/10/8.
//  Copyright © 2020 Lei Jin. All rights reserved.
//

import UIKit

class HomeViewTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var handle: UILabel!
    
    @IBOutlet weak var hweet: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(profilePic:String?, name:String, handle:String, hweet:String){
        
        self.hweet.text = hweet
        self.name.text = name
        self.handle.text = "@"+handle
        if (profilePic != nil){
            self.profilePic.downloaded(from: profilePic!, indicator:nil)
        }
        else{
            self.profilePic.image = UIImage(named: "twitter")
        }
    }
    
}

public extension UIImageView {
    func downloaded(from url: URL, indicator:UIActivityIndicatorView?) {
        if let _ind = indicator{
            _ind.startAnimating()
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,                
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                if let _ind = indicator{
                    _ind.startAnimating()
                }
            }
        }.resume()
    }
    func downloaded(from link: String, indicator: UIActivityIndicatorView?) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, indicator:indicator)
    }
    
}
