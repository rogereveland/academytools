//
//  LoginViewController.swift
//  Academy Tools
//
//  Created by Roger Eveland on 2/29/16.
//  Copyright © 2016 IFSI. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var networkTester = NetworkTester()
    var instructor = Instructor(instructorName: "", instructorID: 0)
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let ins = loadInstructor() {
            instructor = ins
            self.performSegueWithIdentifier("showLoading", sender: "AnyObject?")
        }
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginButton(sender: AnyObject) {
        doLogin()
    }

    func doLogin() {
        let url = "https://test.fsi.illinois.edu/academy%20tools/data/login.cfm"
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let params = ["action":"login","username":usernameTextField.text!,"password":passwordTextField.text!] as Dictionary<String,String>
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request){data, response, error in
            let json = JSON(data: data!)
            
            let responseCode = json["responseCode"].int
            
            if responseCode == 1 {
                self.instructor!.instructorName = json["instructorName"].string!
                self.instructor!.instructorID = json["instructorID"].int!
                self.saveInstructor()
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("showLoading", sender: "AnyObject?")
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertController(title: "Login Problem", message: json["errorMessage"].string!, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
            
            
            /*
           
            */
        }
        task.resume()
        
    }
    
    func saveInstructor(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(instructor!, toFile: Instructor.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save")
        }
    }
    
    func loadInstructor() -> Instructor?{
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Instructor.ArchiveURL.path!) as? Instructor
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
