//
//  Academy.swift
//  Academy Tools
//
//  Created by Roger Eveland on 2/25/16.
//  Copyright © 2016 IFSI. All rights reserved.
//


import UIKit

class Academy: NSObject, NSCoding {
    //MARK: Properties
    var name: String?
    var group_id: Int
    var students: [Student]?
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("academies")
    
    //MARK: Initialization
    struct PropertyKey{
        static let nameKey = "name"
        static let group_idKey = "group_id"
        static let studentsKey = "students"
    }
    
    init?(name: String, group_id: Int, students: [Student]){
        // Initialize stored properties
        self.name = name
        self.group_id = group_id
        self.students = students
        super.init()
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeInteger(group_id, forKey: PropertyKey.group_idKey)
        aCoder.encodeObject(students, forKey: PropertyKey.studentsKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let group_id = aDecoder.decodeIntegerForKey(PropertyKey.group_idKey)
        let students = aDecoder.decodeObjectForKey(PropertyKey.studentsKey) as! [Student]
        self.init(name:name, group_id:group_id,students:students)
    }
}