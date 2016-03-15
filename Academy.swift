//
//  Academy.swift
//  Academy Tools
//
//  Created by Roger Eveland on 2/25/16.
//  Copyright © 2016 IFSI. All rights reserved.
//


import UIKit
import GRDB

class Academy: Record {
    //MARK: Properties
    var group_name: String?
    var group_id: Int64
    //var students: [Student]?
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("academies")
    
    //MARK: Initialization
    /*
    struct PropertyKey{
        static let group_nameKey = "group_name"
        static let group_idKey = "group_id"
        static let studentsKey = "students"
    }
    */

    init?(group_name: String, group_id: Int64){
        // Initialize stored properties
        self.group_name = group_name
        self.group_id = group_id
        super.init()
        
    }
    
    required init(_ row: Row) {
        self.group_name = row.value(named: "group_name")
        self.group_id = row.value(named: "group_id")
        //self.students = row.value(named: "students")
        super.init()
    }
    
    override class func databaseTableName() -> String {
        return "academy"
    }
    
    override var persistentDictionary: [String: DatabaseValueConvertible?] {
        return ["group_id": group_id, "group_name": group_name]
    }
    
    override func didInsertWithRowID(rowID: Int64, forColumn column: String?) {
        group_id = rowID
    }
    
    /*
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
    */
}