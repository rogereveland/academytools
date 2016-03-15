import UIKit
import GRDB

class SkillMeasure: Record {
    //MARK: Properties
    var measure_desc: String?
    var measure_id: Int64
    
    
    init?(measure_desc: String?, measure_id: Int64){
        // Initialize stored properties
        self.measure_desc = measure_desc
        self.measure_id = measure_id
        super.init()
        
    }
    
    required init(_ row: Row) {
        self.measure_desc = row.value(named: "measure_desc")
        self.measure_id = row.value(named: "measure_id")
        super.init()
    }
    
    override class func databaseTableName() -> String {
        return "academy_skills_measures"
    }
    
    override var persistentDictionary: [String: DatabaseValueConvertible?] {
        return ["measure_id": measure_id, "measure_desc": measure_desc]
    }
    
    override func didInsertWithRowID(rowID: Int64, forColumn column: String?) {
        measure_id = rowID
    }
}