//
//  StudentViewController.swift
//  Academy Tools
//
//  Created by Roger Eveland on 2/27/16.
//  Copyright © 2016 IFSI. All rights reserved.
//

import UIKit

class StudentViewController: UIViewController {
    
    @IBOutlet var studentTitle: UIView!
    @IBAction func studentBackButton(sender: AnyObject) {
        let isPresenting = presentingViewController is UINavigationController
        if isPresenting {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
   
    var student:Student!
    //var students:[Student]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = student.first_name! + " " + student.last_name!
        //studentNavBar.topItem!.title = student.first_name
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*
        let studentTableViewController = segue.destinationViewController as! StudentTableViewController
        if let selectedAcademyCell = sender as? AcademyTableViewCell{
            //let indexPath = tableView.indexPathForCell(selectedAcademyCell)!
            //let selectedAcademy = academies[indexPath.row]
            //studentTableViewController.selectedAcademy = selectedAcademy
        }
        */
    }
    

}
