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
    var infoView:UIView!
    var equipSC:SegmentedControl!
    
    var item:EquipmentInfo!
    
    var table: TableView = TableView()
    var tableData:NSArray! = ["Work Order 1","Work Order 2","Work Order 3","Work Order 4","Work Order 5","Work Order 6","Work Order 7"]
    
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
        
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.addTarget(self, action: "goBack", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setTitle("Back", forState: UIControlState.Normal)
        backButton.titleLabel!.font =  layoutVars.buttonFont
        backButton.sizeToFit()
        var backButtonItem:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem  = backButtonItem
        
    }
    
    func layoutViews(){
        
        let name = self.item.name
        let typeName = self.item.typeName
        let make = self.item.make
        let model = self.item.model
        let status = self.item.status
        let crew = self.item.crew
        
        let imgUrl = "http://atlanticlawnandgarden.com/cp/uploads/equipment/profiles/thumb_"+self.item.pic
        self.imageView = UIImageView()
        ImageLoader.sharedLoader.imageForUrl(imgUrl, completionHandler:{(image: UIImage?, url: String) in
            self.imageView.image = image!
        })
        
        self.infoView = UIView()
        self.infoView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(infoView)
        
        self.imageView.layer.cornerRadius = 5.0
        self.imageView.layer.borderWidth = 2
        self.imageView.layer.borderColor = layoutVars.borderColor
        self.imageView.clipsToBounds = true
        self.imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(self.imageView)
        
        nameLbl = UILabel()
        nameLbl.text = name
        nameLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.infoView.addSubview(nameLbl)
        
        typeNameLbl = UILabel()
        typeNameLbl.text = typeName
        typeNameLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.infoView.addSubview(typeNameLbl)
        
        makeLbl = UILabel()
        makeLbl.text = make
        makeLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.infoView.addSubview(makeLbl)
        
        modelLbl = UILabel()
        modelLbl.text = model
        modelLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.infoView.addSubview(modelLbl)
        
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
        self.infoView.addSubview(statusLbl)
        
        crewLbl = UILabel()
        crewLbl.text = crew
        crewLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.infoView.addSubview(crewLbl)
        
        let items = ["Parts", "Schedule", "History"]
        equipSC = SegmentedControl(items: items)
        equipSC.selectedSegmentIndex = 0
        
        equipSC.addTarget(self, action: "changeSearchOptions:", forControlEvents: .ValueChanged)
        self.view.addSubview(equipSC)
        
        table.delegate  =  self
        table.dataSource  =  self
        table.registerClass(Cell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(table)
        
        /////////  Auto Layout   //////////////////////////////////////
        //apply to each view
        //itemsTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        //auto layout group
        let viewsDictionary = [
            "name":self.nameLbl,
            "type":self.typeNameLbl,
            "make":self.makeLbl,
            "model":self.modelLbl,
            "status":self.statusLbl,
            "crew":self.crewLbl
        ]
        
        let metricsDictionary = ["fullWidth": layoutVars.fullWidth]
        
        //size constraint
        let nameLblConstraint_H:[AnyObject]! = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[name]-10-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let typeLblConstraint_H:[AnyObject]! = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[type]-10-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let makeLblConstraint_H:[AnyObject]! = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[make]-10-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let modelLblConstraint_H:[AnyObject]! = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[model]-10-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let statusLblConstraint_H:[AnyObject]! = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[status]-10-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let crewLblConstraint_H:[AnyObject]! = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[crew]-10-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let infoViewConstraint_V:[AnyObject]! = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[name]-10-[type]-10-[make]-10-[model]-10-[status]-10-[crew]-10-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)

        self.infoView.addConstraints(nameLblConstraint_H)
        self.infoView.addConstraints(typeLblConstraint_H)
        self.infoView.addConstraints(makeLblConstraint_H)
        self.infoView.addConstraints(modelLblConstraint_H)
        self.infoView.addConstraints(statusLblConstraint_H)
        self.infoView.addConstraints(crewLblConstraint_H)
        self.infoView.addConstraints(infoViewConstraint_V)
        
        
        let layoutDictionary = [
            "image":self.imageView,
            "info":self.infoView,
            "sc":self.equipSC,
            "table":self.table
        ]
        
        let metrics = [
            "infoWidth": layoutVars.fullWidth - 184
        ]
        
        
        //auto layout position constraints
        let topConstraint_H:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[image(144)]-15-[info(infoWidth)]-15-|", options: nil, metrics: metrics, views: layoutDictionary)
        let scConstraint_H:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[sc]-15-|", options: nil, metrics: nil, views: layoutDictionary)
        let tableConstraint_H:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[table]-15-|", options: nil, metrics: nil, views: layoutDictionary)
        let viewsConstraint_V:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-79-[image(144)]-15-[sc(40)]-15-[table]-15-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: layoutDictionary)
        let viewsConstraint_V2:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-79-[info(144)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: layoutDictionary)
        
        
        self.view.addConstraints(topConstraint_H)
        self.view.addConstraints(scConstraint_H)
        self.view.addConstraints(tableConstraint_H)
        self.view.addConstraints(viewsConstraint_V)
        self.view.addConstraints(viewsConstraint_V2)
        
    }
    
    
    func changeSearchOptions(sender: UISegmentedControl) {
        println("changeSearchOptions")
        
        switch sender.selectedSegmentIndex {
            case 0:
                println("1")
                break
            case 1:
                println("2")
                break
            case 2:
                println("3")
                break
            default:
                println("DEFAULT")
                break
        }
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            return tableData.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:Cell = table.dequeueReusableCellWithIdentifier("cell") as! Cell
        
        cell.textLabel?.text = tableData[indexPath.row] as? String
        
        return cell
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