//
//  UsageTableViewCell.swift
//  Atlantic_Blank
//
//  Created by nicholasdigiando on 4/9/15.
//  Copyright (c) 2015 Nicholas Digiando. All rights reserved.
//


import Foundation
import UIKit

class UsageTableViewCell: UITableViewCell {
    
    //var equipStatusIcon: UIView!
    var usageNameLbl: Label!
    var usageTotalLbl: Label!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        var layoutVars : LayoutVars = LayoutVars()
        usageNameLbl = Label(titleText: "") // not sure how to refer to the cell size here
        usageTotalLbl = Label(titleText: "") // not sure how to refer to the cell size here
        contentView.addSubview(usageNameLbl)
        contentView.addSubview(usageTotalLbl)
        
        /////////  Auto Layout   //////////////////////////////////////
        println("usage table view cell")
        //auto layout group
        let usageViewsDictionary = ["view1": self.usageNameLbl,"view2": self.usageTotalLbl]
        
        let metricsDictionary = ["halfWidth": (layoutVars.fullWidth - 30) / 2,]
        
               //size constraint
        let usageCellConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[view1(125)]-5-[view2(150)]-|", options: nil, metrics: metricsDictionary, views: usageViewsDictionary)
        contentView.addConstraints(usageCellConstraint_H)

        let usageCellConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-7-[view1(30)]", options: nil, metrics: metricsDictionary, views: usageViewsDictionary)
        contentView.addConstraints(usageCellConstraint_V)
        let usageCellConstraint_V2:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-7-[view2(30)]", options: nil, metrics: metricsDictionary, views: usageViewsDictionary)
        contentView.addConstraints(usageCellConstraint_V2)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}