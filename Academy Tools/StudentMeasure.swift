import UIKit

class StudentMeasure: NSObject, NSCoding {
    //MARK: Properties
    var result: String?
    var measure_id: Int
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("measures")
    
    //MARK: Initialization
    struct PropertyKey{
        static let measureDescKey = "result"
        static let measureIdKey = "measure_id"
    }
    
    init?(result: String?, measure_id: Int){
        // Initialize stored properties
        self.result = result
        self.measure_id = measure_id
        super.init()
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(result, forKey: PropertyKey.measureDescKey)
        aCoder.encodeInteger(measure_id, forKey: PropertyKey.measureIdKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let result = aDecoder.decodeObjectForKey(PropertyKey.measureDescKey) as? String
        let measure_id = aDecoder.decodeIntegerForKey(PropertyKey.measureIdKey)
        self.init(result:result, measure_id:measure_id)
    }
}