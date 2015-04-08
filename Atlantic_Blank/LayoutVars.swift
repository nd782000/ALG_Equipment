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
    
    convenience init(hex: Int, op: CGFloat) {
        
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        
        self.init(red: components.R, green: components.G, blue: components.B, alpha: op)
        
    }
    
}


class LayoutVars: UIViewController {
    
    //var backgroundColor:UIColor = uicolorFromHex(0xffccff)
    //var buttonColor1:UIColor = uicolorFromHex(0x005100)
    
    var fullWidth:CGFloat = 0
    
    var navAndStatusBarHeight = 64
    var backgroundColor:UIColor = UIColor(hex:0xFFF8E6, op: 1)
    var backgroundLight:UIColor = UIColor(hex:0xFFFaF8, op: 1)
    var buttonBackground:UIColor = UIColor(hex:0xFFFFFF, op: 1)
    var buttonTint:UIColor = UIColor(hex:0x005100, op: 1)
    var buttonColor1:UIColor = UIColor(hex:0x005100, op: 1)
    var buttonTextColor:UIColor = UIColor(hex:0xffffff, op: 1)
    var borderColor:CGColor = UIColor(hex:0x005100, op: 1).CGColor
    var buttonFont:UIFont = UIFont(name: "Helvetica Neue", size: 18)!
    var inputHeight = 50
    
    override func viewDidLoad() {
        self.fullWidth = self.view.frame.size.width
    }
}

class PaddedTextField: UITextField {
    override init()
    {
        super.init()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hex:0x005100, op: 0.2).CGColor
        self.layer.cornerRadius = 5.0
        self.backgroundColor = UIColor(hex:0xFFFFFF, op: 0.8)
        var inputFont:UIFont = UIFont(name: "Avenir Next", size: 16)!
        self.font = inputFont
        self.returnKeyType = UIReturnKeyType.Next
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.frame.size.height = 40
    }
    
    override init(frame:CGRect)
    {
        super.init(frame:frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var leftMargin : CGFloat = 10.0
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += leftMargin
        return newBounds
    }
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += leftMargin
        return newBounds
    }
}

good bye

