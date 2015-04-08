//
//  WorkOrderViewController.swift
//  Atlantic_Blank
//
//  Created by Nicholas Digiando on 4/6/15.
//  Copyright (c) 2015 Nicholas Digiando. All rights reserved.
//

import Foundation

import UIKit
import Alamofire

class WorkOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UITextFieldDelegate,  UIScrollViewDelegate{
    
    //class WorkOrderViewController: UIViewController{
    
    
    var layoutVars:LayoutVars = LayoutVars()
    var editMode:Bool = false
    
    var scrollView: UIScrollView!
    var tapBtn:UIButton!
    
    var containerView:UIView!
    
    var nameLbl:UILabel!
    var nameValueLbl:IndentLabel!
    var nameTxtField: PaddedTextField!//edit mode
    
    var statusLbl:UILabel!
    var statusValueLbl:IndentLabel!
    var statusTxtField: PaddedTextField!
    var statusPicker :UIPickerView!//edit mode
    
    let statusArray = ["New", "Dispatched", "In Progress", "Complete", "Cancelled"]
    
    var dateLbl:UILabel!
    var dateValueLbl:IndentLabel!
    var dateTxtField: PaddedTextField!
    //var datePicker :UIDatePicker!//edit mode
    
    let DatePickerView = UIDatePicker()
    var dateFormatter = NSDateFormatter()
    
    //var metricsDictionary = []
    //let fullWidth = metricsDictionary["fullWidth"]
    //println("fullWidth = \(fullWidth)")
    // piePrice["Apple"]
    
    var activeTextField:PaddedTextField?
    
    
    
    //let statusArray = ["New", "Dispatched", "In Progress", "Complete", "Cancelled"]
    
    
    var itemsLbl:UILabel!
    var itemsTableView: UITableView!
    
    let itemArray = ["Regular Maintenance","Oil Filter","Spark Plug","Air Filter","Fuel Filter","Blades","Belts","Tires"]
    
