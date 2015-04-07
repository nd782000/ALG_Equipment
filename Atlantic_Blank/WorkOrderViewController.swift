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
    var nameTxtField: UITextField!//edit mode
    
    var statusLbl:UILabel!
    var statusValueLbl:IndentLabel!
    var statusPicker :UIPickerView!//edit mode
    
    let statusArray = ["New", "Dispatched", "In Progress", "Complete", "Cancelled"]
    
    var dateLbl:UILabel!
    var dateValueLbl:IndentLabel!
    var datePicker :UIDatePicker!//edit mode
    
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
        
        let metricsDictionary = ["fullWidth": self.view.frame.size.width - 20]
        //let fullWidth = metricsDictionary["fullWidth"]
        //println("fullWidth = \(fullWidth)")
        // piePrice["Apple"]
        
        
        //size constraint
        let nameLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view1(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        let nameLabelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view1(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewsDictionary)
        self.nameLbl.addConstraints(nameLabelConstraint_H)
        self.nameLbl.addConstraints(nameLabelConstraint_V)
        
        let nameValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view2(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        let nameValueConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view2(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewsDictionary)
        self.nameValueLbl.addConstraints(nameValueConstraint_H)
        self.nameValueLbl.addConstraints(nameValueConstraint_V)
        
        let statusLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view3(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        let statusLabelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view3(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewsDictionary)
        self.statusLbl.addConstraints(statusLabelConstraint_H)
        self.statusLbl.addConstraints(statusLabelConstraint_V)
        
        let statusValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view4(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        let statusValueConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view4(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewsDictionary)
        self.statusValueLbl.addConstraints(statusValueConstraint_H)
        self.statusValueLbl.addConstraints(statusValueConstraint_V)
        
        let dateLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view5(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        let dateLabelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view5(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewsDictionary)
        self.dateLbl.addConstraints(dateLabelConstraint_H)
        self.dateLbl.addConstraints(dateLabelConstraint_V)
        
        let dateValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view6(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        let dateValueConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view6(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewsDictionary)
        self.dateValueLbl.addConstraints(dateValueConstraint_H)
        self.dateValueLbl.addConstraints(dateValueConstraint_V)
        
        let itemsLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view7(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        let itemsLabelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view7(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewsDictionary)
        self.itemsLbl.addConstraints(itemsLabelConstraint_H)
        self.itemsLbl.addConstraints(itemsLabelConstraint_V)
        
        let itemsTableConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view8(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        let itemsTableConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view8(300)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewsDictionary)
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
        
        
        self.nameTxtField = UITextField()
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
        
        self.statusPicker = UIPickerView()
        self.statusPicker.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        //self.statusPicker.frame = CGRectMake(50, 80, 200, 30)
        self.statusPicker.backgroundColor = UIColor.whiteColor()
        self.statusPicker.layer.cornerRadius = 4.0
        
        self.statusPicker.delegate = self
        
        self.containerView.addSubview(self.statusPicker)
        
        
        let statusArray = ["New", "Dispatched", "In Progress", "Complete", "Cancelled"]
        
        self.dateLbl = UILabel()
        self.dateLbl.text = "Work Order Date"
        self.dateLbl.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        
        //self.dateLbl.frame = CGRectMake(10, 259, 200, 30)
        self.dateLbl.layer.cornerRadius = 4.0
        self.containerView.addSubview(self.dateLbl)
        
        self.datePicker = UIDatePicker()
        self.datePicker.datePickerMode = UIDatePickerMode.Date
        self.datePicker.backgroundColor = UIColor.whiteColor()
        self.datePicker.layer.cornerRadius = 4.0
        self.datePicker.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        //self.datePicker.frame = CGRectMake(50, 284, 200, 30)
        self.containerView.addSubview(self.datePicker)
        
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
        let editViewsDictionary = ["view1":self.nameLbl,"view2":self.nameTxtField,"view3":self.statusLbl,"view4":self.statusPicker,"view5":self.dateLbl,"view6":self.datePicker,"view7":self.itemsLbl,"view8":self.itemsTableView]
        
        let metricsDictionary = ["fullWidth": self.view.frame.size.width - 20]
        //let fullWidth = metricsDictionary["fullWidth"]
        //println("fullWidth = \(fullWidth)")
        // piePrice["Apple"]
        
        
        //size constraint
        let nameLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view1(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        let nameLabelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view1(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: editViewsDictionary)
        self.nameLbl.addConstraints(nameLabelConstraint_H)
        self.nameLbl.addConstraints(nameLabelConstraint_V)
        
        let nameValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view2(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        let nameValueConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view2(40)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: editViewsDictionary)
        self.nameTxtField.addConstraints(nameValueConstraint_H)
        self.nameTxtField.addConstraints(nameValueConstraint_V)
        
        let statusLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view3(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        let statusLabelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view3(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: editViewsDictionary)
        self.statusLbl.addConstraints(statusLabelConstraint_H)
        self.statusLbl.addConstraints(statusLabelConstraint_V)
        
        let statusValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view4(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        let statusValueConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view4(200)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: editViewsDictionary)
        self.statusPicker.addConstraints(statusValueConstraint_H)
        self.statusPicker.addConstraints(statusValueConstraint_V)
        
        let dateLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view5(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        let dateLabelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view5(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: editViewsDictionary)
        self.dateLbl.addConstraints(dateLabelConstraint_H)
        self.dateLbl.addConstraints(dateLabelConstraint_V)
        
        let dateValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view6(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        let dateValueConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view6(200)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: editViewsDictionary)
        self.datePicker.addConstraints(dateValueConstraint_H)
        self.datePicker.addConstraints(dateValueConstraint_V)
        
        let itemsLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view7(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        let itemsLabelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view7(20)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: editViewsDictionary)
        self.itemsLbl.addConstraints(itemsLabelConstraint_H)
        self.itemsLbl.addConstraints(itemsLabelConstraint_V)
        
        let itemsTableConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view8(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: editViewsDictionary)
        let itemsTableConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view8(300)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: editViewsDictionary)
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
       // if(editMode == true){
            if(indexPath.row == 0){
                println("add new")
                let itemViewController = ItemViewController(laborMode: true)
                navigationController?.pushViewController(itemViewController, animated: true )
            }else{
                let itemViewController = ItemViewController(laborMode: true)
                navigationController?.pushViewController(itemViewController, animated: true )
            }
       
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









/*


//
//  NewEquipmentViewController.swift
//  EquipmentMaintenance
//
//  Created by nicholasdigiando on 2/24/15.
//  Copyright (c) 2015 Atlantic Lawn and Garden. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class WorkOrderViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIPickerViewDelegate, UITextFieldDelegate,  UIScrollViewDelegate {



var scrollView: UIScrollView!
// var containerView: UIView!


var layoutVars:LayoutVars = LayoutVars()
var customerLbl:UILabel = UILabel()

var statusPicker :UIPickerView!
//var nameTxtField: UITextField!
var makeTxtField: UITextField!
var modelTxtField: UITextField!
var dealerTxtField: UITextField!
var purchasedTxtField: UITextField!
var serialTxtField: UITextField!

//var typeTxtField: UITextField!



var imageView:UIImageView!

//var delegate:MenuDelegate!

let picker = UIImagePickerController()


let type = ["Truck", "Trailer", "Mower", "Weed Trimmer", "Blower", "Chain Saw"]



override func viewDidLoad() {
super.viewDidLoad()


self.scrollView = UIScrollView()
self.scrollView.delegate = self
self.scrollView.contentSize = CGSizeMake(layoutVars.fullWidth, 1000)
self.view.addSubview(self.scrollView)

// self.containerView = UIView()

//self.scrollView.addSubview(self.containerView)




//Looks for single or multiple taps.
var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
self.scrollView.addGestureRecognizer(tap)



// Do any additional setup after loading the view.
view.backgroundColor = layoutVars.backgroundColor
title = "New Equipment"


//custom back button
var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
backButton.addTarget(self, action: "goBack", forControlEvents: UIControlEvents.TouchUpInside)
backButton.setTitle("Back", forState: UIControlState.Normal)
backButton.titleLabel!.font =  layoutVars.buttonFont
backButton.sizeToFit()
var backButtonItem:UIBarButtonItem = UIBarButtonItem(customView: backButton)
navigationItem.leftBarButtonItem  = backButtonItem


var cameraButton = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "displayPickerOptions")
navigationItem.rightBarButtonItem = cameraButton
self.picker.delegate = self


/*
self.nameTxtField = UITextField()
self.nameTxtField.frame = CGRectMake(50, 100, 200, 30)
self.nameTxtField.backgroundColor = UIColor.whiteColor()
self.nameTxtField.layer.cornerRadius = 4.0
self.nameTxtField.attributedPlaceholder = NSAttributedString(string:"Name",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
self.scrollView.addSubview(self.nameTxtField)
*/


self.statusPicker = UIPickerView()
self.statusPicker.frame = CGRectMake(50, 20, 200, 30)
self.statusPicker.backgroundColor = UIColor.whiteColor()
self.statusPicker.layer.cornerRadius = 4.0

self.statusPicker.delegate = self

self.scrollView.addSubview(self.statusPicker)



self.makeTxtField = UITextField()
self.makeTxtField.frame = CGRectMake(50, 200, 200, 30)
self.makeTxtField.backgroundColor = UIColor.whiteColor()
self.makeTxtField.layer.cornerRadius = 4.0
self.makeTxtField.attributedPlaceholder = NSAttributedString(string:"Make",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
self.scrollView.addSubview(self.makeTxtField)




// self.typePicker.hidden = true

//if(typeTxtField.becomeFirstResponder()){
//   self.typePicker.hidden = false

//  }







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
return self.type.count
}

func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
return self.type[row]
}

func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
{
// typeTxtField.text = "\(self.type[row])"

}








//Action Sheet Delegate
func actionSheet(sheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
println("index %d %@", buttonIndex, sheet.buttonTitleAtIndex(buttonIndex));


switch (buttonIndex) {
case 1:
println("camera")
if UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
{
picker.sourceType = UIImagePickerControllerSourceType.Camera
picker.allowsEditing = true
picker.delegate = self
[self .presentViewController(picker, animated: true , completion: nil)]
}
break;
case 2:
println("library")
if UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
{
picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
picker.allowsEditing = true
picker.delegate = self
[self .presentViewController(picker, animated: true , completion: nil)]
}
break;


default:
break;
}
}







func displayPickerOptions() {
println("displayCamera")
var sheet: UIActionSheet = UIActionSheet()
let title: String = "Add a Photo"
sheet.title  = title
sheet.delegate = self
sheet.addButtonWithTitle("Cancel")
sheet.addButtonWithTitle("From Camera")
sheet.addButtonWithTitle("From Library")
sheet.cancelButtonIndex = 0;
sheet.showInView(self.view);
}












//Image Picker Delegates
//pick image
func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
var chosenImage = info[UIImagePickerControllerOriginalImage] as UIImage //2


self.imageView.image = chosenImage //4




dismissViewControllerAnimated(true, completion: nil) //5
}
//cancel
func imagePickerControllerDidCancel(picker: UIImagePickerController) {
dismissViewControllerAnimated(true, completion: nil)
}





func urlRequestWithComponents(urlString:String, parameters:NSDictionary) -> (URLRequestConvertible, NSData) {

// create url request to send
var mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
//let boundaryConstant = "myRandomBoundary12345"
let boundaryConstant = "NET-POST-boundary-\(arc4random())-\(arc4random())"
let contentType = "multipart/form-data;boundary="+boundaryConstant
mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")


// create upload data to send
let uploadData = NSMutableData()

// add parameters
for (key, value) in parameters {

uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)

if value is NetData {
// add image
var postData = value as NetData


//uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(postData.filename)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)

// append content disposition
var filenameClause = " filename=\"\(postData.filename)\""
let contentDispositionString = "Content-Disposition: form-data; name=\"\(key)\";\(filenameClause)\r\n"
let contentDispositionData = contentDispositionString.dataUsingEncoding(NSUTF8StringEncoding)
uploadData.appendData(contentDispositionData!)


// append content type
//uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!) // mark this.
let contentTypeString = "Content-Type: \(postData.mimeType.getString())\r\n\r\n"
let contentTypeData = contentTypeString.dataUsingEncoding(NSUTF8StringEncoding)
uploadData.appendData(contentTypeData!)
uploadData.appendData(postData.data)

}else{
uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
}
}
uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)



// return URLRequestConvertible and NSData
return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
}











func saveData(){
println("saveData")

var parameters = [
"pic"           :NetData(jpegImage: self.imageView.image!, compressionQuanlity: 1.0, filename: "myImage.jpg"),
"otherParm"     :"Value"
]


let urlRequest = self.urlRequestWithComponents("http://www.atlanticlawnandgarden.com/cp/uploads/upload_equipment_image.php", parameters: parameters)

//let urlRequest = self.urlRequestWithComponents("http://test.plantcombos.com/uploadApp.php", parameters: parameters)



Alamofire.upload(urlRequest.0, urlRequest.1)
.progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
println("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
}
.responseJSON { (request, response, JSON, error) in
println("REQUEST \(request)")
println("RESPONSE \(response)")
println("JSON \(JSON)")
println("ERROR \(error)")
}



}






func goBack(){
navigationController?.popViewControllerAnimated(true)

}

func setLabel(lblText:String) {
customerLbl.text = lblText
}

//Calls this function when the tap is recognized.
func DismissKeyboard(){
//Causes the view (or one of its embedded text fields) to resign the first responder status.
//tableView.endEditing(true)

self.view.endEditing(true)
}






override func didReceiveMemoryWarning() {
super.didReceiveMemoryWarning()
// Dispose of any resources that can be recreated.
}


/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
// Get the new view controller using segue.destinationViewController.
// Pass the selected object to the new view controller.
}
*/

}
*/
class IndentLabel :UILabel{
    
    override func drawTextInRect(rect: CGRect) {
        var insets:UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
}