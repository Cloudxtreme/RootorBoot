//
//  ProfileViewController.swift
//  
//
//  Created by Alexander Mogavero on 4/07/2015.
//
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.titleView = UIImageView(image: UIImage(named: "profile-header"))
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-back-button"), style: UIBarButtonItemStyle.Plain, target: self, action: "goToCards:")
        navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        nameLabel.text = currentUser()?.name
        
        currentUser()?.getPhoto({
            image in
            self.imageView.layer.masksToBounds = true
            self.imageView.contentMode = .ScaleAspectFill
            self.imageView.image = image
        })
        
    }
    
    func goToCards(button: UIBarButtonItem) {
        pageController.goToNextVC()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
