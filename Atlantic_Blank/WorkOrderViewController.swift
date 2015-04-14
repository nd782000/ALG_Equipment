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

class WorkOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    //class WorkOrderViewController: UIViewController{
    
    
    var layoutVars:LayoutVars = LayoutVars()
    var editMode:Bool = false
    
    var scrollView: UIScrollView!
    var tapBtn:UIButton!
    
    var customerBtn: Button!
    var dateBtn: Button!
    
    var infoView: UIView! = UIView()
    
    var crewLbl:UILabel!
    var crew:UILabel!
    var ctLbl:UILabel!
    var ct:UILabel!
    var notesLbl:UILabel!
    var notes:UILabel!
    
    var statusBtn:Button!
    var statusLbl:Label!
    var statusValueLbl:Label!
    var statusTxtField: PaddedTextField!
    var statusPicker :Picker!
    
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
        view.backgroundColor = layoutVars.backgroundColor
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
        
        layoutViews()
        
    }
    
    
    func layoutViews(){
        
        
        var editButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        editButton.addTarget(self, action: "enterEditMode", forControlEvents: UIControlEvents.TouchUpInside)
        editButton.setTitle("Edit", forState: UIControlState.Normal)
        editButton.titleLabel!.font =  layoutVars.buttonFont
        editButton.sizeToFit()
        var editButtonItem:UIBarButtonItem = UIBarButtonItem(customView: editButton)
        navigationItem.rightBarButtonItem  = editButtonItem
        
        self.customerBtn = Button(titleText: "Customer Name")
        self.dateBtn = Button(titleText: "10/11/12")
        self.view.addSubview(customerBtn)
        self.view.addSubview(dateBtn)
        
        // Info Window
        
        self.infoView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.infoView.backgroundColor = UIColor(hex:0xFFFFFF, op: 0.8)
        self.infoView.layer.cornerRadius = 4
        
        self.crewLbl = UILabel()
        self.crewLbl.text = "Crew:"
        self.crewLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.crew = UILabel()
        self.crew.text = "SHP"
        self.crew.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.ctLbl = UILabel()
        self.ctLbl.text = "Charge Type:"
        self.ctLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.ct = UILabel()
        self.ct.text = "FC"
        self.ct.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.notesLbl = UILabel()
        self.notesLbl.text = "Notes:"
        self.notesLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.notes = UILabel()
        self.notes.text = "Some notes go here (this is some extra text just to test that it wraps)"
        self.notes.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        self.notes.numberOfLines = 0
        self.notes.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.infoView.addSubview(crewLbl)
        self.infoView.addSubview(crew)
        self.infoView.addSubview(ctLbl)
        self.infoView.addSubview(ct)
        self.infoView.addSubview(notesLbl)
        self.infoView.addSubview(notes)
        
        self.statusBtn = Button(titleText: "In Progress")
        self.statusBtn.backgroundColor = UIColor(hex:0xE09E43, op:1)
        self.view.addSubview(statusBtn)
        
        //status
        
        self.statusLbl = Label(text: "Work Order Status")
        self.statusValueLbl = Label(text:"Status Value")
        self.infoView.addSubview(statusLbl)
        
        //date
        
        self.dateLbl = Label(text: "Work Order Date")
        
        self.dateValueLbl = Label(text: "Date Value")
        
        //items
        
        self.itemsLbl = Label(text: "Work Order Items")
        
        
        self.itemsTableView  =   TableView()
        self.itemsTableView.delegate  =  self
        self.itemsTableView.dataSource  =  self
        self.itemsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.itemsTableView)
        
        self.view.addSubview(infoView)
        
        /////////  Auto Layout   //////////////////////////////////////
        
        
        //auto layout group
        let infoDictionary = [
            "crewLbl":self.crewLbl,
            "crew":self.crew,
            "ctLbl":self.ctLbl,
            "ct":self.ct,
            "notesLbl":self.notesLbl,
            "notes":self.notes
        ]
        let metricsDictionary = ["fullWidth": layoutVars.fullWidth - 30]
        
        
        //size constraint
        let infoConstraint_H:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[crewLbl(60)][crew]-15-[ctLbl(115)][ct]-10-|", options: nil, metrics: metricsDictionary, views: infoDictionary)
        let infoConstraint_H2:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[notesLbl(60)][notes]-10-|", options: nil, metrics: metricsDictionary, views: infoDictionary)
        let infoConstraint_V:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[crewLbl]-10-[notesLbl]-10-|", options: nil, metrics: metricsDictionary, views: infoDictionary)
        let infoConstraint_V1:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[crew]-10-[notes]-10-|", options: nil, metrics: metricsDictionary, views: infoDictionary)
        let infoConstraint_V2:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[ctLbl]-10-[notesLbl]-10-|", options: nil, metrics: metricsDictionary, views: infoDictionary)
        let infoConstraint_V3:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[ct]-10-[notes]-10-|", options: nil, metrics: metricsDictionary, views: infoDictionary)


        
        self.infoView.addConstraints(infoConstraint_H)
        self.infoView.addConstraints(infoConstraint_H2)
        self.infoView.addConstraints(infoConstraint_V)
        self.infoView.addConstraints(infoConstraint_V1)
        self.infoView.addConstraints(infoConstraint_V2)
        self.infoView.addConstraints(infoConstraint_V3)
        
        //auto layout group
        let viewsDictionary = [
            "customerBtn":self.customerBtn,
            "dateBtn":self.dateBtn,
            "info":self.infoView,
            "table":self.itemsTableView,
            "status":self.statusBtn
        ]
        
        //size constraint
        let btnConstraint_H:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[customerBtn]-15-[dateBtn]-15-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let infoViewConstraint_H:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[info]-15-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let tableConstraint_H:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[table]-15-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let statusConstraint_H:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[status]-15-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let pageConstraint_V1:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-79-[customerBtn(40)]-15-[info]-15-[table]-15-[status]-15-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let pageConstraint_V2:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-79-[dateBtn(40)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        
        self.view.addConstraints(btnConstraint_H)
        self.view.addConstraints(infoViewConstraint_H)
        self.view.addConstraints(tableConstraint_H)
        self.view.addConstraints(statusConstraint_H)
        self.view.addConstraints(pageConstraint_V1)
        self.view.addConstraints(pageConstraint_V2)
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
        
        //self.containerView.addSubview(self.tapBtn)
        
        
        
        //self.nameTxtField = PaddedTextField()
        //self.nameTxtField.attributedPlaceholder = NSAttributedString(string:"Name",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        //self.containerView.addSubview(self.nameTxtField)
        
        self.statusLbl = Label(text: "Work Order Status")
        //self.containerView.addSubview(self.statusLbl)
        
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
        //self.containerView.addSubview(self.statusTxtField)
        
        
        
        self.dateLbl = Label(text: "Work Order Date")
        //self.containerView.addSubview(self.dateLbl)
        
        
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
        //self.containerView.addSubview(self.dateTxtField)
        

        
        //items table
        
        self.itemsLbl = Label(text: "Work Order Items")
        //self.containerView.addSubview(self.itemsLbl)
        
        self.itemsTableView  =   TableView()        
        itemsTableView.delegate  =  self
        itemsTableView.dataSource  =  self
        itemsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //self.containerView.addSubview(itemsTableView)
        
        
        
        
    }
    
    func removeViews(){
        
        for view in self.view.subviews{
            view.removeFromSuperview()
        }
        
    }
    
    
    
    
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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









