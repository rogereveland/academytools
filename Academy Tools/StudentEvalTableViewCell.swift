//
//  StudentEvalTableViewCell.swift
//  Academy Tools
//
//  Created by Roger Eveland on 3/7/16.
//  Copyright © 2016 IFSI. All rights reserved.
//

import UIKit


class StudentEvalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var measureDesc: UILabel!
    @IBOutlet weak var passFailSwitch: UISwitch!
    @IBOutlet weak var passFailLabel: UILabel!
    weak var cellDelegate: SettingCellDelegate?
    @IBAction func togglePassFail(sender: UISwitch) {
        self.cellDelegate?.didChangeSwitchState(sender: self, isOn:passFailSwitch.on)
    }
    
    
    
    
    @IBAction func handledSwitchChange(sender: UISwitch) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
