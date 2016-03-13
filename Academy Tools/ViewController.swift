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
        // Do any additional setup after loading the view, typically from a nib.
        //loadAcademies()
        
    }
    
    override func viewWillAppear(animated: Bool) {
       /* 
        self.academies = loadAcademiesFromFile()!
        self.skills = loadSkillsFromFile()!
        dispatch_async(dispatch_get_main_queue(), {
            print("Why are you still here?")
            self.performSegueWithIdentifier("ShowAcademyList", sender: "AnyObject?")
        })
        */
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
                let json = JSON(data: data!) as! JSON
                let acas = json["academies"]
                let skills = json["skills"]
                for (_,a):(String, JSON) in acas {
                    let name = a["group_name"].string
                    print("name " + name!)
                    let group_id = a["group_id"].int64
                    let students = a["students"]
                    var studentsArr = [Student]()
                    
                    for(_,s):(String, JSON) in students{
                        let newStudent = Student(
                            first_name: s["first_name"].string!,
                            last_name: s["last_name"].string!,
                            agency_name: s["agency_name"].string!,
                            people_id: s["people_id"].int!,
                            bio_text: s["bio_text"].string!,
                            company: s["company"].string!,
                            evals : []
                        )
                        studentsArr.append(newStudent!)
                    }
                    let newAcademy = Academy(group_name: name!, group_id: group_id!)
                    do {
                        try dbQueue.inDatabase { db in
                            try newAcademy!.insert(db)
                        }
                    } catch {
                        
                    }
                    /*
                    self.academies.append(newAcademy!)
                    do {
                        try dbQueue.inDatabase { db in
                            let groupID = try db.execute("INSERT INTO academy (group_id, group_name) VALUES (?, ?)",
                                arguments: [group_id, name]).insertedRowID
                        }
                    } catch {
                        
                    }
                    */
                    
                }
                for(_,s):(String, JSON) in skills {
                    let skill_name = s["skill_name"].string
                    let skill_id = s["skill_id"].int
                    var measuresArr = [SkillMeasure]()
                    let measures = s["measures"]
                    for(_,m):(String,JSON) in measures {
                        let measure_id = m["measure_id"].int
                        let measure_desc = m["measure_desc"].string
                        let newMeasure = SkillMeasure(measure_desc: measure_desc, measure_id: measure_id!)
                        measuresArr.append(newMeasure!)
                    }
                    let newSkill = Skill(skill_name: skill_name!, skill_id: skill_id!, measures: measuresArr)
                    self.skills.append(newSkill!)
                }
                /*
                self.saveAcademies()
                self.saveSkills()
                */
                self.skills = self.loadSkillsFromFile()!
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("ShowAcademyList", sender: "AnyObject?")
                })
                
            }
            task.resume()
            
            
        } else {
            //self.academies = self.loadAcademiesFromFile()!
            self.skills = self.loadSkillsFromFile()!
            
            print("Loading from file")
            
            
            dispatch_async(dispatch_get_main_queue(), {
                self.performSegueWithIdentifier("ShowAcademyList", sender: "AnyObject?")
            })
            
        }
        
        
        /*
        
        try dbQueue.inDatabase { db in
            let groupID = try db.execute("INSERT INTO academy (group_id, group_name) VALUES (?, ?)",
                arguments: [group_id, name]).insertedRowID
        } catch{}
        */
        
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
    
    func saveAcademies(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(academies, toFile: Academy.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save")
        }
    }
    
    func saveSkills(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(skills, toFile: Skill.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save")
        }
    }
    func loadAcademiesFromFile() -> [Academy]?{
        print("Loading Academies...")
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Academy.ArchiveURL.path!) as? [Academy]
        
    }
    func loadSkillsFromFile() -> [Skill]?{
        print("Loading Skills...")
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Skill.ArchiveURL.path!) as? [Skill]
        
    }
}

