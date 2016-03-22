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
    var studentEvals = [StudentEval]()
    
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
        if networkTester.connectedToNetwork() && true {
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
                    let evaluator_name = e["evaluatorName"].string
                    let eval_id = e["eval_id"].int64
                    let comments = e["comments"].string
                    let passfail = e["passfail"].string
                    let skill_id = e["skill_id"].int64
                    let measures = e["measures"]
                    let eval_date = e["eval_date"].string
                    let sort_date = e["sort_date"].string
                    
                    for(_,m):(String, JSON) in measures{
                        let measure_desc = String.fetchOne(dbQueue,
                            "SELECT measure_desc " +
                                "FROM academy_skills_measures " +
                            "WHERE measure_id = ?"
                            , arguments:[m["measure_id"].int64])
                        let result = m["result"].string
                        let measure_id = m["measure_id"].int64!
                        let eval_id = m["eval_id"].int64!
                        let sem_id = m["sem_id"].int64!
                        let newMeasure = StudentMeasure(
                            result : result,
                            measure_id : measure_id,
                            eval_id : eval_id,
                            sem_id : sem_id,
                            measure_desc : measure_desc,
                            sort_date : eval_date
                        )
                        
                        do {
                            
                            try dbQueue.inDatabase { db in
                                let updateSQL = "UPDATE skills_evaluation_measures SET result = ?, measure_id = ?, eval_id = ?, sem_id = ?, measure_desc = ? WHERE sem_id = ?"
                                let updateStatement = try db.updateStatement(updateSQL)
                                updateStatement.arguments = [result, measure_id, eval_id, sem_id, measure_desc, sem_id]
                                let changes = try updateStatement.execute()
                                if changes.changedRowCount == 0 {
                                    try newMeasure!.insert(db)
                                }
                            }
                        } catch { "Error?"}
                    }
                    let newEval = StudentEval(eval_id:eval_id!, evaluator_name: evaluator_name!, skill_id: skill_id!, comments: comments!, overall_results: passfail!,eval_date: eval_date!)
                    
                    do {
                        try dbQueue.inDatabase { db in
                            let updateSQL = "UPDATE skills_evaluation SET eval_id = ?, evaluator_name = ?, skill_id = ?, comments = ?, overall_results = ?, eval_date = ?, student_id = ?, sort_date = ? WHERE eval_id = ?"
                            let updateStatement = try db.updateStatement(updateSQL)
                            updateStatement.arguments = [eval_id, evaluator_name, skill_id, comments, passfail, eval_date, self.student.people_id, sort_date, eval_id]
                            let changes = try updateStatement.execute()
                            if changes.changedRowCount == 0 {
                                try newEval!.insert(db)
                            }
                        }
                    } catch {}
                    
                    evalsArr.append(newEval!)
                    
                }
                
                self.student.evals = evalsArr
                self.studentEvals = StudentEval.fetchAll(dbQueue,
                            "SELECT * " +
                            "FROM skills_evaluation " +
                            "WHERE student_id = ? ORDER BY sort_date DESC"
                        , arguments:[self.student.people_id])
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.evalTable.reloadData()
                    self.loadingData.hidden = true
                })
                
            }
            task.resume()
            
            
        } else {
            self.loadingData.hidden = true
            let student = Student.fetchOne(dbQueue,
                    "SELECT * " +
                        "FROM academy_students " +
                    "WHERE people_id = ?"
                    , arguments:[self.student.people_id])
            self.student = student
            self.studentEvals = StudentEval.fetchAll(dbQueue,
                "SELECT * " +
                    "FROM skills_evaluation " +
                "WHERE student_id = ? ORDER BY sort_date DESC"
                , arguments:[self.student.people_id])
            self.loadingData.hidden = true
            dispatch_async(dispatch_get_main_queue(), {
                self.loadingData.hidden = true
            })
        }
        
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentEvals.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "evalCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as!
        EvalTableViewCell
        let studentEval = studentEvals[indexPath.row]
        let skillInfo = Skill.fetchOne(dbQueue,
                "SELECT * " +
                    "FROM academy_skills " +
                "WHERE skill_id = ?"
                , arguments:[self.studentEvals[indexPath.row].skill_id])
            
        cell.skillName.text = skillInfo!.skill_name
        
        cell.evaluatorName.text = studentEval.evaluator_name
        cell.passFail.text = studentEval.overall_results
        cell.evaluationDate.text = studentEval.eval_date
        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "ShowEval" {
            let studentEvalTableViewController = segue.destinationViewController as! StudentEvalTableViewController
            if let selectedEvalCell = sender as? EvalTableViewCell{
                let indexPath = evalTable.indexPathForCell(selectedEvalCell)!
                let selectedEval = studentEvals[indexPath.row]
                studentEvalTableViewController.selectedEval = selectedEval
            }
        }
        
    }
    

}
