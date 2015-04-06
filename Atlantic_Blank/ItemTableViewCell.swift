//
//  ItemTableViewCell.swift
//  Atlantic_Blank
//
//  Created by Nicholas Digiando on 4/6/15.
//  Copyright (c) 2015 Nicholas Digiando. All rights reserved.
//

import Foundation
import UIKit

class ItemTableViewCell: UITableViewCell {
    
    //var equipStatusIcon: UIView!
    var itemName: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        itemName = UILabel(frame: CGRect(x: 40, y: 0, width: 120, height: 50)) // not sure how to refer to the cell size here
        //  contentView.addSubview(equipStatusIcon)
        //  equipStatusIcon = UIView(frame: CGRect(x: 10, y: 13, width: 20, height: 20))
        // equipStatusIcon.layer.cornerRadius = 10
        // equipStatusIcon.layer.masksToBounds = true
        // equipStatusIcon.backgroundColor = UIColor.greenColor()
        contentView.addSubview(itemName)
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