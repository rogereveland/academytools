//
//  StudentEval.swift
//  Academy Tools
//
//  Created by Roger Eveland on 2/26/16.
//  Copyright © 2016 IFSI. All rights reserved.
//

import UIKit
import GRDB

class StudentEval: Record {
    //MARK: Properties
    var eval_id: Int64
    var evaluator_name: String?
    var skill_id: Int64
    var comments : String?
    var overall_results : String?
    var eval_date : String?
    
    //MARK: Initialization
    
    init?(eval_id: Int64, evaluator_name: String, skill_id: Int64, comments: String, overall_results: String, eval_date: String){
        // Initialize stored properties
        self.evaluator_name = evaluator_name
        self.skill_id = skill_id
        self.comments = comments
        self.overall_results = overall_results
        self.eval_id = eval_id
        self.eval_date = eval_date
        super.init()
        
    }
    
    required init(_ row: Row) {
        self.eval_id = row.value(named: "eval_id")
        self.evaluator_name = row.value(named: "evaluator_name")
        self.skill_id = row.value(named: "skill_id")
        self.comments = row.value(named: "comments")
        self.overall_results = row.value(named: "overall_results")
        self.eval_date = row.value(named: "eval_date")
        super.init()
    }
    
    override class func databaseTableName() -> String {
        return "skills_evaluation"
    }
    
    override var persistentDictionary: [String: DatabaseValueConvertible?] {
        return ["eval_id": eval_id, "evaluator_name": evaluator_name, "skill_id":skill_id, "comments":comments, "overall_results":overall_results, "eval_date":eval_date]
    }
    
    override func didInsertWithRowID(rowID: Int64, forColumn column: String?) {
        eval_id = rowID
    }
    
    
}