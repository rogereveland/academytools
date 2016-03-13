//
//  AcademyTableViewController.swift
//  Academy Tools
//
//  Created by Roger Eveland on 2/25/16.
//  Copyright © 2016 IFSI. All rights reserved.
//

import UIKit

class AcademyTableViewController: UITableViewController {
    var networkTester = NetworkTester()
    var academies = [Academy]()
    var instructor = Instructor(instructorName: "", instructorID: 0)
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.instructor = loadInstructor()
        logoutButton.title = "Logout " + instructor!.instructorName!
               
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logoutInstructor(sender: UIBarButtonItem) {
        do {
            try NSFileManager.defaultManager().removeItemAtURL(Instructor.ArchiveURL)
        } catch {
            
        }
        self.performSegueWithIdentifier("logoutAndShowLogin", sender: "logoutButton")
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return academies.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "AcademyTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as!
            AcademyTableViewCell
        let academy = academies[indexPath.row]
        cell.academyName.text = academy.group_name
        // Configure the cell...
        return cell
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier! != "logoutAndShowLogin" {
            let studentTableViewController = segue.destinationViewController as! StudentTableViewController
            if let selectedAcademyCell = sender as? AcademyTableViewCell{
                let indexPath = tableView.indexPathForCell(selectedAcademyCell)!
                let selectedAcademy = academies[indexPath.row]
                studentTableViewController.selectedAcademy = selectedAcademy
            }
        } else {
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    //MARK: NSCoding
    
    func saveAcademies(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(academies, toFile: Academy.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save")
        }
    }
    
    func loadAcademiesFromFile() -> [Academy]?{
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Academy.ArchiveURL.path!) as? [Academy]
    }
    
    func loadInstructor() -> Instructor?{
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Instructor.ArchiveURL.path!) as? Instructor
    }

}
