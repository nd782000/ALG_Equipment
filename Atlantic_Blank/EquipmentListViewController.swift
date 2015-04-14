//
//  EquipmentListViewController.swift
//  Atlantic_Blank
//
//  Created by Nicholas Digiando on 4/6/15.
//  Copyright (c) 2015 Nicholas Digiando. All rights reserved.
//

import UIKit
import Alamofire

class EquipmentListViewController: ViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {
    var newEquipmentButton:UIBarButtonItem!
    var refreshControl:UIRefreshControl!
    var equipmentListTableView: TableView!
    
    var equipmentSet:NSMutableOrderedSet! = NSMutableOrderedSet()
    
    var sd:NSSortDescriptor!
    
    var nameArray:NSMutableArray!
    var typeArray:NSMutableArray!
    var makeArray:NSMutableArray!
    var modelArray:NSMutableArray!
    var crewArray:NSMutableArray!
    var layoutVars:LayoutVars = LayoutVars()
    
    var sort:Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newEquipmentButton = UIBarButtonItem(title: "New", style: .Plain, target: self, action: "displayNewEquipmentView")
        navigationItem.leftBarButtonItem = newEquipmentButton
        
        view.backgroundColor = layoutVars.backgroundColor
        self.nameArray = []
        self.makeArray = []
        self.modelArray = []
        self.typeArray = []
        self.crewArray = []
        self.navigationItem.title = "Equipment List"
        
