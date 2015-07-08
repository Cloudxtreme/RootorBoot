//
//  LoginViewController.swift
//  
//
//  Created by Alexander Mogavero on 24/06/2015.
//
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func pressedFBLogin(sender: UIButton) {
        
        PFFacebookUtils.logInWithPermissions(["public_profile", "user_about_me", "user_birthday"], block: {
            user, error in
            
            
            if user == nil {
                println("The User cancelled the Facebook Login")
                return
                
            }
            else if user!.isNew {
                
                FBRequestConnection.startWithGraphPath("/me?fields=picture,first_name,birthday,gender", completionHandler: {
                    connection, result, error in
                    var r = result as! NSDictionary
                    user!["firstName"] = r["first_name"] as! String
                    user!["gender"] = r["gender"] as! String
                    
                    
                    NSLog("User Logged In Through Facebook")
                    
                    
                    var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    
                    user!["birthday1"] = dateFormatter.dateFromString(r["birthday"] as! String)
                    
                    let pictureURL = ((r["picture"] as! NSDictionary)["data"] as! NSDictionary)["url"] as! String
                    
                    let url = NSURL(string: pictureURL)
                    
                    let request = NSURLRequest(URL: url!)
                    
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
                        response, data, error in
                        
                        let imageFile = PFFile(name: "avatar.jpg", data: data)
                        user!["picture"] = imageFile
                        user!.saveInBackgroundWithBlock(nil)
                        
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CardsNavController") as? UIViewController
                        self.presentViewController(vc!, animated: true, completion: nil)
                    

                    })
                        
                    })
            }
            else {
                println("User Logged In Through Facebook")
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CardsNavController") as? UIViewController
                self.presentViewController(vc!, animated: true, completion: nil)
                
                FBRequestConnection.startWithGraphPath("/me?fields=picture,first_name,birthday,gender", completionHandler: {
                    connection, result, error in
                    var r = result as! NSDictionary
                    user!["firstName"] = r["first_name"] as! String
                    user!["gender"] = r["gender"] as! String
                    user!["picture"] = ((r["picture"] as! NSDictionary)["data"] as! NSDictionary)["url"] as! String
                    
                    
                    var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    
                    user!["birthday1"] = dateFormatter.dateFromString(r["birthday"] as! String)
                    println(result)
                    
                    user!.saveInBackgroundWithBlock({
                        success, error in
                        println(success)
                        println(error)
                        
                    })
                })
            }
        })
        
    }
    
    
    
}
