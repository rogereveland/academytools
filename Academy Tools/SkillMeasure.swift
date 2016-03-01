import UIKit

class SkillMeasure: NSObject, NSCoding {
    //MARK: Properties
    var measure_desc: String?
    var measure_id: Int
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("measures")
    
    //MARK: Initialization
    struct PropertyKey{
        static let measureDescKey = "measure_desc"
        static let measureIdKey = "measure_id"
    }
    
    init?(measure_desc: String?, measure_id: Int){
        // Initialize stored properties
        self.measure_desc = measure_desc
        self.measure_id = measure_id
        super.init()
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(measure_desc, forKey: PropertyKey.measureDescKey)
        aCoder.encodeInteger(measure_id, forKey: PropertyKey.measureIdKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let measure_desc = aDecoder.decodeObjectForKey(PropertyKey.measureDescKey) as? String
        let measure_id = aDecoder.decodeIntegerForKey(PropertyKey.measureIdKey)
        self.init(measure_desc:measure_desc, measure_id:measure_id)
    }
}