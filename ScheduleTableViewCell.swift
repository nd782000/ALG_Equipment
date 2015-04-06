//
//  ScheduleTableViewCell.swift
//  Atlantic_Blank
//
//  Created by Nicholas Digiando on 4/6/15.
//  Copyright (c) 2015 Nicholas Digiando. All rights reserved.
//

import Foundation
import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    //var equipStatusIcon: UIView!
    var equipName: UILabel!
    var equipDescription: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //  equipStatusIcon = UIView(frame: CGRect(x: 10, y: 13, width: 20, height: 20))
        // equipStatusIcon.layer.cornerRadius = 10
        // equipStatusIcon.layer.masksToBounds = true
        // equipStatusIcon.backgroundColor = UIColor.greenColor()
        
        equipName = UILabel(frame: CGRect(x: 40, y: 0, width: 120, height: 50)) // not sure how to refer to the cell size here
        equipDescription = UILabel(frame: CGRect(x: 170, y: 0, width: self.bounds.width - 180, height: 50)) // not sure how to refer to the cell size here
        
        //  contentView.addSubview(equipStatusIcon)
        contentView.addSubview(equipName)
        contentView.addSubview(equipDescription)
        
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}