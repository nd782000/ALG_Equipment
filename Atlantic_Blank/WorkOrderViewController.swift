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
    
    var nameLbl:Label!
    var nameValueLbl:Label!
    var nameTxtField: PaddedTextField!//edit mode
    
    var statusLbl:Label!
    var statusValueLbl:Label!
    var statusTxtField: PaddedTextField!
    var statusPicker :Picker!//edit mode
    
    let statusArray = ["New", "Dispatched", "In Progress", "Complete", "Cancelled"]
    
    var dateLbl:Label!
    var dateValueLbl:Label!
    var dateTxtField: PaddedTextField!
    
    let datePickerView = DatePicker()
    var dateFormatter = NSDateFormatter()
    
  
    
    var activeTextField:PaddedTextField?
    
    
    var itemsLbl:Label!
    var itemsTableView: TableView!
    
    let itemArray = ["Regular Maintenance","Oil Filter","Spark Plug","Air Filter","Fuel Filter","Blades","Belts","Tires"]
    
    init(){
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
        
        
        layoutViews()
        
        
    }
    
    
    
    
    //layout for regular mode
    func layoutViews(){
        
        
        var editButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        editButton.addTarget(self, action: "enterEditMode", forControlEvents: UIControlEvents.TouchUpInside)
        editButton.setTitle("Edit", forState: UIControlState.Normal)
        editButton.titleLabel!.font =  layoutVars.buttonFont
        editButton.sizeToFit()
        var editButtonItem:UIBarButtonItem = UIBarButtonItem(customView: editButton)
        navigationItem.rightBarButtonItem  = editButtonItem
        
        
        //name
        
        self.nameLbl = Label(text: "Work Order Name")
        self.containerView.addSubview(self.nameLbl)
        
        /*
        self.nameValueLbl = Label()
        self.nameValueLbl.text = "Name Value"
        self.nameValueLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        self.nameValueLbl.setTranslatesAutoresizingMaskIntoConstraints(false)//for autolayout
        self.containerView.addSubview(self.nameValueLbl)
*/
        self.nameValueLbl = Label(text: "Name Value")
        self.containerView.addSubview(self.nameValueLbl)
        
        //status
        
        self.statusLbl = Label(text: "Work Order Status")
        self.containerView.addSubview(self.statusLbl)
        
        self.statusValueLbl = Label(text:"Status Value")
        self.containerView.addSubview(self.statusValueLbl)
        
        //date
        
        self.dateLbl = Label(text: "Work Order Date")
        self.containerView.addSubview(self.dateLbl)
        
        self.dateValueLbl = Label(text: "Date Value")
        self.containerView.addSubview(self.dateValueLbl)
        
        //items
        
        self.itemsLbl = Label(text: "Work Order Items")
        self.containerView.addSubview(self.itemsLbl)
        
        
        self.itemsTableView  =   TableView()
        self.itemsTableView.delegate  =  self
        self.itemsTableView.dataSource  =  self
        self.itemsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.containerView.addSubview(self.itemsTableView)
        
        
        
        /////////  Auto Layout   //////////////////////////////////////
        
        //auto layout group
        let viewsDictionary = [
            "view1":self.nameLbl,
            "view2":self.nameValueLbl,
            "view3":self.statusLbl,
            "view4":self.statusValueLbl,
            "view5":self.dateLbl,
            "view6":self.dateValueLbl,
            "view7":self.itemsLbl,
            "view8":self.itemsTableView
        ]
        let metricsDictionary = ["fullWidth": self.view.frame.size.width - 20,"inputHeight":layoutVars.inputHeight]
        
        
        //size constraint
        let nameLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view1(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
        
        self.nameLbl.addConstraints(nameLabelConstraint_H as [AnyObject])
        
        let nameValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view2(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
               self.nameValueLbl.addConstraints(nameValueConstraint_H as [AnyObject])
        
        let statusLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view3(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
        self.statusLbl.addConstraints(statusLabelConstraint_H as [AnyObject])
        
        let statusValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view4(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
        self.statusValueLbl.addConstraints(statusValueConstraint_H as [AnyObject])
        
        let dateLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view5(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
        self.dateLbl.addConstraints(dateLabelConstraint_H as [AnyObject])
        
        let dateValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view6(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
        self.dateValueLbl.addConstraints(dateValueConstraint_H as [AnyObject])
        
        let itemsLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view7(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
        self.itemsLbl.addConstraints(itemsLabelConstraint_H as [AnyObject])
        
        let itemsTableConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view8(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
        self.itemsTableView.addConstraints(itemsTableConstraint_H as [AnyObject])
        
        
        
        
        
        //auto layout position constraints
        let viewsConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view1]", options: nil, metrics: nil, views: viewsDictionary)
        let viewsConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[view1(20)]-[view2(inputHeight)]-[view3(20)]-[view4(inputHeight)]-[view5(20)]-[view6(inputHeight)]-[view7(20)]-[view8(200)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: viewsDictionary)
        
        
        self.containerView.addConstraints(viewsConstraint_H as [AnyObject])
        self.containerView.addConstraints(viewsConstraint_V as [AnyObject])
        
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
        
        
        
        self.nameLbl = Label(text: "Work Order Name")
        self.containerView.addSubview(self.nameLbl)
        
        
        self.nameTxtField = PaddedTextField()
        self.nameTxtField.attributedPlaceholder = NSAttributedString(string:"Name",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.containerView.addSubview(self.nameTxtField)
        
        self.statusLbl = Label(text: "Work Order Status")
        self.containerView.addSubview(self.statusLbl)
        
        self.statusPicker = Picker()
        self.statusPicker.delegate = self
        let statusArray = ["New", "Dispatched", "In Progress", "Complete", "Cancelled"]
    
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        var items = [AnyObject]()
        let nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "nextPressed")
        items.append(nextButton)
        // Setup the buttons to be put in the system.
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("endEditingNow") )
        items.append(doneButton)
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
        
        
        
        self.dateLbl = Label(text: "Work Order Date")
        self.containerView.addSubview(self.dateLbl)
        
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
       // DatePickerView.backgroundColor = layoutVars.backgroundLight
       
        
        datePickerView.addTarget( self, action: "handleDatePicker", forControlEvents: UIControlEvents.ValueChanged )
        
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        self.dateTxtField = PaddedTextField()
        self.dateTxtField.returnKeyType = UIReturnKeyType.Next
        self.dateTxtField.delegate = self
        self.dateTxtField.tag = 8
        self.dateTxtField.inputView = self.datePickerView
        self.dateTxtField.inputAccessoryView = toolbar
        self.dateTxtField.attributedPlaceholder = NSAttributedString(string:"Purchased Date",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.containerView.addSubview(self.dateTxtField)
        

        
        //items table
        
        self.itemsLbl = Label(text: "Work Order Items")
        self.containerView.addSubview(self.itemsLbl)
        
        self.itemsTableView  =   TableView()        
        itemsTableView.delegate  =  self
        itemsTableView.dataSource  =  self
        itemsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.containerView.addSubview(itemsTableView)
        
        
        
        /////////  Auto Layout   //////////////////////////////////////
        //apply to each view
        //itemsTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        //auto layout group
        let editViewsDictionary = [
            "view1":self.nameLbl,
            "view2":self.nameTxtField,
            "view3":self.statusLbl,
            "view4":self.statusTxtField,
            "view5":self.dateLbl,
            "view6":self.dateTxtField,
            "view7":self.itemsLbl,
            "view8":self.itemsTableView
        ]
        
        let metricsDictionary = ["fullWidth": self.view.frame.size.width - 20,"inputHeight":layoutVars.inputHeight]
        
        //size constraint
        let nameLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view1(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.nameLbl.addConstraints(nameLabelConstraint_H as [AnyObject])
        
        let nameValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view2(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.nameTxtField.addConstraints(nameValueConstraint_H as [AnyObject])
        
        let statusLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view3(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.statusLbl.addConstraints(statusLabelConstraint_H as [AnyObject])
        
        let statusValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view4(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.statusTxtField.addConstraints(statusValueConstraint_H as [AnyObject])
        
        let dateLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view5(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.dateLbl.addConstraints(dateLabelConstraint_H as [AnyObject])
        
        let dateValueConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view6(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.dateTxtField.addConstraints(dateValueConstraint_H as [AnyObject])
        
        let itemsLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view7(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.itemsLbl.addConstraints(itemsLabelConstraint_H as [AnyObject])
        
        let itemsTableConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view8(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        self.itemsTableView.addConstraints(itemsTableConstraint_H as [AnyObject])
        
        
        
        
        
        //auto layout position constraints
        let viewsConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view1]", options: nil, metrics: nil, views: editViewsDictionary)
        let viewsConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[view1(20)]-[view2(inputHeight)]-[view3(20)]-[view4(inputHeight)]-[view5(20)]-[view6(inputHeight)]-[view7(20)]-[view8(200)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary as [NSObject : AnyObject], views: editViewsDictionary)
        
        
        self.containerView.addConstraints(viewsConstraint_H as [AnyObject])
        self.containerView.addConstraints(viewsConstraint_V as [AnyObject])
        
    }
    
    func removeViews(){
        
        for view in containerView.subviews{
            view.removeFromSuperview()
        }
        
    }
    
    
    
    
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scrollView.frame = view.bounds
       
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
    
    
    
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if(editMode == true){
            return self.itemArray.count + 1 //for "add new" btn
        }else{
            return self.itemArray.count
        }
        
        
        
        
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:UITableViewCell = itemsTableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
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
        println("DATE: \(dateFormatter.stringFromDate(datePickerView.date))")
        self.dateTxtField.text =  dateFormatter.stringFromDate(datePickerView.date)
    }
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        println("PLEASE SCROLL")
        let offset = (textField.frame.origin.y - 150)
        var scrollPoint : CGPoint = CGPointMake(0, offset)
        self.scrollView.setContentOffset(scrollPoint, animated: true)
        self.activeTextField = textField as? PaddedTextField
    }
    
    func textFieldTextDidEndEditing(textField: UITextField) {
        self.scrollView.setContentOffset(CGPointZero, animated: true)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        println("NEXT")
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
    
    
   
    // What to do when a user finishes editting
    func textFieldDidEndEditing(textField: UITextField) {
        
        //nothing fancy here, just trigger the resign() method to close the keyboard.
        resign()
    }
    
    
    
}









