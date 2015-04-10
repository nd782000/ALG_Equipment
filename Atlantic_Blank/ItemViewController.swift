//
//  ItemViewController.swift
//  Atlantic_Blank
//
//  Created by Nicholas Digiando on 4/6/15.
//  Copyright (c) 2015 Nicholas Digiando. All rights reserved.
//

import Foundation

import UIKit
import Alamofire

protocol ItemDelegate{
    func itemChange(itemID:String,itemName:String)
}

class ItemViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate,  UIScrollViewDelegate, ItemDelegate{
    
    //class WorkOrderViewController: UIViewController{
    
    
    var layoutVars:LayoutVars = LayoutVars()
    var editMode:Bool = false
    
    var scrollView: UIScrollView!
    var tapBtn:UIButton!
    
    var containerView:UIView!
    
    var itemID:String!
    var itemName:String!
    
    var typeLbl:Label!
    var typeValueLbl:Label!
    var typeEditBtn: UIButton!//edit mode
    
    var descriptionLbl:Label!
    var descriptionValueLbl:Label!
    var descriptionTxtField: PaddedTextField!//edit mode
    
    var statusLbl:Label!
    //var statusValueLbl:Label!
    var statusTxtField: PaddedTextField!
    var statusPicker :Picker!//edit mode
    
    let statusArray = ["Not Started", "Started", "Complete", "Not Needed"]
    var laborMode:Bool!
    
    var usageButton:Button!
    
    
    //var metricsDictionary:[CGFloat]

    
    
