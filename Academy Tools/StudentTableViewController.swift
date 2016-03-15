//
//  StudentTableViewController.swift
//  Academy Tools
//
//  Created by Roger Eveland on 2/26/16.
//  Copyright © 2016 IFSI. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {

    var selectedAcademy:Academy!
    var students = [Student]()
    override func viewDidLoad() {
        super.viewDidLoad()
        try dbQueue.inDatabase { db in
            /*
            for a in Academy.fetchAll(db, "SELECT * FROM academy") {
            print(a.group_name)
            }
            */
            self.students = Student.fetchAll(db, "SELECT * FROM academy_students WHERE group_id = ? ORDER BY last_name, first_name", arguments:[self.selectedAcademy.group_id])
        }
        //students = selectedAcademy.students!
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    @IBAction func unWindToMealList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.sourceViewController as? StudentViewController, student = sourceViewController.student {
            /*
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                meals[selectedIndexPath.row] = meal
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                let newIndexPath = NSIndexPath(forRow: meals.count, inSection:0)
                meals.append(meal)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            saveMeals()
            */
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return students.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "StudentTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as!
            StudentTableViewCell
        let student = students[indexPath.row]
        cell.studentNameLabel.text = student.first_name! + " " + student.last_name!
        return cell
    }

    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nav = segue.destinationViewController as! UINavigationController
        let studentViewController = nav.topViewController as! StudentViewController
        if let selectedStudentCell = sender as? StudentTableViewCell{
            let indexPath = tableView.indexPathForCell(selectedStudentCell)!
            let selectedStudent = students[indexPath.row]
            studentViewController.student = selectedStudent
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
