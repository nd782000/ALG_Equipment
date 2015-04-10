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
    var equipStatusIcon: UIView!
    var nameLbl: UILabel!
    var typeNameLbl: UILabel!
    var makeLbl: UILabel!
    var crewLbl: UILabel!
    
    var layoutVars:LayoutVars = LayoutVars()
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        /*
        equipStatusIcon = UIView(frame: CGRect(x: 10, y: 13, width: 20, height: 20))
        equipStatusIcon.layer.cornerRadius = 10
        equipStatusIcon.layer.masksToBounds = true
        contentView.addSubview(equipStatusIcon)
        nameLbl = UILabel(frame: CGRect(x: 40, y: 0, width: 120, height: 50)) // not sure how to refer to the cell size here
        typeNameLbl = UILabel(frame: CGRect(x: 40, y: 20, width: self.bounds.width - 180, height: 50)) // not sure how to refer to the cell size here
        makeLbl = UILabel(frame: CGRect(x: 170, y: 0, width: self.bounds.width - 180, height: 50)) // not sure how to refer to the cell size here
        crewLbl = UILabel(frame: CGRect(x: 170, y: 20, width: self.bounds.width - 180, height: 50)) // not sure how to refer to the cell size here
        */
        
        equipStatusIcon = UIView()
        equipStatusIcon.layer.cornerRadius = 10
        equipStatusIcon.layer.masksToBounds = true
        equipStatusIcon.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addSubview(equipStatusIcon)
        
        
        nameLbl = UILabel() // not sure how to refer to the cell size here
        typeNameLbl = UILabel() // not sure how to refer to the cell size here
        makeLbl = UILabel() // not sure how to refer to the cell size here
        crewLbl = UILabel() // not sure how to refer to the cell size here
        
        nameLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        typeNameLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        makeLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        crewLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        
        contentView.addSubview(nameLbl)
        contentView.addSubview(typeNameLbl)
        contentView.addSubview(makeLbl)
        contentView.addSubview(crewLbl)
        
        
        
        
        /////////  Auto Layout   //////////////////////////////////////
        //apply to each view
        //itemsTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        //auto layout group
        let viewsDictionary = ["view1":equipStatusIcon,"view2":nameLbl,"view3":typeNameLbl,"view4":makeLbl,"view5":crewLbl]
        
        //let metricsDictionary = ["fullWidth": layoutVars.fullWidth - 20]
        //let fullWidth = metricsDictionary["fullWidth"]
        //println("fullWidth = \(fullWidth)")
        // piePrice["Apple"]
        
        
        //size constraint
        let statusIconConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view1(20)]", options: nil, metrics: nil, views: viewsDictionary)
        let statusIconConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view1(20)]", options: nil, metrics: nil, views: viewsDictionary)
        equipStatusIcon.addConstraints(statusIconConstraint_H as [AnyObject])
        equipStatusIcon.addConstraints(statusIconConstraint_V as [AnyObject])
        
        let nameLblConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view2(50)]", options: nil, metrics: nil, views: viewsDictionary)
        let nameLblConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view2(20)]", options: nil, metrics: nil, views: viewsDictionary)
        nameLbl.addConstraints(nameLblConstraint_H as [AnyObject])
        nameLbl.addConstraints(nameLblConstraint_V as [AnyObject])
        
        let typeNameLblConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view3(60)]", options: nil, metrics: nil, views: viewsDictionary)
        let typeNameLblConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view3(20)]", options: nil, metrics: nil, views: viewsDictionary)
        typeNameLbl.addConstraints(typeNameLblConstraint_H as [AnyObject])
        typeNameLbl.addConstraints(typeNameLblConstraint_V as [AnyObject])
        
        let makeLblConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view4(100)]", options: nil, metrics: nil, views: viewsDictionary)
        let makeLblConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view4(20)]", options: nil, metrics: nil, views: viewsDictionary)
        makeLbl.addConstraints(makeLblConstraint_H as [AnyObject])
        makeLbl.addConstraints(makeLblConstraint_V as [AnyObject])
        
        let crewLblConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view5(50)]", options: nil, metrics: nil, views: viewsDictionary)
        let crewLblConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view5(20)]", options: nil, metrics: nil, views: viewsDictionary)
        crewLbl.addConstraints(crewLblConstraint_H as [AnyObject])
        crewLbl.addConstraints(crewLblConstraint_V as [AnyObject])
        
        
        
        
        
        //auto layout position constraints
        let viewsConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[view1]", options: nil, metrics: nil, views: viewsDictionary)
        
        let viewsConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view1]-[view2]-[view3]-[view4]-[view5]-|", options: NSLayoutFormatOptions.AlignAllTop, metrics: nil, views: viewsDictionary)
        
        
        contentView.addConstraints(viewsConstraint_H as [AnyObject])
        contentView.addConstraints(viewsConstraint_V as [AnyObject])
        
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