    override init(){
        super.init(nibName:nil,bundle:nil)
        //  println("init equipId = \(equipId) equipName = \(equipName)")
        title = "WorkOrder"
        
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
        
        
        
        
        //let fullWidth = metricsDictionary["fullWidth"]
        //println("fullWidth = \(fullWidth)")
        // piePrice["Apple"]

        
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
        
        self.nameLbl = UILabel()
        self.nameLbl.text = "Work Order Name"
        self.nameLbl.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        self.containerView.addSubview(self.nameLbl)
        
        
        self.nameValueLbl = IndentLabel()
        self.nameValueLbl.text = "Name Value"
        self.nameValueLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        self.nameValueLbl.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        self.containerView.addSubview(self.nameValueLbl)
        
        //status
        
        self.statusLbl = UILabel()
        self.statusLbl.text = "Work Order Status"
        self.statusLbl.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        self.containerView.addSubview(self.statusLbl)
        
        self.statusValueLbl = IndentLabel()
        self.statusValueLbl.text = "Status Value"
        self.statusValueLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        self.statusValueLbl.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        self.containerView.addSubview(self.statusValueLbl)
        
        //date
        
        self.dateLbl = UILabel()
        self.dateLbl.text = "Work Order Date"
        self.dateLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.containerView.addSubview(self.dateLbl)
        
        self.dateValueLbl = IndentLabel()
        self.dateValueLbl.text = "Date Value"
        self.dateValueLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        self.dateValueLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.containerView.addSubview(self.dateValueLbl)
        
        //items
        
        self.itemsLbl = UILabel()
        self.itemsLbl.text = "Work Order Items"
        self.itemsLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.itemsLbl.layer.cornerRadius = 4.0
        self.containerView.addSubview(self.itemsLbl)
        
        
        self.itemsTableView  =   UITableView()
        self.itemsTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.itemsTableView.layer.cornerRadius = 4.0
        self.itemsTableView.delegate  =  self
        self.itemsTableView.dataSource  =  self
        self.itemsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.containerView.addSubview(self.itemsTableView)
        
        
        
        /////////  Auto Layout   //////////////////////////////////////
        
        //auto layout group
        let viewsDictionary = ["view1":self.nameLbl,"view2":self.nameValueLbl,"view3":self.statusLbl,"view4":self.statusValueLbl,"view5":self.dateLbl,"view6":self.dateValueLbl,"view7":self.itemsLbl,"view8":self.itemsTableView]
        let metricsDictionary = ["fullWidth": self.view.frame.size.width - 20,"inputHeight":layoutVars.inputHeight]
        
        
        //size constraint
        let nameLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view1(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        let nameLabelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view1(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        self.nameLbl.addConstraints(nameLabelConstraint_H)
        self.nameLbl.addConstraints(nameLabelConstraint_V)
        
        let nameValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view2(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        let nameValueConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view2(inputHeight)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        self.nameValueLbl.addConstraints(nameValueConstraint_H)
        self.nameValueLbl.addConstraints(nameValueConstraint_V)
        
        let statusLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view3(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        let statusLabelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view3(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        self.statusLbl.addConstraints(statusLabelConstraint_H)
        self.statusLbl.addConstraints(statusLabelConstraint_V)
        
        let statusValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view4(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        let statusValueConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view4(inputHeight)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        self.statusValueLbl.addConstraints(statusValueConstraint_H)
        self.statusValueLbl.addConstraints(statusValueConstraint_V)
        
        let dateLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view5(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        let dateLabelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view5(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        self.dateLbl.addConstraints(dateLabelConstraint_H)
        self.dateLbl.addConstraints(dateLabelConstraint_V)
        
        let dateValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view6(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        let dateValueConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view6(inputHeight)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        self.dateValueLbl.addConstraints(dateValueConstraint_H)
        self.dateValueLbl.addConstraints(dateValueConstraint_V)
        
        let itemsLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view7(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        let itemsLabelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view7(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        self.itemsLbl.addConstraints(itemsLabelConstraint_H)
        self.itemsLbl.addConstraints(itemsLabelConstraint_V)
        
        let itemsTableConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view8(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        let itemsTableConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view8(300)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        self.itemsTableView.addConstraints(itemsTableConstraint_H)
        self.itemsTableView.addConstraints(itemsTableConstraint_V)
        
        
        
        
        
        //auto layout position constraints
        let viewsConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view1]", options: nil, metrics: nil, views: viewsDictionary)
        let viewsConstraint_H2:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view8]-|", options: nil, metrics: nil, views: viewsDictionary)
        //let viewsConstraint_H2:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[view2]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewsDictionary)
        let viewsConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[view1]-[view2]-[view3]-[view4]-[view5]-[view6]-[view7]-[view8]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewsDictionary)
        
        
        self.containerView.addConstraints(viewsConstraint_H)
        //self.containerView.addConstraints(viewsConstraint_H2)
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
        
        
        
        self.nameLbl = UILabel()
        self.nameLbl.text = "Work Order Name"
        //self.nameLbl.frame = CGRectMake(10, 5, 200, 30)
        self.nameLbl.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        self.nameLbl.layer.cornerRadius = 4.0
        self.containerView.addSubview(self.nameLbl)
        
        
        self.nameTxtField = PaddedTextField()
        //self.nameTxtField.frame = CGRectMake(50, 30, 200, 30)
        self.nameTxtField.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        self.nameTxtField.backgroundColor = UIColor.whiteColor()
        self.nameTxtField.layer.cornerRadius = 4.0
        self.nameTxtField.attributedPlaceholder = NSAttributedString(string:"Name",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.containerView.addSubview(self.nameTxtField)
        
        self.statusLbl = UILabel()
        self.statusLbl.text = "Work Order Status"
        self.statusLbl.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        //self.statusLbl.frame = CGRectMake(10, 55, 200, 30)
        self.statusLbl.layer.cornerRadius = 4.0
        self.containerView.addSubview(self.statusLbl)
        
        
        
        /*
        
        //DatePickerView.datePickerMode = UIDatePickerMode.Date
        StatusPickerView.backgroundColor = layoutVars.backgroundLight
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        var items = [AnyObject]()
        //making done button
        let nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "nextPressed")
        items.append(nextButton)
        toolbar.barStyle = UIBarStyle.Black
        toolbar.setItems(items, animated: true)
        
        DatePickerView.addTarget( self, action: "handleDatePicker", forControlEvents: UIControlEvents.ValueChanged )
        
        //usDateFormat now contains an optional string "MM/dd/yyyy".
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        */
        
        
        
        
        
        
        self.statusPicker = UIPickerView()
        self.statusPicker.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        self.statusPicker.backgroundColor = UIColor.whiteColor()
        self.statusPicker.layer.cornerRadius = 4.0
        self.statusPicker.delegate = self
        let statusArray = ["New", "Dispatched", "In Progress", "Complete", "Cancelled"]
    
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        var items = [AnyObject]()
        let nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "nextPressed")
        items.append(nextButton)
        // Setup the buttons to be put in the system.
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("endEditingNow") )
        items.append(doneButton)
        toolbar.barStyle = UIBarStyle.Black
        toolbar.setItems(items, animated: true)
        
        self.statusTxtField = PaddedTextField()
        self.statusTxtField.returnKeyType = UIReturnKeyType.Next
        self.statusTxtField.backgroundColor = UIColor.whiteColor()
        self.statusTxtField.delegate = self
        self.statusTxtField.tag = 8
        self.statusTxtField.inputView = self.statusPicker
        self.statusTxtField.inputAccessoryView = toolbar
        self.statusTxtField.layer.cornerRadius = 4.0
        self.statusTxtField.attributedPlaceholder = NSAttributedString(string:"Status",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.statusTxtField.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.containerView.addSubview(self.statusTxtField)
        
        
        
        self.dateLbl = UILabel()
        self.dateLbl.text = "Work Order Date"
        self.dateLbl.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        
        //self.dateLbl.frame = CGRectMake(10, 259, 200, 30)
        self.dateLbl.layer.cornerRadius = 4.0
        self.containerView.addSubview(self.dateLbl)
        
        
        DatePickerView.datePickerMode = UIDatePickerMode.Date
        DatePickerView.backgroundColor = layoutVars.backgroundLight
       
        
        DatePickerView.addTarget( self, action: "handleDatePicker", forControlEvents: UIControlEvents.ValueChanged )
        
        //usDateFormat now contains an optional string "MM/dd/yyyy".
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        self.dateTxtField = PaddedTextField()
        self.dateTxtField.returnKeyType = UIReturnKeyType.Next
        self.dateTxtField.backgroundColor = UIColor.whiteColor()
        self.dateTxtField.delegate = self
        self.dateTxtField.tag = 8
        self.dateTxtField.inputView = self.DatePickerView
        self.dateTxtField.inputAccessoryView = toolbar
        self.dateTxtField.layer.cornerRadius = 4.0
        self.dateTxtField.attributedPlaceholder = NSAttributedString(string:"Purchased Date",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.dateTxtField.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.containerView.addSubview(self.dateTxtField)
        

        
        //items table
        
        self.itemsLbl = UILabel()
        self.itemsLbl.text = "Work Order Items"
        self.itemsLbl.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        //self.itemsLbl.frame = CGRectMake(10, 400, 200, 30)
        self.itemsLbl.layer.cornerRadius = 4.0
        self.containerView.addSubview(self.itemsLbl)
        
        self.itemsTableView  =   UITableView()
        self.itemsTableView.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        //itemsTableView.frame = CGRectMake(20, 420, 300, 200 )
        //clientTableView.setTranslatesAutoresizingMaskIntoConstraints(false) //allows for autolayout
        itemsTableView.layer.cornerRadius = 4.0
        
        itemsTableView.delegate  =  self
        itemsTableView.dataSource  =  self
        itemsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.containerView.addSubview(itemsTableView)
        
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        
        
        /////////  Auto Layout   //////////////////////////////////////
        //apply to each view
        //itemsTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        //auto layout group
        let editViewsDictionary = ["view1":self.nameLbl,"view2":self.nameTxtField,"view3":self.statusLbl,"view4":self.statusTxtField,"view5":self.dateLbl,"view6":self.dateTxtField,"view7":self.itemsLbl,"view8":self.itemsTableView]
        
        let metricsDictionary = ["fullWidth": self.view.frame.size.width - 20,"inputHeight":layoutVars.inputHeight]
        
        //size constraint
        let nameLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view1(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        let nameLabelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view1(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        self.nameLbl.addConstraints(nameLabelConstraint_H)
        self.nameLbl.addConstraints(nameLabelConstraint_V)
        
        let nameValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view2(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        let nameValueConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view2(inputHeight)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        self.nameTxtField.addConstraints(nameValueConstraint_H)
        self.nameTxtField.addConstraints(nameValueConstraint_V)
        
        let statusLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view3(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        let statusLabelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view3(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        self.statusLbl.addConstraints(statusLabelConstraint_H)
        self.statusLbl.addConstraints(statusLabelConstraint_V)
        
        let statusValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view4(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        let statusValueConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view4(inputHeight)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        self.statusTxtField.addConstraints(statusValueConstraint_H)
        self.statusTxtField.addConstraints(statusValueConstraint_V)
        
        let dateLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view5(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        let dateLabelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view5(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        self.dateLbl.addConstraints(dateLabelConstraint_H)
        self.dateLbl.addConstraints(dateLabelConstraint_V)
        
        let dateValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view6(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        let dateValueConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view6(inputHeight)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        self.dateTxtField.addConstraints(dateValueConstraint_H)
        self.dateTxtField.addConstraints(dateValueConstraint_V)
        
        let itemsLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view7(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        let itemsLabelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view7(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        self.itemsLbl.addConstraints(itemsLabelConstraint_H)
        self.itemsLbl.addConstraints(itemsLabelConstraint_V)
        
        let itemsTableConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view8(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        let itemsTableConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view8(300)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        self.itemsTableView.addConstraints(itemsTableConstraint_H)
        self.itemsTableView.addConstraints(itemsTableConstraint_V)
        
        
        
        
        
        //auto layout position constraints
        let viewsConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view1]", options: nil, metrics: nil, views: editViewsDictionary)
        let viewsConstraint_H2:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view8]-|", options: nil, metrics: nil, views: editViewsDictionary)
        //let viewsConstraint_H2:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[view2]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewsDictionary)
        let viewsConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[view1]-[view2]-[view3]-[view4]-[view5]-[view6]-[view7]-[view8]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: editViewsDictionary)
        
        
        self.containerView.addConstraints(viewsConstraint_H)
        //self.containerView.addConstraints(viewsConstraint_H2)
        self.containerView.addConstraints(viewsConstraint_V)
        
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
        self.statusTxtField.text = "\(self.statusArray[row])"
        
    }
    
    
    
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if(editMode == true){
            return self.itemArray.count + 1 //for "add new" btn
        }else{
            return self.itemArray.count
        }
        
        
        
        
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:UITableViewCell = itemsTableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        if(editMode == true){
            if(indexPath.row == 0){
                cell.textLabel?.textColor = UIColor.blueColor()
                cell.textLabel?.text = "Add New"
            }else{
                cell.textLabel?.textColor = UIColor.blackColor()
                cell.textLabel?.text = self.itemArray[indexPath.row - 1]
            }
            
        }else{
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.text = self.itemArray[indexPath.row]
        }
        
        return cell;
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(" cell Selected")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.row == 0){
            println("add new")
            let itemViewController = ItemViewController(laborMode: true,editMode:true)
            navigationController?.pushViewController(itemViewController, animated: true )
        }else{
            let itemViewController = ItemViewController(laborMode: true,editMode:false)
            navigationController?.pushViewController(itemViewController, animated: true )
        }
        
    }
    
    
    func nextPressed() {
        println("NEXT")
        self.statusTxtField.resignFirstResponder()
        self.dateTxtField.becomeFirstResponder()
    }

    
    
    
    func handleDatePicker()
    {
        println("DATE: \(dateFormatter.stringFromDate(DatePickerView.date))")
        self.dateTxtField.text =  dateFormatter.stringFromDate(DatePickerView.date)
    }
    
    
    
    func textFieldDidBeginEditing(textField: PaddedTextField) {
        println("PLEASE SCROLL")
        let offset = (textField.frame.origin.y - 150)
        var scrollPoint : CGPoint = CGPointMake(0, offset)
        self.scrollView.setContentOffset(scrollPoint, animated: true)
        self.activeTextField = textField
    }
    
    func textFieldTextDidEndEditing(textField: PaddedTextField) {
        self.scrollView.setContentOffset(CGPointZero, animated: true)
    }
    
    
    func textFieldShouldReturn(textField: PaddedTextField!) -> Bool {
        textField.resignFirstResponder()
        println("NEXT")
        /*
        switch (textField.tag) {
        case makeTxtField.tag:
            modelTxtField.becomeFirstResponder()
            break;
        case modelTxtField.tag:
            serialTxtField.becomeFirstResponder()
            break;
        case serialTxtField.tag:
            dealerTxtField.becomeFirstResponder()
            break;
        case dealerTxtField.tag:
            mileageTxtField.becomeFirstResponder()
            break;
        case engineTxtField.tag:
            fuelTxtField.becomeFirstResponder()
            break;
        case fuelTxtField.tag:
            purchasedTxtField.becomeFirstResponder()
            break;
        case purchasedTxtField.tag:
            crewTxtField.becomeFirstResponder()
            break;
        default:
            break;
        }
*/
        return true
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
    
    
    
    
    
    
    
    // This is called to remove the first responder for the text field.
    func resign() {
        self.resignFirstResponder()
    }
    
    // This triggers the textFieldDidEndEditing method that has the textField within it.
    //  This then triggers the resign() method to remove the keyboard.
    //  We use this in the "done" button action.
    func endEditingNow(){
        self.view.endEditing(true)
    }
    
    
    //MARK: - Delegate Methods
    /*
    // When clicking on the field, use this method.
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        
        // Create a button bar for the number pad
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        
        // Setup the buttons to be put in the system.
        let item = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("endEditingNow") )
        var toolbarButtons = [item]
        
        //Put the buttons into the ToolBar and display the tool bar
        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
        textField.inputAccessoryView = keyboardDoneButtonView
        
        return true
    }
*/
    
    // What to do when a user finishes editting
    func textFieldDidEndEditing(textField: UITextField) {
        
        //nothing fancy here, just trigger the resign() method to close the keyboard.
        resign()
    }
    
    
    // Clicking away from the keyboard will remove the keyboard.
    override func touchesBegan(touches: (NSSet!), withEvent event: (UIEvent!)) {
        self.view.endEditing(true)
    }
    
    // called when 'return' key pressed. return NO to ignore.
    // Requires having the text fields using the view controller as the delegate.
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        // Sends the keyboard away when pressing the "done" button
        resign()
        return true
        
    }
    
    
    
    
    
    
    
    
    
}



class IndentLabel :UILabel{
    
    override func drawTextInRect(rect: CGRect) {
        var insets:UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
}






