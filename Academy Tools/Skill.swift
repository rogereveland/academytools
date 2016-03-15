//
//  Skill.swift
//  Academy Tools
//
//  Created by Roger Eveland on 2/26/16.
//  Copyright © 2016 IFSI. All rights reserved.
//

import UIKit
import GRDB

class Skill: Record {
    //MARK: Properties
    var skill_name: String?
    var skill_id: Int64
    
   
    
    //MARK: Initialization
   
    
    init?(skill_name: String, skill_id: Int64){
        // Initialize stored properties
        self.skill_name = skill_name
        self.skill_id = skill_id
        super.init()
        
    }
    
    required init(_ row: Row) {
        self.skill_name = row.value(named: "skill_name")
        self.skill_id = row.value(named: "skill_id")
        //self.students = row.value(named: "students")
        super.init()
    }
    
    override class func databaseTableName() -> String {
        return "academy_skills"
    }
    
    override var persistentDictionary: [String: DatabaseValueConvertible?] {
        return ["skill_id": skill_id, "skill_name": skill_name]
    }
    
    override func didInsertWithRowID(rowID: Int64, forColumn column: String?) {
        skill_id = rowID
    }
    
}