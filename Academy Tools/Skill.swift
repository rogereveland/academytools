//
//  Skill.swift
//  Academy Tools
//
//  Created by Roger Eveland on 2/26/16.
//  Copyright © 2016 IFSI. All rights reserved.
//

import UIKit

class Skill: NSObject, NSCoding {
    //MARK: Properties
    var skill_name: String?
    var skill_id: Int
    var measures: [SkillMeasure]?
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("skills")
    
    //MARK: Initialization
    struct PropertyKey{
        static let skillNameKey = "skill_name"
        static let skillIdKey = "skill_id"
        static let measuresKey = "measures"
    }
    
    init?(skill_name: String, skill_id: Int, measures: [SkillMeasure]){
        // Initialize stored properties
        self.skill_name = skill_name
        self.skill_id = skill_id
        self.measures = measures
        super.init()
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(skill_name, forKey: PropertyKey.skillNameKey)
        aCoder.encodeInteger(skill_id, forKey: PropertyKey.skillIdKey)
        aCoder.encodeObject(measures, forKey: PropertyKey.measuresKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let skill_name = aDecoder.decodeObjectForKey(PropertyKey.skillNameKey) as! String
        let skill_id = aDecoder.decodeIntegerForKey(PropertyKey.skillIdKey)
        let measures = aDecoder.decodeObjectForKey(PropertyKey.measuresKey) as! [SkillMeasure]
        self.init(skill_name:skill_name, skill_id:skill_id, measures:measures)
    }
}