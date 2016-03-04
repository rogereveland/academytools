//
//  StartupViewController.swift
//  Academy Tools
//
//  Created by Roger Eveland on 3/1/16.
//  Copyright © 2016 IFSI. All rights reserved.
//

import UIKit

class StartupViewController: UIViewController {
    var instructor = Instructor(instructorName: "", instructorID: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        if let ins = loadInstructor() {
            instructor = ins
            dispatch_async(dispatch_get_main_queue(), {
                self.performSegueWithIdentifier("skipLogin", sender: "AnyObject?")
            })
            print("Already Logged In")
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                self.performSegueWithIdentifier("forceLogin", sender: "AnyObject?")
            })
            print("Need to login")
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadInstructor() -> Instructor?{
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Instructor.ArchiveURL.path!) as? Instructor
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
