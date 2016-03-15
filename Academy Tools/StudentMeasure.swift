import UIKit
import GRDB

class StudentMeasure: Record {
    //MARK: Properties
    var sem_id : Int64
    var eval_id: Int64
    var result: String?
    var measure_id: Int64
    var measure_desc: String?
    
    //MARK: Initialization
    init?(result: String?, measure_id: Int64, eval_id: Int64, sem_id: Int64, measure_desc: String?){
        // Initialize stored properties
        self.result = result
        self.measure_id = measure_id
        self.sem_id = sem_id
        self.eval_id = eval_id
        self.measure_desc = measure_desc
        super.init()
        
    }
    
    required init(_ row: Row) {
        self.sem_id = row.value(named: "sem_id")
        self.measure_id = row.value(named: "measure_id")
        self.eval_id = row.value(named: "eval_id")
        self.result = row.value(named: "result")
        self.measure_desc = row.value(named: "measure_desc")
        super.init()
    }
    
    override class func databaseTableName() -> String {
        return "skills_evaluation_measures"
    }
    
    override var persistentDictionary: [String: DatabaseValueConvertible?] {
        return ["sem_id": sem_id, "eval_id": eval_id, "result": result, "measure_id":measure_id, "measure_desc":measure_desc]
    }
    
    override func didInsertWithRowID(rowID: Int64, forColumn column: String?) {
        measure_id = rowID
    }
    
    
}