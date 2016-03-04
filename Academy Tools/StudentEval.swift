//
//  StudentEval.swift
//  Academy Tools
//
//  Created by Roger Eveland on 2/26/16.
//  Copyright © 2016 IFSI. All rights reserved.
//

import UIKit

class StudentEval: NSObject, NSCoding {
    //MARK: Properties
    var eval_id: Int
    var evaluatorName: String?
    var skill_id: Int
    var measures: [StudentMeasure]?
    var comments : String?
    var passfail : String?
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("studentEvals")
    
    //MARK: Initialization
    struct PropertyKey{
        static let skillNameKey = "evaluatorName"
        static let skillIdKey = "skill_id"
        static let measuresKey = "measures"
        static let commentsKey = "comments"
        static let passfailKey = "passfail"
        static let evalIDKey = "eval_id"
    }
    
    init?(eval_id: Int, evaluatorName: String, skill_id: Int, measures: [StudentMeasure], comments: String, passfail: String){
        // Initialize stored properties
        self.evaluatorName = evaluatorName
        self.skill_id = skill_id
        self.measures = measures
        self.comments = comments
        self.passfail = passfail
        self.eval_id = eval_id
        super.init()
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(evaluatorName, forKey: PropertyKey.skillNameKey)
        aCoder.encodeInteger(skill_id, forKey: PropertyKey.skillIdKey)
        aCoder.encodeObject(measures, forKey: PropertyKey.measuresKey)
        aCoder.encodeObject(comments, forKey: PropertyKey.commentsKey)
        aCoder.encodeObject(passfail, forKey: PropertyKey.passfailKey)
        aCoder.encodeInteger(eval_id, forKey: PropertyKey.evalIDKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let evaluatorName = aDecoder.decodeObjectForKey(PropertyKey.skillNameKey) as! String
        let skill_id = aDecoder.decodeIntegerForKey(PropertyKey.skillIdKey)
        let measures = aDecoder.decodeObjectForKey(PropertyKey.measuresKey) as! [StudentMeasure]
        let comments = aDecoder.decodeObjectForKey(PropertyKey.commentsKey) as! String
        let passfail = aDecoder.decodeObjectForKey(PropertyKey.passfailKey) as! String
        let eval_id = aDecoder.decodeIntegerForKey(PropertyKey.evalIDKey)
        self.init(eval_id: eval_id, evaluatorName:evaluatorName, skill_id:skill_id, measures:measures, comments:comments, passfail:passfail)
    }
}