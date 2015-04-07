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

class UsageListViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate,  UIScrollViewDelegate{
    
    //class WorkOrderViewController: UIViewController{
    
    
    var layoutVars:LayoutVars = LayoutVars()
    var editMode:Bool = false
    
    var scrollView: UIScrollView!
    var tapBtn:UIButton!
    
    var containerView:UIView!
    
    var typeLbl:UILabel!
    var typeValueLbl:IndentLabel!
    var typeEditBtn: UIButton!//edit mode
    
    var descriptionLbl:UILabel!
    var descriptionValueLbl:IndentLabel!
    var descriptionTxtField: UITextField!//edit mode
    
    var statusLbl:UILabel!
    //var statusValueLbl:IndentLabel!
    var statusPicker :UIPickerView!//edit mode
    
    let statusArray = ["Not Started", "Started", "Complete", "Not Needed"]
    
    
    
    
    
    override init(){
        super.init(nibName:nil,bundle:nil)
        //  println("init equipId = \(equipId) equipName = \(equipName)")
        title = "Item"
        
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
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
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
        
        
        
        
        
        layoutViews()
        
        
    }
    
    
    
    
    //layout for regular mode
    func layoutViews(){
        
        
        var editButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        editButton.addTarget(self, action: "enterEditMode", forControlEvents: UIControlEvents.TouchUpInside)
        editButton.setTitle("Edit", forState: UIControlState.Normal)
        editButton.titleLabel!.font =  layoutVars.buttonFont
        editButton.sizeToFit()
        var editButtonItem:UIBarButtonItem = UIBarButtonItem(customView: editButton)
        navigationItem.rightBarButtonItem  = editButtonItem
        
        //name
        
        self.typeLbl = UILabel()
        self.typeLbl.text = "Item Type"
        self.typeLbl.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        self.containerView.addSubview(self.typeLbl)
        
        
        self.typeValueLbl = IndentLabel()
        self.typeValueLbl.text = "Type Value"
        self.typeValueLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        self.typeValueLbl.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        self.containerView.addSubview(self.typeValueLbl)
        
        //description
        
        self.descriptionLbl = UILabel()
        self.descriptionLbl.text = "Item Description"
        self.descriptionLbl.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        self.containerView.addSubview(self.descriptionLbl)
        
        
        self.descriptionValueLbl = IndentLabel()
        self.descriptionValueLbl.text = "Description Value"
        self.descriptionValueLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        self.descriptionValueLbl.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        self.containerView.addSubview(self.descriptionValueLbl)
        
        //status
        
        self.statusLbl = UILabel()
        self.statusLbl.text = "Item Status"
        self.statusLbl.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        self.containerView.addSubview(self.statusLbl)
        
        self.statusPicker = UIPickerView()
        self.statusPicker.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        //self.statusPicker.frame = CGRectMake(50, 80, 200, 30)
        self.statusPicker.backgroundColor = UIColor.whiteColor()
        self.statusPicker.layer.cornerRadius = 4.0
        
        self.statusPicker.delegate = self
        
        self.containerView.addSubview(self.statusPicker)
        
        
        
        
        
        
        
        
        
        
        
        /////////  Auto Layout   //////////////////////////////////////
        
        //auto layout group
        let viewsDictionary = ["view1":self.typeLbl,"view2":self.typeValueLbl,"view3":self.descriptionLbl,"view4":self.descriptionValueLbl,"view5":self.statusLbl,"view6":self.statusPicker]
        
        let metricsDictionary = ["fullWidth": self.view.frame.size.width - 20]
        //let fullWidth = metricsDictionary["fullWidth"]
        //println("fullWidth = \(fullWidth)")
        // piePrice["Apple"]
        
        
        //size constraint
        let typeLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view1(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        let typeLabelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view1(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewsDictionary)
        self.typeLbl.addConstraints(typeLabelConstraint_H)
        self.typeLbl.addConstraints(typeLabelConstraint_V)
        
        let typeValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view2(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        let typeValueConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view2(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewsDictionary)
        self.typeValueLbl.addConstraints(typeValueConstraint_H)
        self.typeValueLbl.addConstraints(typeValueConstraint_V)
        
        
        
        let descriptionLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view3(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        let descriptionLabelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view3(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewsDictionary)
        self.descriptionLbl.addConstraints(descriptionLabelConstraint_H)
        self.descriptionLbl.addConstraints(descriptionLabelConstraint_V)
        
        let descriptionValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view4(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        let descriptionValueConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view4(100)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewsDictionary)
        self.descriptionValueLbl.addConstraints(descriptionValueConstraint_H)
        self.descriptionValueLbl.addConstraints(descriptionValueConstraint_V)
        
        
        
        
        let statusLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view5(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        let statusLabelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view5(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewsDictionary)
        self.statusLbl.addConstraints(statusLabelConstraint_H)
        self.statusLbl.addConstraints(statusLabelConstraint_V)
        
        let statusPickerConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view6(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        let statusPickerConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view6(200)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewsDictionary)
        self.statusPicker.addConstraints(statusPickerConstraint_H)
        self.statusPicker.addConstraints(statusPickerConstraint_V)
        
        
        
        
        //auto layout position constraints
        let viewsConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view1]", options: nil, metrics: nil, views: viewsDictionary)
        
        let viewsConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[view1]-[view2]-[view3]-[view4]-[view5]-[view6]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewsDictionary)
        
        
        self.containerView.addConstraints(viewsConstraint_H)
        self.containerView.addConstraints(viewsConstraint_V)
        
    }
    
    
    func enterEditMode(){
        editMode = true
        removeViews()
        layoutEditViews()
        
    }
    
    func exitEditMode(){
        editMode = false
        removeViews()
        layoutViews()
        
    }
    
    
    
    //layout for edit mode
    func layoutEditViews(){
        
        var doneEditingButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
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
        
        
        self.typeLbl = UILabel()
        self.typeLbl.text = "Item Type"
        //self.nameLbl.frame = CGRectMake(10, 5, 200, 30)
        self.typeLbl.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        self.typeLbl.layer.cornerRadius = 4.0
        self.containerView.addSubview(self.typeLbl)
        
        
        self.typeValueLbl = IndentLabel()
        //self.nameTxtField.frame = CGRectMake(50, 30, 200, 30)
        self.typeValueLbl.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        self.typeValueLbl.backgroundColor = UIColor.whiteColor()
        self.typeValueLbl.layer.cornerRadius = 4.0
        self.typeValueLbl.text = "Type Value"
        self.containerView.addSubview(self.typeValueLbl)
        
        
        /*
        var submitEquipmentButton   = UIButton.buttonWithType(UIButtonType.System) as UIButton
        submitEquipmentButton.frame = CGRectMake(100, 600, 100, 50)
        submitEquipmentButton.backgroundColor = layoutVars.buttonColor1
        submitEquipmentButton.setTitle("Submit", forState: UIControlState.Normal)
        submitEquipmentButton.titleLabel!.font =  layoutVars.buttonFont
        submitEquipmentButton.setTitleColor(layoutVars.buttonTextColor, forState: UIControlState.Normal)
        submitEquipmentButton.layer.cornerRadius = 4.0
        
        submitEquipmentButton.addTarget(self, action: "saveData", forControlEvents: UIControlEvents.TouchUpInside)
        self.scrollView.addSubview(submitEquipmentButton)
        
        */
        
        
        
        self.typeEditBtn   = UIButton()
        self.typeEditBtn.backgroundColor = layoutVars.buttonColor1
        self.typeEditBtn.addTarget(self, action: "editType", forControlEvents: UIControlEvents.TouchUpInside)
        self.typeEditBtn.setTitle("Edit", forState: UIControlState.Normal)
        self.typeEditBtn.titleLabel!.font =  layoutVars.buttonFont
        //self.typeEditBtn.frame = CGRectMake(10, 759, 200, 30)
        //typeEditBtn.sizeToFit()
        self.typeEditBtn.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        self.containerView.addSubview(self.typeEditBtn)
        
        
        
        self.descriptionLbl = UILabel()
        self.descriptionLbl.text = "Item Description"
        self.descriptionLbl.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        
        //self.dateLbl.frame = CGRectMake(10, 259, 200, 30)
        self.descriptionLbl.layer.cornerRadius = 4.0
        self.containerView.addSubview(self.descriptionLbl)
        
        self.descriptionTxtField = UITextField()
        self.descriptionTxtField.backgroundColor = UIColor.whiteColor()
        self.descriptionTxtField.layer.cornerRadius = 4.0
        self.descriptionTxtField.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        //self.datePicker.frame = CGRectMake(50, 284, 200, 30)
        self.containerView.addSubview(self.descriptionTxtField)
        
        
        
        
        self.statusLbl = UILabel()
        self.statusLbl.text = "Work Order Status"
        self.statusLbl.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        //self.statusLbl.frame = CGRectMake(10, 55, 200, 30)
        self.statusLbl.layer.cornerRadius = 4.0
        self.containerView.addSubview(self.statusLbl)
        
        self.statusPicker = UIPickerView()
        self.statusPicker.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        //self.statusPicker.frame = CGRectMake(50, 80, 200, 30)
        self.statusPicker.backgroundColor = UIColor.whiteColor()
        self.statusPicker.layer.cornerRadius = 4.0
        
        self.statusPicker.delegate = self
        
        self.containerView.addSubview(self.statusPicker)
        
        
        
        
        
        /////////  Auto Layout   //////////////////////////////////////
        
        //auto layout group
        let editViewsDictionary = ["view1":self.typeLbl,"view2":self.typeValueLbl,"view3":self.typeEditBtn,"view4":self.descriptionLbl,"view5":self.descriptionTxtField,"view6":self.statusLbl,"view7":self.statusPicker]
        
        let metricsDictionary = ["fullWidth": self.view.frame.size.width - 20]
        //let fullWidth = metricsDictionary["fullWidth"]
        //println("fullWidth = \(fullWidth)")
        // piePrice["Apple"]
        
        
        //size constraint
        let typeLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view1(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        let typeLabelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view1(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: editViewsDictionary)
        self.typeLbl.addConstraints(typeLabelConstraint_H)
        self.typeLbl.addConstraints(typeLabelConstraint_V)
        
        let typeValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view2(200)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        let typeValueConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view2(40)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: editViewsDictionary)
        self.typeValueLbl.addConstraints(typeValueConstraint_H)
        self.typeValueLbl.addConstraints(typeValueConstraint_V)
        
        let typeEditBtnConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view3(60)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        let typeEditBtnConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view3(40)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: editViewsDictionary)
        self.typeEditBtn.addConstraints(typeEditBtnConstraint_H)
        self.typeEditBtn.addConstraints(typeEditBtnConstraint_V)
        
        
        
        let descriptionLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view4(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        let descriptionLabelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view4(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: editViewsDictionary)
        self.descriptionLbl.addConstraints(descriptionLabelConstraint_H)
        self.descriptionLbl.addConstraints(descriptionLabelConstraint_V)
        
        let descriptionValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view5(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        let descriptionValueConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view5(200)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: editViewsDictionary)
        self.descriptionTxtField.addConstraints(descriptionValueConstraint_H)
        self.descriptionTxtField.addConstraints(descriptionValueConstraint_V)
        
        let statusLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view6(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        let statusLabelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view6(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: editViewsDictionary)
        self.statusLbl.addConstraints(statusLabelConstraint_H)
        self.statusLbl.addConstraints(statusLabelConstraint_V)
        
        let statusPickerConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view7(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        let statusPickerConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view7(200)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: editViewsDictionary)
        self.statusPicker.addConstraints(statusPickerConstraint_H)
        self.statusPicker.addConstraints(statusPickerConstraint_V)
        
        
        //auto layout position constraints
        let viewsConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view1]", options: nil, metrics: nil, views: editViewsDictionary)
        
        //let viewsConstraint_H2:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view8]-|", options: nil, metrics: nil, views: editViewsDictionary)
        //let viewsConstraint_H2:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[view2]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewsDictionary)
        let viewsConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[view1]-[view2]-[view4]-[view5]-[view6]-[view7]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: editViewsDictionary)
        
        self.containerView.addConstraints(viewsConstraint_H)
        // self.containerView.addConstraints(viewsConstraint_H2)
        self.containerView.addConstraints(viewsConstraint_V)
        
        
        
        let typeEditConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-220-[view3]", options: nil, metrics: nil, views: editViewsDictionary)
        let typeEditConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[view1]-[view3]", options: nil, metrics: nil, views: editViewsDictionary)
        
        
        self.containerView.addConstraints(typeEditConstraint_H)
        // self.containerView.addConstraints(viewsConstraint_H2)
        self.containerView.addConstraints(typeEditConstraint_V)
    }
    
    
    func editType(){
        println("editType")
        let itemListViewController = ItemListViewController()
        navigationController?.pushViewController(itemListViewController, animated: true )
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
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.statusArray[row]
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        // typeTxtField.text = "\(self.type[row])"
        
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