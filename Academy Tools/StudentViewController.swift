//
//  StudentViewController.swift
//  Academy Tools
//
//  Created by Roger Eveland on 2/27/16.
//  Copyright © 2016 IFSI. All rights reserved.
//

import UIKit

class StudentViewController: UIViewController {
    var networkTester = NetworkTester()
    var student:Student!
    var studentMeasures:[StudentMeasure] = []
    
    @IBOutlet var studentTitle: UIView!
    @IBAction func studentBackButton(sender: AnyObject) {
        let isPresenting = presentingViewController is UINavigationController
        if isPresenting {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = student.first_name! + " " + student.last_name!
        loadStudentEvals()
        //studentNavBar.topItem!.title = student.first_name
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadStudentEvals(){
        if networkTester.connectedToNetwork() {
            let url = "https://test.fsi.illinois.edu/academy%20tools/data/data.cfm"
            
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            let session = NSURLSession.sharedSession()
            request.HTTPMethod = "POST"
            
            let params = ["action":"getGroups","people_id": String(student.people_id)] as Dictionary<String,String>
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTaskWithRequest(request){data, response, error in
                let json = JSON(data: data!)
                let evals = json["evals"]
                var evalsArr = [StudentEval]()
                for (_,e):(String, JSON) in evals {
                    let evaluatorName = e["evaluatorName"].string
                    let eval_id = e["eval_id"].int
                    let comments = e["comments"].string
                    let passfail = e["passfail"].string
                    let skill_id = e["skill_id"].int
                    let measures = e["measures"]
                    var measuresArr = [StudentMeasure]()
                    for(_,m):(String, JSON) in measures{
                        let newMeasure = StudentMeasure(
                            result : m["result"].string,
                            measure_id : m["measure_id"].int!
                        )
                        measuresArr.append(newMeasure!)
                    }
                    let newEval = StudentEval(eval_id:eval_id!, evaluatorName: evaluatorName!, skill_id: skill_id!, measures: measuresArr, comments: comments!, passfail: passfail!)
                    evalsArr.append(newEval!)
                    
                }
                self.student.evals = evalsArr
                self.saveStudent()
                
            }
            task.resume()
            
            
        } else {
            
        }
        
    }

    func saveStudent(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(student!, toFile: Student.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save")
        }
    }
    
    func loadStudent() -> Student?{
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Student.ArchiveURL.path!) as? Student
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
