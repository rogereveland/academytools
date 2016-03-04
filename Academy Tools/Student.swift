//
//  Student.swift
//  Academy Tools
//
//  Created by Roger Eveland on 2/26/16.
//  Copyright © 2016 IFSI. All rights reserved.
//

import UIKit

class Student: NSObject, NSCoding {
    //MARK: Properties
    var first_name: String?
    var last_name: String?
    var agency_name: String?
    var people_id: Int
    var bio_text: String?
    var company: String?
    var evals : [StudentEval]?
    
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("students")
    
    //MARK: Initialization
    struct PropertyKey{
        static let firstNameKey = "first_name"
        static let lastNameKey = "last_name"
        static let agencyNameKey = "agency_name"
        static let peopleIdKey = "people_id"
        static let bioTextKey = "bio_text"
        static let companyKey = "company"
        static let evalsKey = "evals"
    }
    
    init?(first_name: String, last_name: String, agency_name: String, people_id: Int, bio_text: String, company: String, evals:[StudentEval]){
        // Initialize stored properties
        self.first_name = first_name
        self.last_name = last_name
        self.agency_name = agency_name
        self.people_id = people_id
        self.bio_text = bio_text
        self.company = company
        self.evals = evals
        super.init()
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(first_name, forKey: PropertyKey.firstNameKey)
        aCoder.encodeObject(last_name, forKey: PropertyKey.lastNameKey)
        aCoder.encodeObject(agency_name, forKey: PropertyKey.agencyNameKey)
        aCoder.encodeObject(bio_text, forKey: PropertyKey.bioTextKey)
        aCoder.encodeObject(company, forKey: PropertyKey.companyKey)
        aCoder.encodeInteger(people_id, forKey: PropertyKey.peopleIdKey)
        aCoder.encodeObject(evals, forKey: PropertyKey.evalsKey)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let first_name = aDecoder.decodeObjectForKey(PropertyKey.firstNameKey) as! String
        let last_name = aDecoder.decodeObjectForKey(PropertyKey.lastNameKey) as! String
        let agency_name = aDecoder.decodeObjectForKey(PropertyKey.agencyNameKey) as! String
        let bio_text = aDecoder.decodeObjectForKey(PropertyKey.bioTextKey) as! String
        let company = aDecoder.decodeObjectForKey(PropertyKey.companyKey) as! String
        let people_id = aDecoder.decodeIntegerForKey(PropertyKey.peopleIdKey)
        let evals = aDecoder.decodeObjectForKey(PropertyKey.evalsKey) as! [StudentEval]
        
        self.init(first_name:first_name, last_name:last_name, agency_name:agency_name, people_id:people_id, bio_text:bio_text, company:company, evals:evals)
    }
}
