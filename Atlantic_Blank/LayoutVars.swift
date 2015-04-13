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
    var fullHeight:CGFloat = 0
    
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
        self.fullHeight = self.view.frame.size.height
    }
}

class PaddedTextField: UITextField {
    
    override init(frame:CGRect)
    {
        super.init(frame:frame)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hex:0x005100, op: 0.2).CGColor
        self.layer.cornerRadius = 4.0
        self.backgroundColor = UIColor(hex:0xFFFFFF, op: 1)
        var inputFont:UIFont = UIFont(name: "Helvetica Neue", size: 17)!
        self.font = inputFont
        self.returnKeyType = UIReturnKeyType.Next
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.frame.size.height = 40
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
    
    func reset() {
        self.layer.borderColor = UIColor(hex:0x005100, op: 0.2).CGColor
        self.backgroundColor = UIColor(hex:0xFFFFFF, op: 1)
    }
    
    convenience init(placeholder:String!) {
        self.init()
        self.attributedPlaceholder = NSAttributedString(string:placeholder,attributes:[NSForegroundColorAttributeName: UIColor(hex:0x333333, op: 0.75)])
    }
}




class TableView: UITableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        println("TableView")
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hex:0x005100, op: 1.0).CGColor
        self.layer.cornerRadius = 4.0
        self.backgroundColor = UIColor(hex:0xFFFFFF, op: 0.8)
        self.separatorColor = UIColor(hex:0x005100, op: 0.6)
        // var inputFont:UIFont = UIFont(name: "Avenir Next", size: 16)!
        
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}




class SegmentedControl:UISegmentedControl{

    
    override init(items: [AnyObject]) {
        super.init(items: items)
        
        var layoutVars:LayoutVars = LayoutVars()
        self.selectedSegmentIndex = 0
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hex:0x005100, op: 0.2).CGColor
        self.backgroundColor = UIColor(hex:0xFFFFFF, op: 0.8)
        var attr = NSDictionary(object: UIFont(name: "Avenir Next", size: 16.0)!, forKey: NSFontAttributeName)
        self.setTitleTextAttributes(attr as [NSObject : AnyObject], forState: .Normal)
        self.layer.cornerRadius = 4.0  // Don't let background bleed
        self.tintColor = layoutVars.buttonTint
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
  

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    


}

class Label :UILabel{
    var valueMode:Bool!
    var insets:UIEdgeInsets!
    var textVal:String!

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    convenience init(text: String?, valueMode:Bool = false){
        self.init()
        self.valueMode = true
        self.text = text
        var layoutVars:LayoutVars = LayoutVars()
        
        if(valueMode == true){
            self.textColor = UIColor.blackColor()
            self.font = UIFont(name: "Avenir Next-italic", size: 16)
            insets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
        }else{
            self.textColor = layoutVars.buttonColor1
            self.font = UIFont(name: "Avenir Next", size: 16)
            insets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
        // var inputFont:UIFont = UIFont(name: "Avenir Next", size: 16)!
        self.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        
    }
    
    
    override func drawTextInRect(rect: CGRect) {
        
                    super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
}

class Picker:UIPickerView, UIPickerViewDelegate{
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        self.backgroundColor = UIColor.whiteColor()
        var layer = self.layer
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8
        self.delegate = self
    }
    
}

class DatePicker:UIDatePicker{
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 4.0
    }
    
}

class Button:UIButton{
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hex:0x005100, op: 1.0)
        self.titleLabel!.font = UIFont(name: "Helvetica Neue", size: 18)!
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.layer.cornerRadius = 4.0
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        
    }
    
    convenience init(titleText:String!) {
        self.init()
        self.setTitle(titleText, forState: UIControlState.Normal)
    }
}