        let items = ["Name", "Status", "Make", "Crew"]
        let customSC = SegmentedControl(items: items)
        customSC.addTarget(self, action: "changeSearchOptions:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.view.addSubview(customSC)
        
        self.equipmentListTableView =  TableView()
        self.equipmentListTableView.delegate  =  self
        self.equipmentListTableView.dataSource  =  self
        self.equipmentListTableView.registerClass(EquipmentTableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(self.equipmentListTableView)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.equipmentListTableView.addSubview(refreshControl)
        
        
        /////////////////  Auto Layout   ////////////////////////////////////////////////
        
        
        //auto layout group
        let viewsDictionary = [
            "bar":customSC,
            "table":self.equipmentListTableView
        ]
        
        let sizeVals = ["width": layoutVars.fullWidth - 30,"height": 40]
        
        //////////////   auto layout position constraints   /////////////////////////////
        
        let viewsConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[bar]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        
        let tableConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[table]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        
        
        let viewsConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-79-[bar(height)]-15-[table]-15-|", options:NSLayoutFormatOptions.AlignAllLeft, metrics: sizeVals, views: viewsDictionary)
        
        
        self.view.addConstraints(tableConstraint_H as [AnyObject])
        self.view.addConstraints(viewsConstraint_H as [AnyObject])
        self.view.addConstraints(viewsConstraint_V as [AnyObject])
        
        getEquipmentList()
        
    }
    
    
    
    
    
    
    func getEquipmentList() {

        Alamofire.request(EquipmentAPI.Router.EquipmentList()).responseJSON() {
            (_, _, JSON, error) in
            
            //println("JSON 1 \(JSON)")
            
            if error == nil {

                let equipmentInfos = ((JSON as! NSDictionary).valueForKey("equipment") as! [NSDictionary]).map {
                    EquipmentInfo(id: $0["ID"] as! String, name: $0["name"] as! String, typeName: $0["typeName"] as! String, make: $0["make"] as! String, model: $0["model"] as! String, status: $0["status"] as! String, crew: $0["crew"] as! String, mileage: $0["mileage"] as! String, fuel: $0["fuel"] as! String, engine: $0["engine"] as! String, pic: $0["pic"] as! String)
                }
                
                let lastItem = self.equipmentSet.count

                self.equipmentSet.addObjectsFromArray(equipmentInfos)
                
                switch self.sort {
                case 0:
                    self.sd = NSSortDescriptor(key: "name", ascending: true)
                    self.equipmentSet.sortUsingDescriptors([self.sd])
                    self.equipmentListTableView.reloadData()
                case 1:
                    self.sd = NSSortDescriptor(key: "status", ascending: true)
                    self.equipmentSet.sortUsingDescriptors([self.sd])
                    self.equipmentListTableView.reloadData()
                case 2:
                    self.sd = NSSortDescriptor(key: "make", ascending: true)
                    self.equipmentSet.sortUsingDescriptors([self.sd])
                    self.equipmentListTableView.reloadData()
                case 3:
                    self.sd = NSSortDescriptor(key: "crew", ascending: true)
                    self.equipmentSet.sortUsingDescriptors([self.sd])
                    self.equipmentListTableView.reloadData()
                default:
                    self.sd = NSSortDescriptor(key: "name", ascending: true)
                    self.equipmentSet.sortUsingDescriptors([self.sd])
                    self.equipmentListTableView.reloadData()
                }
                
                
                let indexPaths = (lastItem..<self.equipmentSet.count).map { NSIndexPath(forItem: $0, inSection: 0) }
                
                self.equipmentListTableView.reloadData()
                self.refreshControl.endRefreshing()
                
            } else {
                println("JSON ERROR: \(JSON)")
            }
            
        }
    }
    
    
    
    func refresh(sender:AnyObject)
    {
        // Code to refresh table view
        getEquipmentList()
        
    }
    
    
    
    
    func displayNewEquipmentView() {
        println("displayNewEquipmentView")
        
        delegate.menuChange(4)
        
    }
    
    
    func changeSearchOptions(sender: UISegmentedControl) {
        println("changeSearchOptions:\(sender.selectedSegmentIndex)")
        sort = sender.selectedSegmentIndex
        switch sender.selectedSegmentIndex {
        case 0:
            sd = NSSortDescriptor(key: "name", ascending: true)
            equipmentSet.sortUsingDescriptors([self.sd])
            self.equipmentListTableView.reloadData()
        case 1:
            sd = NSSortDescriptor(key: "status", ascending: true)
            equipmentSet.sortUsingDescriptors([self.sd])
            self.equipmentListTableView.reloadData()
        case 2:
            sd = NSSortDescriptor(key: "make", ascending: true)
            equipmentSet.sortUsingDescriptors([self.sd])
            self.equipmentListTableView.reloadData()
        case 3:
            sd = NSSortDescriptor(key: "crew", ascending: true)
            equipmentSet.sortUsingDescriptors([self.sd])
            self.equipmentListTableView.reloadData()
        default:
            sd = sd.reversedSortDescriptor as! NSSortDescriptor
            equipmentSet.sortUsingDescriptors([self.sd])
            self.equipmentListTableView.reloadData()
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.equipmentSet.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{

        let id = (self.equipmentSet.objectAtIndex(indexPath.row) as! EquipmentInfo).id
        let status = (self.equipmentSet.objectAtIndex(indexPath.row) as! EquipmentInfo).status
        let name = (self.equipmentSet.objectAtIndex(indexPath.row) as! EquipmentInfo).name
        let typeName = (self.equipmentSet.objectAtIndex(indexPath.row) as! EquipmentInfo).typeName
        let make = (self.equipmentSet.objectAtIndex(indexPath.row) as! EquipmentInfo).make
        let crew = (self.equipmentSet.objectAtIndex(indexPath.row) as! EquipmentInfo).crew
        
        var cell:EquipmentTableViewCell = equipmentListTableView.dequeueReusableCellWithIdentifier("cell") as! EquipmentTableViewCell
        
        cell.id = id
        cell.setStatus(status)
        cell.nameLbl.text = name
        cell.typeNameLbl.text = typeName
        cell.makeLbl.text = make
        cell.crewLbl.text = crew
        
        return cell;
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
        let id = (self.equipmentSet.objectAtIndex(indexPath.row) as! EquipmentInfo).id
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var eq = self.equipmentSet.objectAtIndex(indexPath.row) as! EquipmentInfo
        let equipmentViewController = EquipmentViewController(equip: eq)
        navigationController?.pushViewController(equipmentViewController, animated: true )
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}