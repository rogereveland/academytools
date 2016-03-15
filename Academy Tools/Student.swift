//
//  Student.swift
//  Academy Tools
//
//  Created by Roger Eveland on 2/26/16.
//  Copyright © 2016 IFSI. All rights reserved.
//

import UIKit
import GRDB

class Student: Record {
    //MARK: Properties
    var first_name: String?
    var last_name: String?
    var agency_name: String?
    var people_id: Int64
    var bio_text: String?
    var company: String?
    var group_id: Int64?
    var evals : [StudentEval]?
    
    
    
    //MARK: Initialization
    
    
    
    init?(first_name: String, last_name: String, agency_name: String, people_id: Int64, bio_text: String, company: String, group_id: Int64){
        // Initialize stored properties
        self.first_name = first_name
        self.last_name = last_name
        self.agency_name = agency_name
        self.people_id = people_id
        self.bio_text = bio_text
        self.company = company
        self.group_id = group_id
        super.init()
     }

    required init(_ row: Row) {
        self.first_name = row.value(named: "first_name")
        self.last_name = row.value(named: "last_name")
        self.agency_name = row.value(named: "agency_name")
        self.people_id = row.value(named: "people_id")
        self.bio_text = row.value(named: "bio_text")
        self.company = row.value(named: "company")
        self.group_id = row.value(named: "group_id")
        
        //self.students = row.value(named: "students")
        super.init()
    }
    
    override class func databaseTableName() -> String {
        return "academy_students"
    }
    
    override var persistentDictionary: [String: DatabaseValueConvertible?] {
        return ["first_name": first_name, "last_name": last_name, "agency_name": agency_name, "people_id" : people_id, "bio_text" : bio_text, "company" : company, "group_id": group_id ]
    }
    
    override func didInsertWithRowID(rowID: Int64, forColumn column: String?) {
        people_id = rowID
    }
    
    
}
