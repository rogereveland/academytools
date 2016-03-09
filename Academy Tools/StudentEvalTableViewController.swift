//
//  StudentEvalTableViewController.swift
//  Academy Tools
//
//  Created by Roger Eveland on 3/7/16.
//  Copyright © 2016 IFSI. All rights reserved.
//

import UIKit

protocol SettingCellDelegate : class {
    func didChangeSwitchState(sender  sender: StudentEvalTableViewCell, isOn: Bool)
}

class StudentEvalTableViewController: UITableViewController, SettingCellDelegate {
    
    @IBOutlet weak var measureDesc: UILabel!
    var selectedEval:StudentEval!
    var currentSkill:Skill!
    var skills:[Skill]!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.skills = loadSkillsFromFile()
        self.currentSkill = getSkill(selectedEval.skill_id)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        
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
        return selectedEval.measures!.count
        //return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentEvalTableViewCell", forIndexPath: indexPath) as! StudentEvalTableViewCell
        
        let measure = selectedEval.measures![indexPath.row]
        var switchOn = false
        if measure.result! == "Y" {
            switchOn = true
        }
        cell.passFailSwitch.setOn(switchOn, animated: false)
        cell.measureDesc.text = getMeasureDesc(measure.measure_id)
        cell.passFailLabel.text = measure.result
        cell.cellDelegate = self
        
        // Configure the cell...

        return cell
    }
    
    func getSkill(skill_id: Int) -> Skill? {
        var currentSkill = skills[0]
        for skill in skills {
            if skill.skill_id == skill_id {
                currentSkill = skill
            }
        }
        
        return currentSkill
    }
    
    func getMeasureDesc(measure_id: Int) -> String? {
        var measureDesc = ""
        
        for measure in self.currentSkill.measures! {
            if measure.measure_id == measure_id {
                measureDesc = measure.measure_desc!
            }
        }
        
        return measureDesc
    }
    
    func loadSkillsFromFile() -> [Skill]?{
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Skill.ArchiveURL.path!) as? [Skill]
        
    }
    
    
    
    func didChangeSwitchState(sender sender: StudentEvalTableViewCell, isOn: Bool) {
        let indexPath = self.tableView.indexPathForCell(sender)
        var measure = selectedEval.measures![indexPath!.row]
        
        if isOn {
            measure.result = "Y"
        } else {
            measure.result = "N"
        }
        
        print("Called it")
        
    }
    
    func saveSkills(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(skills, toFile: Skill.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save")
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
