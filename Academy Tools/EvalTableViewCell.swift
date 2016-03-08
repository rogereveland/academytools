//
//  EvalTableViewCell.swift
//  Academy Tools
//
//  Created by Roger Eveland on 2/25/16.
//  Copyright © 2016 IFSI. All rights reserved.
//

import UIKit

class EvalTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var evaluatorName: UILabel!
    @IBOutlet weak var evaluationDate: UILabel!
    @IBOutlet weak var skillName: UILabel!
    @IBOutlet weak var passFail: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}