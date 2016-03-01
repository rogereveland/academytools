//
//  Instructor.swift
//  Academy Tools
//
//  Created by Roger Eveland on 2/25/16.
//  Copyright © 2016 IFSI. All rights reserved.
//


import UIKit

class Instructor: NSObject, NSCoding {
    //MARK: Properties
    var instructorName: String?
    var instructorID: Int
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("instructor")
    
    //MARK: Initialization
    struct PropertyKey{
        static let instructorNameKey = "instructorName"
        static let instructorIDKey = "instructorID"
    }
    
    init?(instructorName: String, instructorID: Int){
        // Initialize stored properties
        self.instructorName = instructorName
        self.instructorID = instructorID
        super.init()
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(instructorName, forKey: PropertyKey.instructorNameKey)
        aCoder.encodeInteger(instructorID, forKey: PropertyKey.instructorIDKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let instructorName = aDecoder.decodeObjectForKey(PropertyKey.instructorNameKey) as! String
        let instructorID = aDecoder.decodeIntegerForKey(PropertyKey.instructorIDKey)
        self.init(instructorName:instructorName, instructorID:instructorID)
    }
}