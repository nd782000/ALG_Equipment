//
//  EquipmentViewController.swift
//  Atlantic_Blank
//
//  Created by Nicholas Digiando on 4/6/15.
//  Copyright (c) 2015 Nicholas Digiando. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class EquipmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate {
    
    var layoutVars:LayoutVars = LayoutVars()
    
    var equipmentSet = NSMutableOrderedSet()
    
    var editButton:UIBarButtonItem!
    var delegate:MenuDelegate!
    
    var nameLbl:UILabel!
    var typeNameLbl:UILabel!
    var makeLbl:UILabel!
    var modelLbl:UILabel!
    var statusLbl:UILabel!
    var crewLbl:UILabel!
    var engineLbl:UILabel!
    var fuelLbl:UILabel!
    var mileageLbl:UILabel!
    var imageView:UIImageView!
    
    
    var item:EquipmentInfo!
    
    var partsTableView: UITableView  =   UITableView()
    var scheduleTableView: UITableView  =   UITableView()
    var historyTableView: UITableView  =   UITableView()
    
    init(equip:EquipmentInfo){
        super.init(nibName:nil,bundle:nil)
        
        self.item = equip
        
        title = self.item.name
        
        editButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "editItem")
        navigationItem.rightBarButtonItem = editButton
        
        self.layoutViews()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = layoutVars.backgroundColor
        //title = "Equipment Item"
        
        
        //custom back button
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        backButton.addTarget(self, action: "goBack", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setTitle("Back", forState: UIControlState.Normal)
        backButton.titleLabel!.font =  layoutVars.buttonFont
        backButton.sizeToFit()
        var backButtonItem:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem  = backButtonItem
        
        
        
        let imgUrl = "http://atlanticlawnandgarden.com/cp/uploads/equipment/profiles/thumb_"+self.item.pic
        println(imgUrl)
        self.imageView = UIImageView()
        ImageLoader.sharedLoader.imageForUrl(imgUrl, completionHandler:{(image: UIImage?, url: String) in
            self.imageView.image = image!
        })
        
        self.imageView.frame = CGRect(x: 20, y: 84, width: 144, height: 144)
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2
        self.imageView.layer.borderWidth = 2
        self.imageView.layer.borderColor = layoutVars.borderColor
        self.imageView.clipsToBounds = true
        self.view.addSubview(self.imageView)
        
        
        let items = ["Parts", "Schedule", "History"]
        let equipSC = UISegmentedControl(items: items)
        equipSC.selectedSegmentIndex = 0
        // Set up Frame and SegmentedControl
        let frame = UIScreen.mainScreen().bounds
        equipSC.frame = CGRectMake(20, 248, self.view.frame.size.width - 40, 40)
        equipSC.layer.cornerRadius = 5.0  // Don't let background bleed
        equipSC.backgroundColor = layoutVars.buttonBackground
        equipSC.tintColor = layoutVars.buttonTint
        equipSC.addTarget(self, action: "changeSearchOptions:", forControlEvents: .ValueChanged)
        self.view.addSubview(equipSC)
        
        
        
        
        
        
    }
    
    func layoutViews(){
        
        
        let name = self.item.name
        let typeName = self.item.typeName
        let make = self.item.make
        let model = self.item.model
        let status = self.item.status
        let crew = self.item.crew
        
        nameLbl = UILabel()
        nameLbl.text = name
        nameLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(nameLbl)
        
        typeNameLbl = UILabel()
        typeNameLbl.text = typeName
        typeNameLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(typeNameLbl)
        
        makeLbl = UILabel()
        makeLbl.text = make
        makeLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(makeLbl)
        
        modelLbl = UILabel()
        modelLbl.text = model
        modelLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(modelLbl)
        
        statusLbl = UILabel()
        switch (status) {
        case "2":
            //Out of Service
            statusLbl.text = "Out of Service"
            statusLbl.textColor = UIColor.redColor()
            break;
        case "3":
            //Needs Repair
            statusLbl.text = "Needs Repair"
            statusLbl.textColor = UIColor.orangeColor()
            break;
        case "4":
            //Winterized
            statusLbl.text = "Winterized"
            statusLbl.textColor = UIColor.blueColor()
            break;
            
        default:
            //Online
            statusLbl.text = "Online"
            statusLbl.textColor = UIColor.greenColor()
            break;
        }
        
        statusLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(statusLbl)
        
        crewLbl = UILabel()
        crewLbl.text = crew
        crewLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(crewLbl)
        
        
        
        
        //parts table
        var tableTop:CGFloat = 298
        partsTableView.frame = CGRectMake(0, tableTop, self.view.frame.width, self.view.frame.height - tableTop)
        //clientTableView.setTranslatesAutoresizingMaskIntoConstraints(false) //allows for autolayout
        partsTableView.layer.cornerRadius = 4.0
        
        partsTableView.delegate  =  self
        partsTableView.dataSource  =  self
        partsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(partsTableView)
        
        partsTableView.delegate = self
        partsTableView.dataSource = self
        
        //schedule table
        scheduleTableView.frame = CGRectMake(0, tableTop, self.view.frame.width, self.view.frame.height - tableTop)
        //clientTableView.setTranslatesAutoresizingMaskIntoConstraints(false) //allows for autolayout
        scheduleTableView.layer.cornerRadius = 4.0
        
        scheduleTableView.delegate  =  self
        scheduleTableView.dataSource  =  self
        scheduleTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        
        //history table
        historyTableView.frame = CGRectMake(0, tableTop, self.view.frame.width, self.view.frame.height - tableTop)
        //clientTableView.setTranslatesAutoresizingMaskIntoConstraints(false) //allows for autolayout
        historyTableView.layer.cornerRadius = 4.0
        
        historyTableView.delegate  =  self
        historyTableView.dataSource  =  self
        historyTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        
        
        
        
        
        
        
        
        /////////  Auto Layout   //////////////////////////////////////
        //apply to each view
        //itemsTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        //auto layout group
        let viewsDictionary = ["view1":self.nameLbl,"view2":self.typeNameLbl,"view3":self.makeLbl,"view4":self.modelLbl,"view5":self.statusLbl,"view6":self.crewLbl]
        
        let metricsDictionary = ["fullWidth": self.view.frame.size.width - 174]
        //let fullWidth = metricsDictionary["fullWidth"]
        //println("fullWidth = \(fullWidth)")
        // piePrice["Apple"]
        
        
        //size constraint
        let nameLblConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view1(fullWidth)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let nameLblConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view1(15)]", options:nil, metrics: nil, views: viewsDictionary)
        self.nameLbl.addConstraints(nameLblConstraint_H)
        self.nameLbl.addConstraints(nameLblConstraint_V)
        
        //size constraint
        let typeNameLblConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view2(fullWidth)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let typeNameLblConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view2(15)]", options:nil, metrics: nil, views: viewsDictionary)
        self.typeNameLbl.addConstraints(typeNameLblConstraint_H)
        self.typeNameLbl.addConstraints(typeNameLblConstraint_V)
        
        //size constraint
        let makeLblConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view3(fullWidth)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let makeLblConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view3(15)]", options:nil, metrics: nil, views: viewsDictionary)
        self.makeLbl.addConstraints(makeLblConstraint_H)
        self.makeLbl.addConstraints(makeLblConstraint_V)
        
        //size constraint
        let modelLblConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view4(fullWidth)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let modelLblConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view4(15)]", options:nil, metrics: nil, views: viewsDictionary)
        self.modelLbl.addConstraints(modelLblConstraint_H)
        self.modelLbl.addConstraints(modelLblConstraint_V)
        
        //size constraint
        let statusLblConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view5(fullWidth)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let statusLblConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view5(15)]", options:nil, metrics: nil, views: viewsDictionary)
        self.statusLbl.addConstraints(statusLblConstraint_H)
        self.statusLbl.addConstraints(statusLblConstraint_V)
        
        //size constraint
        let crewLblConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view6(fullWidth)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let crewLblConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view6(15)]", options:nil, metrics: nil, views: viewsDictionary)
        self.crewLbl.addConstraints(crewLblConstraint_H)
        self.crewLbl.addConstraints(crewLblConstraint_V)
        
        
        
        
        //auto layout position constraints
        let viewsConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-184-[view1]", options: nil, metrics: nil, views: viewsDictionary)
        
        let viewsConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-84-[view1]-[view2]-[view3]-[view4]-[view5]-[view6]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewsDictionary)
        
        
        self.view.addConstraints(viewsConstraint_H)
        //self.containerView.addConstraints(viewsConstraint_H2)
        self.view.addConstraints(viewsConstraint_V)
        
        
        
    }
    
    
    func changeSearchOptions(sender: UISegmentedControl) {
        println("changeSearchOptions")
        //remove table views
        for subview in self.view.subviews {
            if (subview is UITableView) {
                subview.removeFromSuperview()
            }
        }
        switch sender.selectedSegmentIndex {
        case 0:
            self.view.addSubview(partsTableView)
        case 1:
            self.view.addSubview(scheduleTableView)
        default:
            self.view.addSubview(historyTableView)
        }
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if (tableView == partsTableView) {
            // Do something
            return 5
        }
            
        else if (tableView == scheduleTableView){
            // Do something else
            return 10
        }else{
            return 15
        }
        
        
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:UITableViewCell = partsTableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        if (tableView == partsTableView) {
            // Do something
            cell.textLabel?.text = "5"
        }
            
        else if (tableView == scheduleTableView){
            // Do something else
            cell.textLabel?.text = "10"
        }else{
            cell.textLabel?.text = "15"
        }
        
        
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //println(" cell Selected #\(indexPath.row)! %@ ",dataArray[indexPath.row] as NSString)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let workOrderViewController = WorkOrderViewController()
        navigationController?.pushViewController(workOrderViewController, animated: true )
        
        
    }
    
    func editItem() {
        println("Edit Item")
        
        let editViewController:NewEquipmentViewController = NewEquipmentViewController()
        navigationController?.pushViewController(editViewController, animated: true )
        
    }
    
    
    func goBack(){
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}