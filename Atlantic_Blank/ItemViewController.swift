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

class ItemViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate,  UIScrollViewDelegate {
    
    //class WorkOrderViewController: UIViewController{
    
    
    var layoutVars:LayoutVars = LayoutVars()
    var editMode:Bool = false
    var laborMode:Bool! = false
    
    var tapBtn:UIButton!
    
    var nameLabel:H1Label!
    var nameEdit:PaddedTextField!
    
    var descLabel:InfoLabel!
    var descEdit:PaddedTextField!
    
    var statusLabel:Button!
    var statusEdit:PaddedTextField!
    var statusPicker: Picker!

    
    let statusArray = ["Not Started", "Started", "Complete", "Not Needed"]
    
    var item:NSDictionary!
    
    
    //var metricsDictionary:[CGFloat]
    
    
    init(item:NSDictionary) {
        super.init(nibName:nil,bundle:nil)
        self.item = item
        self.editMode = true
        self.laborMode = false
    }
    
    init() {
        super.init(nibName:nil,bundle:nil)
        self.editMode = false
        self.laborMode = false
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
        self.view.backgroundColor = layoutVars.backgroundColor
        
        self.tapBtn = UIButton()
        self.tapBtn.frame = CGRectMake(0, 0, layoutVars.fullWidth, 1000)
        self.tapBtn.backgroundColor = UIColor.clearColor()
        self.tapBtn.addTarget(self, action: "DismissKeyboard", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(self.tapBtn)
        
        if (laborMode == true) {
            layoutLaborViews()
        } else {
            layoutMaterialViews()
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
       
    }
    
    
    func layoutMaterialViews(){
        
        title = "Material Item"
        
        if(editMode == false) {
            var editButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            editButton.addTarget(self, action: "enterEditMode", forControlEvents: UIControlEvents.TouchUpInside)
            editButton.setTitle("Edit", forState: UIControlState.Normal)
            editButton.titleLabel!.font =  layoutVars.buttonFont
            editButton.sizeToFit()
            var editButtonItem:UIBarButtonItem = UIBarButtonItem(customView: editButton)
            navigationItem.rightBarButtonItem  = editButtonItem
            
            var name = item["name"] as! String
            nameLabel = H1Label(text:name)
            self.view.addSubview(nameLabel)
            
            var desc = item["desc"] as! String
            descLabel = InfoLabel(text:desc)
            self.view.addSubview(descLabel)
            
            var status = 1
            statusLabel = Button(titleText: statusArray[status])
            self.view.addSubview(statusLabel)
            
            statusPicker = Picker()
            statusPicker.delegate = self
            statusEdit.delegate = self
            statusEdit.inputView = statusPicker
            self.view.addSubview(self.statusEdit)
            
            
            //auto layout group
            let viewsDictionary = [
                "name":self.nameLabel,
                "desc":self.descLabel,
                "status":self.statusLabel,
            ]
            
            let metricsDictionary = ["fullWidth": layoutVars.fullWidth]
            
            //size constraint
            let nameLblConstraint_H:[AnyObject]! = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[name]-10-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)
            let nameLblConstraint_H1:[AnyObject]! = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[desc]-10-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)
            let nameLblConstraint_H2:[AnyObject]! = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[status]-10-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)
            let viewConstraint_V:[AnyObject]! = NSLayoutConstraint.constraintsWithVisualFormat("V:|-79-[name(40)]-15-[desc(40)]-15-[status(40)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
            
            self.view.addConstraints(nameLblConstraint_H)
            self.view.addConstraints(nameLblConstraint_H1)
            self.view.addConstraints(nameLblConstraint_H2)
            self.view.addConstraints(viewConstraint_V)
            
        } else {
            var name = item["name"] as! String
            nameEdit = PaddedTextField(textValue:name)
            self.view.addSubview(nameEdit)
            
            var desc = item["desc"] as! String
            if(count(desc) > 0) {
                descEdit = PaddedTextField(textValue:desc)
            } else {
                descEdit = PaddedTextField(placeholder: "Item Description")
            }
            
            var status = 1
            statusEdit = PaddedTextField(textValue:statusArray[status])
            self.view.addSubview(statusEdit)
            
            statusPicker = Picker()
            statusPicker.delegate = self
            statusEdit.delegate = self
            statusEdit.inputView = statusPicker
            self.view.addSubview(self.statusEdit)
            
            self.view.addSubview(descEdit)
            
            //auto layout group
            let viewsDictionary = [
                "name":self.nameEdit,
                "desc":self.descEdit,
                "status":self.statusEdit
            ]
            
            let metricsDictionary = ["fullWidth": layoutVars.fullWidth]
            
            //size constraint
            let nameLblConstraint_H:[AnyObject]! = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[name]-10-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)
            let nameLblConstraint_H1:[AnyObject]! = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[desc]-10-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)
            let nameLblConstraint_H2:[AnyObject]! = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[status]-10-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)
            let viewConstraint_V:[AnyObject]! = NSLayoutConstraint.constraintsWithVisualFormat("V:|-79-[name(40)]-15-[desc(40)]-15-[status(40)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
            
            self.view.addConstraints(nameLblConstraint_H)
            self.view.addConstraints(nameLblConstraint_H1)
            self.view.addConstraints(nameLblConstraint_H2)
            self.view.addConstraints(viewConstraint_V)
            
        }
        
        
        
    }
    
    
    
    func enterEditMode(){
        editMode = true
        removeViews()
        

        
    }
    
    func exitEditMode(){
        editMode = false
        removeViews()

        
    }
    
    
    
    
    
    func showUsageList(){
        println("show usage list")
        let usageListViewController = UsageListViewController()
        navigationController?.pushViewController(usageListViewController, animated: true )
    }
    
    
    
    func editType(){
        println("editType")
        let itemListViewController = ItemListViewController()
        navigationController?.pushViewController(itemListViewController, animated: true )
    }
    

    
    func removeViews(){
        
        for view in self.view.subviews{
            view.removeFromSuperview()
        }
        
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
        self.statusEdit.text = "\(self.statusArray[row])"
        
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