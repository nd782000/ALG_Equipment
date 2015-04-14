//
//  EquipmentTableViewCell.swift
//  Atlantic_Blank
//
//  Created by Nicholas Digiando on 4/6/15.
//  Copyright (c) 2015 Nicholas Digiando. All rights reserved.
//

import Foundation
import UIKit

class EquipmentTableViewCell: UITableViewCell {
    var id:String!
    var equipStatusIcon: UIView! = UIView()
    var nameLbl: UILabel! = UILabel()
    var typeNameLbl: UILabel! = UILabel()
    var makeLbl: UILabel! = UILabel()
    var crewLbl: UILabel! = UILabel()
    
    var layoutVars:LayoutVars = LayoutVars()
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        equipStatusIcon.layer.cornerRadius = 10
        equipStatusIcon.layer.masksToBounds = true
        equipStatusIcon.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addSubview(equipStatusIcon)
        
        
        nameLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        typeNameLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        makeLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        crewLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        
        contentView.addSubview(nameLbl)
        contentView.addSubview(typeNameLbl)
        contentView.addSubview(makeLbl)
        contentView.addSubview(crewLbl)
        
        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero
        self.preservesSuperviewLayoutMargins = false
        
        let viewsDictionary = ["status":equipStatusIcon,"name":nameLbl,"type":typeNameLbl,"make":makeLbl,"crew":crewLbl]
        
        let viewsConstraint_V:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[status(20)]", options: nil, metrics: nil, views: viewsDictionary)
        
        let viewsConstraint_H:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[status(20)]-[name]-[type]-[make]-[crew]-10-|", options: NSLayoutFormatOptions.AlignAllTop, metrics: nil, views: viewsDictionary)
        
        contentView.addConstraints(viewsConstraint_H)
        contentView.addConstraints(viewsConstraint_V)
        
    }
    
    
    
    func setStatus(status: String) {
        
        switch (status) {
        case "2":
            equipStatusIcon.backgroundColor = UIColor.redColor()//out of service
            break;
        case "3":
            equipStatusIcon.backgroundColor = UIColor.orangeColor()//needs repair
            break;
        case "4":
            equipStatusIcon.backgroundColor = UIColor.blueColor()//winterized
            break;
            
        default:
            equipStatusIcon.backgroundColor = UIColor.greenColor()//online
            break;
        }
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}