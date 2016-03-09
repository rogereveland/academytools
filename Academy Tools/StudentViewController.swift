//
//  StudentViewController.swift
//  Academy Tools
//
//  Created by Roger Eveland on 2/27/16.
//  Copyright © 2016 IFSI. All rights reserved.
//

import UIKit

class StudentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var networkTester = NetworkTester()
    var student:Student!
    var studentMeasures:[StudentMeasure] = []
    var skills = [Skill]()
    
    @IBOutlet weak var evalTable: UITableView!
    @IBOutlet weak var evaluatorName: UILabel!
    @IBOutlet weak var evaluationDate: UILabel!
    @IBOutlet var studentTitle: UIView!
    @IBOutlet weak var loadingData: UILabel!
    
    @IBAction func studentBackButton(sender: AnyObject) {
        let isPresenting = presentingViewController is UINavigationController
        if isPresenting {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = student.first_name! + " " + student.last_name!
        loadStudentEvals()
        loadingData.hidden = false
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
            
            let params = ["action":"getEvals","people_id": String(student.people_id)] as Dictionary<String,String>
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
                    let eval_date = e["eval_date"].string
                    var measuresArr = [StudentMeasure]()
                    for(_,m):(String, JSON) in measures{
                        let newMeasure = StudentMeasure(
                            result : m["result"].string,
                            measure_id : m["measure_id"].int!
                        )
                        measuresArr.append(newMeasure!)
                    }
                    let newEval = StudentEval(eval_id:eval_id!, evaluatorName: evaluatorName!, skill_id: skill_id!, measures: measuresArr, comments: comments!, passfail: passfail!,eval_date: eval_date!)
                    evalsArr.append(newEval!)
                    
                }
                self.student.evals = evalsArr
                self.saveStudent()
                self.skills = self.loadSkillsFromFile()!
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.evalTable.reloadData()
                    self.loadingData.hidden = true
                    print("Reloading Data")
                })
                
            }
            task.resume()
            
            
        } else {
            self.loadingData.hidden = true
            self.skills = self.loadSkillsFromFile()!
            self.student = loadStudentFromFile()
            
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(student.evals!.count)
        return student.evals!.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "evalCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as!
        EvalTableViewCell
        let studentEval = student.evals![indexPath.row]
        cell.evaluatorName.text = studentEval.evaluatorName
        cell.skillName.text = getSkillName(studentEval.skill_id)
        cell.passFail.text = studentEval.passfail
        cell.evaluationDate.text = studentEval.eval_date
        return cell
    }
    
    func getSkillName(skill_id: Int) -> String {
        for s in self.skills {
            if s.skill_id == skill_id {
                return s.skill_name!
            }
        }
        return "Blank"
    }
    
    func loadSkillsFromFile() -> [Skill]?{
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Skill.ArchiveURL.path!) as? [Skill]
        
    }
    
    func loadStudentFromFile() -> Student?{
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Student.ArchiveURL.path!) as? Student
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(segue.identifier)
        if segue.identifier! == "ShowEval" {
            let studentEvalTableViewController = segue.destinationViewController as! StudentEvalTableViewController
            if let selectedEvalCell = sender as? EvalTableViewCell{
                let indexPath = evalTable.indexPathForCell(selectedEvalCell)!
                let selectedEval = student.evals![indexPath.row]
                print(selectedEval.eval_id)
                studentEvalTableViewController.selectedEval = selectedEval
            }
        }
        
    }
    

}
