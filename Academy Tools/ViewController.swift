//
//  ViewController.swift
//  Academy Tools
//
//  Created by Roger Eveland on 2/25/16.
//  Copyright © 2016 IFSI. All rights reserved.
//

import UIKit
import GRDB


class ViewController: UIViewController {
    var networkTester = NetworkTester()
    var academies = [Academy]()
    var skills = [Skill]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        loadAcademies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func testButton(sender: UIButton) {
        loadAcademies()
    }
    
    
    
    
    func loadAcademies(){
        let isConnected = true
        if networkTester.connectedToNetwork() && isConnected {
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
                let skills = json["skills"]
                for (_,a):(String, JSON) in acas {
                    let name = a["group_name"].string
                    print("name " + name!)
                    let group_id = a["group_id"].int64
                    let students = a["students"]
                    
                    for(_,s):(String, JSON) in students{
                        let first_name = s["first_name"].string!
                        let last_name = s["last_name"].string!
                        let agency_name = s["agency_name"].string!
                        let people_id = s["people_id"].int64!
                        let bio_text = s["bio_text"].string!
                        let company = s["company"].string!
                        let newStudent = Student(
                            first_name: first_name,
                            last_name: last_name,
                            agency_name: agency_name,
                            people_id: people_id,
                            bio_text: bio_text,
                            company: company,
                            group_id : group_id!
                        )
                        do {
                            try dbQueue.inDatabase { db in
                                let updateSQL = "UPDATE academy_students SET first_name = ?, last_name = ?, agency_name = ?, bio_text = ?, company = ?, group_id = ? WHERE people_id = ?"
                                let updateStatement = try db.updateStatement(updateSQL)
                                updateStatement.arguments = [first_name, last_name, agency_name, bio_text, company, group_id, people_id]
                                let changes = try updateStatement.execute()
                                if changes.changedRowCount == 0 {
                                    try newStudent!.insert(db)
                                }
                            }
                        } catch let e {print(e)}
                        
                    }
                    
                    let newAcademy = Academy(group_name: name!, group_id: group_id!)
                    do {
                        try dbQueue.inDatabase { db in
                            try newAcademy!.insert(db)
                        }
                    } catch {
                        
                    }
                    
                }
                
                for(_,s):(String, JSON) in skills {
                    let skill_name = s["skill_name"].string
                    let skill_id = s["skill_id"].int64
                    let measures = s["measures"]
                    
                    for(_,m):(String,JSON) in measures {
                        let measure_id = m["measure_id"].int64
                        let measure_desc = m["measure_desc"].string
                        let newMeasure = SkillMeasure(measure_desc: measure_desc, measure_id: measure_id!)
                        do {
                            try dbQueue.inDatabase { db in
                                let updateSQL = "UPDATE academy_skills_measures SET measure_id = ?, measure_desc = ? WHERE measure_id = ?"
                                let updateStatement = try db.updateStatement(updateSQL)
                                updateStatement.arguments = [measure_id, measure_desc, measure_id]
                                let changes = try updateStatement.execute()
                                if changes.changedRowCount == 0 {
                                    try newMeasure!.insert(db)
                                } 
                                
                            }
                        } catch {
                            
                        }
                    }
                    let newSkill = Skill(skill_name: skill_name!, skill_id: skill_id!)
                    do {
                        try dbQueue.inDatabase { db in
                            let updateSQL = "UPDATE academy_skills SET skill_id = ?, skill_name = ? WHERE skill_id = ?"
                            let updateStatement = try db.updateStatement(updateSQL)
                            updateStatement.arguments = [skill_id, skill_name, skill_id]
                            let changes = try updateStatement.execute()
                            if changes.changedRowCount == 0 {
                                try newSkill!.insert(db)
                            }
                        }
                    } catch {}
                }
                
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("ShowAcademyList", sender: "AnyObject?")
                })
                
            }
            task.resume()
            
            
        } else {
            
            
            print("Loading from file")
            
            
            dispatch_async(dispatch_get_main_queue(), {
                self.performSegueWithIdentifier("ShowAcademyList", sender: "AnyObject?")
            })
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        try dbQueue.inDatabase { db in
            /*
            for a in Academy.fetchAll(db, "SELECT * FROM academy") {
            print(a.group_name)
            }
            */
            self.academies = Academy.fetchAll(db, "SELECT * FROM academy")
        }
        let navController = segue.destinationViewController as! UINavigationController
        let academyTableViewController = navController.topViewController as! AcademyTableViewController
        academyTableViewController.academies = academies
    }
}