    init(laborMode:Bool,editMode:Bool){
        super.init(nibName:nil,bundle:nil)
        self.laborMode = laborMode
        self.editMode = editMode
        println("init laborMode = \(laborMode)")
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //view.backgroundColor = layoutVars.backgroundColor
        //title = "Equipment Item"
        
        //custom back button
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.addTarget(self, action: "goBack", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setTitle("Back", forState: UIControlState.Normal)
        backButton.titleLabel!.font =  layoutVars.buttonFont
        backButton.sizeToFit()
        var backButtonItem:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem  = backButtonItem
        
        
        
        
        
        
        self.scrollView = UIScrollView()
        self.scrollView.backgroundColor = layoutVars.backgroundColor
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSizeMake(layoutVars.fullWidth, 1000)
        self.view.addSubview(self.scrollView)
        
        
        //container view for auto layout
        self.containerView = UIView()
        self.containerView.backgroundColor = layoutVars.backgroundColor
        self.containerView.frame = CGRectMake(0, 0, 500, 1000)
        self.scrollView.addSubview(self.containerView)
        
        
        
        //Looks for single or multiple taps.
        //var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        //self.tapBtn.addGestureRecognizer(tap)
       // self.metricsDictionary = ["fullWidth": self.view.frame.size.width - 20,"inputHeight":layoutVars.inputHeight]

        
        
        if(editMode == true){
            if(self.laborMode == true){
                layoutLaborEditViews()
            }else{
                layoutMaterialEditViews()
            }
        }else{
        
            if(self.laborMode == true){
                layoutLaborViews()
            }else{
                layoutMaterialViews()
            }
        }
        
        
    }
    
    
    
    
    //layout for regular mode
    func layoutLaborViews(){
        
        title = "Labor Item"
        
        var editButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        editButton.addTarget(self, action: "enterEditMode", forControlEvents: UIControlEvents.TouchUpInside)
        editButton.setTitle("Edit", forState: UIControlState.Normal)
        editButton.titleLabel!.font =  layoutVars.buttonFont
        editButton.sizeToFit()
        var editButtonItem:UIBarButtonItem = UIBarButtonItem(customView: editButton)
        navigationItem.rightBarButtonItem  = editButtonItem
        
        //name
        
        self.typeLbl = Label(text: "Item Type")
        self.containerView.addSubview(self.typeLbl)
        
        
        self.typeValueLbl = Label(text: "Type Value")
        self.containerView.addSubview(self.typeValueLbl)
        
        //description
        
        self.descriptionLbl = Label()
        self.descriptionLbl.text = "Item Description"
        self.containerView.addSubview(self.descriptionLbl)
        
        
        self.descriptionValueLbl = Label(text: "Item Description")
        self.containerView.addSubview(self.descriptionValueLbl)
        
        //status
        
        self.statusLbl = Label(text: "Item Status")
        self.containerView.addSubview(self.statusLbl)
        
        
        
        
        self.statusPicker = Picker()
        self.statusPicker.delegate = self
        let statusArray = ["New", "Dispatched", "In Progress", "Complete", "Cancelled"]
        
        
       
        
        
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        var items = [AnyObject]()
        let nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "nextPressed")
        items.append(nextButton)
        toolbar.barStyle = UIBarStyle.Black
        toolbar.setItems(items, animated: true)
        
        self.statusTxtField = PaddedTextField()
        self.statusTxtField.returnKeyType = UIReturnKeyType.Next
        self.statusTxtField.delegate = self
        self.statusTxtField.tag = 8
        self.statusTxtField.inputView = self.statusPicker
        self.statusTxtField.inputAccessoryView = toolbar
        self.statusTxtField.attributedPlaceholder = NSAttributedString(string:"Status",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.containerView.addSubview(self.statusTxtField)
        
       
        
        self.usageButton = Button(titleText: "Enter Usage")
        self.usageButton.addTarget(self, action: "showUsageList", forControlEvents: UIControlEvents.TouchUpInside)
        self.containerView.addSubview(self.usageButton)
        
        /////////  Auto Layout   //////////////////////////////////////
        
        //auto layout group
        let viewsDictionary = ["view1":self.typeLbl,"view2":self.typeValueLbl,"view3":self.descriptionLbl,"view4":self.descriptionValueLbl,"view5":self.statusLbl,"view6":self.statusTxtField,"view7":self.usageButton]
        let metricsDictionary = ["fullWidth": self.view.frame.size.width - 20,"inputHeight":layoutVars.inputHeight]
        //size constraint
        let typeLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view1(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
        self.typeLbl.addConstraints(typeLabelConstraint_H as [AnyObject])
        let typeValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view2(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
        self.typeValueLbl.addConstraints(typeValueConstraint_H as [AnyObject])
        let descriptionLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view3(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
        self.descriptionLbl.addConstraints(descriptionLabelConstraint_H as [AnyObject])
        let descriptionValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view4(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
        self.descriptionValueLbl.addConstraints(descriptionValueConstraint_H as [AnyObject])
        let statusLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view5(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
        self.statusLbl.addConstraints(statusLabelConstraint_H as [AnyObject])
        let statusPickerConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view6(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
        self.statusTxtField.addConstraints(statusPickerConstraint_H as [AnyObject])
        let usageButtonConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view7(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
        self.usageButton.addConstraints(usageButtonConstraint_H as [AnyObject])
        //auto layout position constraints
        let viewsConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view1]", options: nil, metrics: nil, views: viewsDictionary)
        let viewsConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[view1(20)]-[view2(inputHeight)]-[view3(20)]-[view4(inputHeight)]-[view5(20)]-[view6(inputHeight)]-[view7(inputHeight)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
        self.containerView.addConstraints(viewsConstraint_H as [AnyObject])
        self.containerView.addConstraints(viewsConstraint_V as [AnyObject])
    }
    
    
    func layoutMaterialViews(){
        
        title = "Material Item"
        
        var editButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        editButton.addTarget(self, action: "enterEditMode", forControlEvents: UIControlEvents.TouchUpInside)
        editButton.setTitle("Edit", forState: UIControlState.Normal)
        editButton.titleLabel!.font =  layoutVars.buttonFont
        editButton.sizeToFit()
        var editButtonItem:UIBarButtonItem = UIBarButtonItem(customView: editButton)
        navigationItem.rightBarButtonItem  = editButtonItem
        
        //name
        
        self.typeLbl = Label(text: "Item Type")
        self.containerView.addSubview(self.typeLbl)
        
        
        self.typeValueLbl = Label(text: "Type Value")
        self.containerView.addSubview(self.typeValueLbl)
        
        //description
        
        self.descriptionLbl = Label(text: "Item Description")
        self.containerView.addSubview(self.descriptionLbl)
        
        
        self.descriptionValueLbl = Label(text: "Description Value")
        self.containerView.addSubview(self.descriptionValueLbl)
        
        //status
        
        self.statusLbl = Label(text: "Item Status")
        self.containerView.addSubview(self.statusLbl)
       
        
        self.statusPicker = Picker()
        self.statusPicker.delegate = self
        let statusArray = ["New", "Dispatched", "In Progress", "Complete", "Cancelled"]
        
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        var items = [AnyObject]()
        let nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "nextPressed")
        items.append(nextButton)
        toolbar.barStyle = UIBarStyle.Black
        toolbar.setItems(items, animated: true)
        
        self.statusTxtField = PaddedTextField()
        self.statusTxtField.returnKeyType = UIReturnKeyType.Next
        self.statusTxtField.delegate = self
        self.statusTxtField.tag = 8
        self.statusTxtField.inputView = self.statusPicker
        self.statusTxtField.inputAccessoryView = toolbar
        self.statusTxtField.attributedPlaceholder = NSAttributedString(string:"Status",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.containerView.addSubview(self.statusTxtField)
        
        
        
        
        /////////  Auto Layout   //////////////////////////////////////
        
        //auto layout group
        let viewsDictionary = ["view1":self.typeLbl,"view2":self.typeValueLbl,"view3":self.descriptionLbl,"view4":self.descriptionValueLbl,"view5":self.statusLbl,"view6":self.statusTxtField]
        let metricsDictionary = ["fullWidth": self.view.frame.size.width - 20,"inputHeight":layoutVars.inputHeight]
        //size constraint
        let typeLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view1(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
        self.typeLbl.addConstraints(typeLabelConstraint_H as [AnyObject])
        let typeValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view2(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
        self.typeValueLbl.addConstraints(typeValueConstraint_H as [AnyObject])
        let descriptionLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view3(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
        self.descriptionLbl.addConstraints(descriptionLabelConstraint_H as [AnyObject])
        let descriptionValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view4(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
        self.descriptionValueLbl.addConstraints(descriptionValueConstraint_H as [AnyObject])
        let statusLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view5(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
        self.statusLbl.addConstraints(statusLabelConstraint_H as [AnyObject])
        let statusPickerConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view6(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
        self.statusTxtField.addConstraints(statusPickerConstraint_H as [AnyObject])
        //auto layout position constraints
        let viewsConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view1]", options: nil, metrics: nil, views: viewsDictionary)
        let viewsConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[view1(20)]-[view2(inputHeight)]-[view3(20)]-[view4(inputHeight)]-[view5(20)]-[view6(inputHeight)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
        self.containerView.addConstraints(viewsConstraint_H as [AnyObject])
        self.containerView.addConstraints(viewsConstraint_V as [AnyObject])
        
    }
    
    
    
    func enterEditMode(){
        editMode = true
        removeViews()
        
        if(self.laborMode == true){
            layoutLaborEditViews()
        }else{
            layoutMaterialEditViews()
        }
        
    }
    
    func exitEditMode(){
        editMode = false
        removeViews()
        if(self.laborMode == true){
            layoutLaborViews()
        }else{
            layoutMaterialViews()
        }
        
        
    }
    
    
    
    //layout for edit mode
    func layoutLaborEditViews(){
        
        
        title = "Edit Labor"
        
        var doneEditingButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        doneEditingButton.addTarget(self, action: "exitEditMode", forControlEvents: UIControlEvents.TouchUpInside)
        doneEditingButton.setTitle("Done", forState: UIControlState.Normal)
        doneEditingButton.titleLabel!.font =  layoutVars.buttonFont
        doneEditingButton.sizeToFit()
        var doneEditingButtonItem:UIBarButtonItem = UIBarButtonItem(customView: doneEditingButton)
        navigationItem.rightBarButtonItem  = doneEditingButtonItem
        
        self.tapBtn = UIButton()
        self.tapBtn.frame = CGRectMake(0, 0, 500, 1000)
        self.tapBtn.backgroundColor = UIColor.clearColor()
        self.tapBtn.addTarget(self, action: "DismissKeyboard", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.containerView.addSubview(self.tapBtn)
        
        
        self.typeLbl = Label(text: "Item Type")
        self.containerView.addSubview(self.typeLbl)
        
        
        self.typeValueLbl = Label(text: "Type Value")
        self.containerView.addSubview(self.typeValueLbl)
        
        
        
        self.typeEditBtn   = UIButton()
        self.typeEditBtn.backgroundColor = layoutVars.buttonColor1
        self.typeEditBtn.addTarget(self, action: "editType", forControlEvents: UIControlEvents.TouchUpInside)
        self.typeEditBtn.setTitle("Edit", forState: UIControlState.Normal)
        self.typeEditBtn.titleLabel!.font =  layoutVars.buttonFont
        //self.typeEditBtn.frame = CGRectMake(10, 759, 200, 30)
        //typeEditBtn.sizeToFit()
        self.typeEditBtn.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        self.containerView.addSubview(self.typeEditBtn)
        
        
        
        self.descriptionLbl = Label(text: "Item Description")
        self.containerView.addSubview(self.descriptionLbl)
        
        self.descriptionTxtField = PaddedTextField()
        self.containerView.addSubview(self.descriptionTxtField)
        
        
        
        
        self.statusLbl = Label(text: "Work Order Status")
        self.containerView.addSubview(self.statusLbl)
        
        
        self.statusPicker = Picker()
        self.statusPicker.delegate = self
        let statusArray = ["New", "Dispatched", "In Progress", "Complete", "Cancelled"]
        
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        var items = [AnyObject]()
        let nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "nextPressed")
        items.append(nextButton)
        toolbar.barStyle = UIBarStyle.Black
        toolbar.setItems(items, animated: true)
        
        self.statusTxtField = PaddedTextField()
        self.statusTxtField.returnKeyType = UIReturnKeyType.Next
        self.statusTxtField.delegate = self
        self.statusTxtField.tag = 8
        self.statusTxtField.inputView = self.statusPicker
        self.statusTxtField.inputAccessoryView = toolbar
        self.statusTxtField.attributedPlaceholder = NSAttributedString(string:"Status",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.containerView.addSubview(self.statusTxtField)
        
        
        
        
        /////////  Auto Layout   //////////////////////////////////////
        
        //auto layout group
        let editViewsDictionary = ["view1":self.typeLbl,"view2":self.typeValueLbl,"view3":self.typeEditBtn,"view4":self.descriptionLbl,"view5":self.descriptionTxtField,"view6":self.statusLbl,"view7":self.statusTxtField]
        let metricsDictionary = ["fullWidth": self.view.frame.size.width - 20,"inputHeight":layoutVars.inputHeight]
        //size constraint
        let typeLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view1(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.typeLbl.addConstraints(typeLabelConstraint_H as [AnyObject])
        let typeValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view2(200)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.typeValueLbl.addConstraints(typeValueConstraint_H as [AnyObject])
        let typeEditBtnConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view3(60)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.typeEditBtn.addConstraints(typeEditBtnConstraint_H as [AnyObject])
        let descriptionLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view4(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.descriptionLbl.addConstraints(descriptionLabelConstraint_H as [AnyObject])
        let descriptionValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view5(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.descriptionTxtField.addConstraints(descriptionValueConstraint_H as [AnyObject])
        let statusLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view6(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.statusLbl.addConstraints(statusLabelConstraint_H as [AnyObject])
        let statusPickerConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view7(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.statusTxtField.addConstraints(statusPickerConstraint_H as [AnyObject])
        //auto layout position constraints
        let viewsConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view1]", options: nil, metrics: nil, views: editViewsDictionary)
        let viewsConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[view1(20)]-[view2(inputHeight)]-[view4(20)]-[view5(inputHeight)]-[view6(20)]-[view7(inputHeight)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.containerView.addConstraints(viewsConstraint_H as [AnyObject])
        self.containerView.addConstraints(viewsConstraint_V as [AnyObject])
        let typeEditConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-220-[view3]", options: nil, metrics: nil, views: editViewsDictionary)
        let typeEditConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[view1(20)]-[view3(inputHeight)]", options: nil, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.containerView.addConstraints(typeEditConstraint_H as [AnyObject])
        self.containerView.addConstraints(typeEditConstraint_V as [AnyObject])
    }
    
    
    
    //layout for edit mode
    func layoutMaterialEditViews(){
        
        title = "Edit Material"
        
        var doneEditingButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        doneEditingButton.addTarget(self, action: "exitEditMode", forControlEvents: UIControlEvents.TouchUpInside)
        doneEditingButton.setTitle("Done", forState: UIControlState.Normal)
        doneEditingButton.titleLabel!.font =  layoutVars.buttonFont
        doneEditingButton.sizeToFit()
        var doneEditingButtonItem:UIBarButtonItem = UIBarButtonItem(customView: doneEditingButton)
        navigationItem.rightBarButtonItem  = doneEditingButtonItem
        
        self.tapBtn = UIButton()
        self.tapBtn.frame = CGRectMake(0, 0, 500, 1000)
        self.tapBtn.backgroundColor = UIColor.clearColor()
        self.tapBtn.addTarget(self, action: "DismissKeyboard", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.containerView.addSubview(self.tapBtn)
        
        
        self.typeLbl = Label(text: "Item Type")
        self.containerView.addSubview(self.typeLbl)
        
        
        self.typeValueLbl = Label(text: "Type Value")
        self.containerView.addSubview(self.typeValueLbl)
        
       
        self.typeEditBtn   = UIButton()
        self.typeEditBtn.backgroundColor = layoutVars.buttonColor1
        self.typeEditBtn.addTarget(self, action: "editType", forControlEvents: UIControlEvents.TouchUpInside)
        self.typeEditBtn.setTitle("Edit", forState: UIControlState.Normal)
        self.typeEditBtn.titleLabel!.font =  layoutVars.buttonFont
        self.typeEditBtn.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        self.containerView.addSubview(self.typeEditBtn)
        
        self.descriptionLbl = Label(text: "Item Description")
        self.containerView.addSubview(self.descriptionLbl)
        
        self.descriptionTxtField = PaddedTextField()
        self.containerView.addSubview(self.descriptionTxtField)
        
        self.statusLbl = Label(text: "Work Order Status")
        self.containerView.addSubview(self.statusLbl)
        
        self.statusPicker = Picker()
        self.statusPicker.delegate = self
        let statusArray = ["New", "Dispatched", "In Progress", "Complete", "Cancelled"]
        
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        var items = [AnyObject]()
        let nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "nextPressed")
        items.append(nextButton)
        toolbar.barStyle = UIBarStyle.Black
        toolbar.setItems(items, animated: true)
        
        self.statusTxtField = PaddedTextField()
        self.statusTxtField.returnKeyType = UIReturnKeyType.Next
        self.statusTxtField.delegate = self
        self.statusTxtField.tag = 8
        self.statusTxtField.inputView = self.statusPicker
        self.statusTxtField.inputAccessoryView = toolbar
        self.statusTxtField.attributedPlaceholder = NSAttributedString(string:"Status",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.containerView.addSubview(self.statusTxtField)
        
        
        
        
        /////////  Auto Layout   //////////////////////////////////////
        
        //auto layout group
        let editViewsDictionary = ["view1":self.typeLbl,"view2":self.typeValueLbl,"view3":self.typeEditBtn,"view4":self.descriptionLbl,"view5":self.descriptionTxtField,"view6":self.statusLbl,"view7":self.statusTxtField]
        
        let metricsDictionary = ["fullWidth": self.view.frame.size.width - 20,"inputHeight":layoutVars.inputHeight]
        
        //size constraint
        let typeLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view1(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.typeLbl.addConstraints(typeLabelConstraint_H as [AnyObject])
        let typeValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view2(200)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.typeValueLbl.addConstraints(typeValueConstraint_H as [AnyObject])
        let typeEditBtnConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view3(60)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.typeEditBtn.addConstraints(typeEditBtnConstraint_H as [AnyObject])
        let descriptionLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view4(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.descriptionLbl.addConstraints(descriptionLabelConstraint_H as [AnyObject])
        let descriptionValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view5(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.descriptionTxtField.addConstraints(descriptionValueConstraint_H as [AnyObject])
        let statusLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view6(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.statusLbl.addConstraints(statusLabelConstraint_H as [AnyObject])
        let statusPickerConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view7(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.statusTxtField.addConstraints(statusPickerConstraint_H as [AnyObject])
        //auto layout position constraints
        let viewsConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view1]", options: nil, metrics: nil, views: editViewsDictionary)
        let viewsConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[view1(20)]-[view2(inputHeight)]-[view4(20)]-[view5(inputHeight)]-[view6(20)]-[view7(inputHeight)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.containerView.addConstraints(viewsConstraint_H as [AnyObject])
        self.containerView.addConstraints(viewsConstraint_V as [AnyObject])
        let typeEditConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-220-[view3]", options: nil, metrics: nil, views: editViewsDictionary)
        let typeEditConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[view1(20)]-[view3(inputHeight)]", options: nil, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.containerView.addConstraints(typeEditConstraint_H as [AnyObject])
        self.containerView.addConstraints(typeEditConstraint_V as [AnyObject])
    }
    
    
    
    func showUsageList(){
        println("show usage list")
        let usageListViewController = UsageListViewController()
        navigationController?.pushViewController(usageListViewController, animated: true )
    }
    
    
    
    func editType(){
        println("editType")
        let itemListViewController = ItemListViewController()
        itemListViewController.delegate = self
        navigationController?.pushViewController(itemListViewController, animated: true )
    }
    
    //item delegate function
    func itemChange(itemID:String,itemName:String){
        
        self.itemName = itemName
        self.itemID = itemID
         self.typeValueLbl.text = itemName
        
    }
    
    
    
    func removeViews(){
        
        for view in containerView.subviews{
            view.removeFromSuperview()
        }
        
    }
    
    
    
    
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scrollView.frame = view.bounds
        // self.containerView.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height)
    }
    
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        return self.statusArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.statusArray[row]
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // typeTxtField.text = "\(self.type[row])"
        self.statusTxtField.text = "\(self.statusArray[row])"
        
    }
    
    
    
    func nextPressed() {
        println("NEXT")
        self.statusTxtField.resignFirstResponder()
        //self.dateTxtField.becomeFirstResponder()
    }
    
    
    
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    
    func goBack(){
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}