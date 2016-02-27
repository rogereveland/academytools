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
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAcademies()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadAcademies(){
        if networkTester.connectedToNetwork() {
            let url = "https://test.fsi.illinois.edu/academy%20tools/data/data.cfm"
            
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            let session = NSURLSession.sharedSession()
            request.HTTPMethod = "POST"
            
            let params = ["action":"getGroups"] as Dictionary<String,String>
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTaskWithRequest(request){data, response, error in
                let json = JSON(data: data!)
                let acas = json["academies"]
                for (_,a):(String, JSON) in acas {
                    let name = a["group_name"].string
                    let group_id = a["group_id"].int
                    let students = a["students"]
                    var studentsArr = [Student]()
                    for(_,s):(String, JSON) in students{
                        let newStudent = Student(
                            first_name: s["first_name"].string!,
                            last_name: s["last_name"].string!,
                            agency_name: s["agency_name"].string!,
                            people_id: s["people_id"].int!,
                            bio_text: s["bio_text"].string!,
                            company: s["company"].string!
                        )
                        studentsArr.append(newStudent!)
                    }
                    let newAcademy = Academy(name: name!, group_id: group_id!, students: studentsArr)
                    self.academies.append(newAcademy!)
                    
                }
                self.saveAcademies()
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
            task.resume()
            

        } else {
            print("No network")
            self.academies = self.loadAcademiesFromFile()!
        }
        
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
        cell.academyName.text = academy.name
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
        let studentTableViewController = segue.destinationViewController as! StudentTableViewController
        if let selectedAcademyCell = sender as? AcademyTableViewCell{
            let indexPath = tableView.indexPathForCell(selectedAcademyCell)!
            let selectedAcademy = academies[indexPath.row]
            studentTableViewController.selectedAcademy = selectedAcademy
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


}
