import GRDB

// The columns for the GRDB Query Interface
//
// See https://github.com/groue/GRDB.swift/#the-query-interface

struct Col {
    static let id = SQLColumn("id")
    static let firstName = SQLColumn("firstName")
    static let lastName = SQLColumn("lastName")
}


// The shared database queue, stored in a global.
// It is initialized in setupDatabase()

var dbQueue: DatabaseQueue!

func setupDatabase() {
    
    // Connect to the database
    //
    // See https://github.com/groue/GRDB.swift/#database-queues
    
    let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as NSString
    let databasePath = documentsPath.stringByAppendingPathComponent("db.sqlite")
    dbQueue = try! DatabaseQueue(path: databasePath)
    
    
    // SQLite does not support Unicode: let's add a custom collation which will
    // allow us to sort persons by name.
    //
    // See https://github.com/groue/GRDB.swift/#string-comparison
    
    let collation = DatabaseCollation("localized_case_insensitive") { (lhs, rhs) in
        return (lhs as NSString).localizedCaseInsensitiveCompare(rhs)
    }
    dbQueue.addCollation(collation)
    
    
    // Use DatabaseMigrator to setup the database
    //
    // See https://github.com/groue/GRDB.swift/#migrations
    
    var migrator = DatabaseMigrator()
    migrator.registerMigration("createAcademy") { db in
        try db.execute(
            "CREATE TABLE academy (" +
                "group_id INTEGER PRIMARY KEY, " +
                "group_name TEXT COLLATE localized_case_insensitive " +
            ")")
    }
    
    migrator.registerMigration("createSkills") { db in
        try db.execute(
            "CREATE TABLE academy_skills (" +
                "skill_id INTEGER PRIMARY KEY, " +
                "skill_name TEXT COLLATE localized_case_insensitive, " +
                "skill_desc TEXT COLLATE localized_case_insensitive, " +
                "active INTEGER " +
            ")")
    }
    
    migrator.registerMigration("createMeasures") { db in
        try db.execute(
            "CREATE TABLE academy_skills_measures (" +
                "measure_id INTEGER PRIMARY KEY, " +
                "measure_desc TEXT COLLATE localized_case_insensitive, " +
                "skill_id INTEGER " +
            ")")
    }
    
    migrator.registerMigration("createStudents") { db in
        try db.execute(
            "CREATE TABLE academy_students (" +
                "people_id INTEGER PRIMARY KEY, " +
                "first_name TEXT COLLATE localized_case_insensitive, " +
                "last_name TEXT COLLATE localized_case_insensitive, " +
                "agency_name TEXT COLLATE localized_case_insensitive, " +
                "bio_text TEXT COLLATE localized_case_insensitive, " +
                "company TEXT COLLATE localized_case_insensitive, " +
                "group_id INTEGER " +
            ")")
    }

    
    migrator.registerMigration("createEvals") { db in
        try db.execute(
            "CREATE TABLE skills_evaluation (" +
                "eval_id INTEGER PRIMARY KEY, " +
                "student_id INTEGER, " +
                "evaluator_id INTEGER, " +
                "evaluator_name TEXT COLLATE localized_case_insensitive, " +
                "eval_date TEXT COLLATE localized_case_insensitive, " +
                "overall_results TEXT COLLATE localized_case_insensitive, " +
                "comments TEXT COLLATE localized_case_insensitive " +
            ")")
    }
    
    migrator.registerMigration("AddSkillsToEvals") { db in
        try db.execute(
            "ALTER TABLE skills_evaluation ADD COLUMN skill_id INTEGER")
    }
    
    migrator.registerMigration("createEvalMeasures") { db in
        try db.execute(
            "CREATE TABLE skills_evaluation_measures (" +
                "sem_id INTEGER PRIMARY KEY, " +
                "eval_id INTEGER, " +
                "measure_id INTEGER, " +
                "result TEXT COLLATE localized_case_insensitive " +
            ")")
    }
    
    migrator.registerMigration("AddMeasureDesc") { db in
        try db.execute(
            "ALTER TABLE skills_evaluation_measures ADD COLUMN measure_desc TEXT")
    }
    
    migrator.registerMigration("createUpdateHistory") { db in
        try db.execute(
            "CREATE TABLE update_history (" +
                "eval_update TIMESTAMP " +
                "skills_update TIMESTAMP " +
            ")"
        )
        
    }
    
    migrator.registerMigration("AddSortDate") { db in
        try db.execute(
            "ALTER TABLE skills_evaluation ADD COLUMN sort_date TIMESTAMP")
    }
    
    
    try! migrator.migrate(dbQueue)
    /*
    migrator.registerMigration("addPersons") { db in
        try Person(firstName: "Arthur", lastName: "Miller").insert(db)
        try Person(firstName: "Barbra", lastName: "Streisand").insert(db)
        try Person(firstName: "Cinderella").insert(db)
    }
    try! migrator.migrate(dbQueue)
    */
}