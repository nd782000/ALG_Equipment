//
//  LayoutVars.swift
//  Atlantic_Blank
//
//  Created by Nicholas Digiando on 4/6/15.
//  Copyright (c) 2015 Nicholas Digiando. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    
    convenience init(hex: Int) {
        
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
        
    }
    
}


class LayoutVars: UIViewController {
    
    //var backgroundColor:UIColor = uicolorFromHex(0xffccff)
    //var buttonColor1:UIColor = uicolorFromHex(0x005100)
    
    var fullWidth:CGFloat = 0
    
    var navAndStatusBarHeight = 64
    var backgroundColor:UIColor = UIColor(hex:0xFFF8E6)
    var buttonBackground:UIColor = UIColor(hex:0xFFFFFF)
    var buttonTint:UIColor = UIColor(hex:0x005100)
    var buttonColor1:UIColor = UIColor(hex:0x005100)
    var buttonTextColor:UIColor = UIColor(hex:0xffffff)
    var borderColor:CGColor = UIColor(hex:0x005100).CGColor
    var buttonFont:UIFont = UIFont(name: "Helvetica", size: 20)!
    
    override func viewDidLoad() {
        self.fullWidth = self.view.frame.size.width
    }
    
    
    
    
    
    
}
