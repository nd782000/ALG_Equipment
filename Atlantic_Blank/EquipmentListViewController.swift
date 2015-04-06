//
//  EquipmentListViewController.swift
//  Atlantic_Blank
//
//  Created by Nicholas Digiando on 4/6/15.
//  Copyright (c) 2015 Nicholas Digiando. All rights reserved.
//

import UIKit
import Alamofire
//import EquipmentTableViewCell


class EquipmentListViewController: ViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {
    var newEquipmentButton:UIBarButtonItem!
    var refreshControl:UIRefreshControl!
    var equipmentListTableView: UITableView!
    
    var equipmentSet:NSMutableOrderedSet!
    
    var sd:NSSortDescriptor!
    
    var nameArray:NSMutableArray!
    var typeArray:NSMutableArray!
    var makeArray:NSMutableArray!
    var modelArray:NSMutableArray!
    var crewArray:NSMutableArray!
    var layoutVars:LayoutVars = LayoutVars()
    
    var sort:Int! = 0
    
    //var delegate:MenuDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        newEquipmentButton = UIBarButtonItem(title: "New", style: .Plain, target: self, action: "displayNewEquipmentView")
        navigationItem.leftBarButtonItem = newEquipmentButton
        
        
        view.backgroundColor = layoutVars.backgroundColor
        //self.delegate = self
        self.nameArray = []
        self.makeArray = []
        self.modelArray = []
        self.typeArray = []
        self.crewArray = []
        self.navigationItem.title = "Equipment List"
        
        let items = ["Name", "Status", "Make", "Crew"]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        // Set up Frame and SegmentedControl
        let frame = UIScreen.mainScreen().bounds
        customSC.frame = CGRectMake(20, 74, self.view.frame.size.width - 40, 40)
        customSC.layer.cornerRadius = 5.0  // Don't let background bleed
        customSC.backgroundColor = layoutVars.buttonBackground
        customSC.tintColor = layoutVars.buttonTint
        customSC.addTarget(self, action: "changeSearchOptions:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.view.addSubview(customSC)
        
        
        var tableX = (self.view.frame.size.width - 300)/2;
        
        
        
        
        self.equipmentListTableView =  UITableView()
        equipmentListTableView.frame = CGRectMake(0, 124, self.view.frame.size.width, self.view.frame.size.height - 124)
        equipmentListTableView.layer.cornerRadius = 4.0
        //equipmentListTableView.setTranslatesAutoresizingMaskIntoConstraints(false) //allows for autolayout
        equipmentListTableView.delegate  =  self
        equipmentListTableView.dataSource  =  self
        equipmentListTableView.registerClass(EquipmentTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(equipmentListTableView)
        
        
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.equipmentListTableView.addSubview(refreshControl)
        
        
        //getEquipmentList()
        
        getEquipmentList()
        
        // for elem in dataArray {
        //println(elem)
        // }
        
        /*
        println("1")
        Alamofire.request(.POST, "http://www.atlanticlawnandgarden.com/cp/app/equipment.php")
        .responseJSON { (request, response, JSON, error) in
        if let jsonResult = JSON as? NSMutableArray! {
        println("json = \(jsonResult)")
        println("2")
        self.itemArray = jsonResult
        self.equipmentListTableView.reloadData()
        } else {
        println("fail")
        }
        
        if (error != nil) {
        println("Error")
        println(error)
        }
        
        }
        
        
        //clientTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        */
        
        
        
        
        /*
        
        var newEvaluationButton   = UIButton.buttonWithType(UIButtonType.System) as UIButton
        newEvaluationButton.setTranslatesAutoresizingMaskIntoConstraints(false) //allows for autolayout
        newEvaluationButton.layer.cornerRadius = 4.0
        //newEvaluationButton.center = self.view.center
        newEvaluationButton.backgroundColor = layoutVars.buttonColor1
        newEvaluationButton.setTitle("New Evaluation", forState: UIControlState.Normal)
        newEvaluationButton.titleLabel!.font =  layoutVars.buttonFont
        newEvaluationButton.setTitleColor(layoutVars.buttonTextColor, forState: UIControlState.Normal)
        newEvaluationButton.addTarget(self, action: "displayClientList", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(newEvaluationButton)
        
        
        
        
        //--------------- constraints
        
        //instead of using literals you can use metrics
        let metricsDictionary = ["view1Width":self.view.frame.size.width,"view1Height": 50.0,"view2Height":40.0,"viewWidth":50.0,"navHeight":layoutVars.navAndStatusBarHeight + 20 ]
        
        //make dictionary for views
        let viewsDictionary = ["view1":newEvaluationButton,"view2":equipmentListTableView]
        
        //sizing constraints added to individual views
        //equipmentListTableView
        let view1_constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:[view1(>=300)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let view1_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:[view1(40)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        newEvaluationButton.addConstraints(view1_constraint_H)
        newEvaluationButton.addConstraints(view1_constraint_V)
        
        let view2_constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:[view2(>=300)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let view2_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:[view2(>=200)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        equipmentListTableView.addConstraints(view2_constraint_H)
        equipmentListTableView.addConstraints(view2_constraint_V)
        
        //position constraints added to parent view
        //view
        let view_constraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view1]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let view_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-navHeight-[view1]-[view2]-0-|", options: NSLayoutFormatOptions.AlignAllLeading, metrics: metricsDictionary, views: viewsDictionary)
        
        view.addConstraints(view_constraint_H)
        view.addConstraints(view_constraint_V)
        
        */
        
        
        
    }
    
    
    
    
    
    
    func getEquipmentList() {
        // 2
        //if populatingPhotos {
        //return
        // }
        self.equipmentSet = NSMutableOrderedSet()
        // populatingPhotos = true
        println("getEquipmentList")
        // 3 use router with current page number
        Alamofire.request(EquipmentAPI.Router.EquipmentList()).responseJSON() {
            (_, _, JSON, error) in
            
            //println("photoBrowserCollectionVC")
            println("JSON 1 \(JSON)")
            if error == nil {
                // 4 Make careful note that the completion handler — the trailing closure of .responseJSON() — must run on the main thread. If you’re performing any long-running operations, such as making an API call, you must use GCD to dispatch your code on another queue. In this case, you’re using DISPATCH_QUEUE_PRIORITY_HIGH to run this activity
                
                // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                // 5 use photos key of json response, each dictionary deals with one photo
                
                //6 use Swift’s filter function to filter out NSFW (Not Safe For Work) images
                
                //7 The map function takes a closure and returns an array of EquipmentInfo objects. This class is defined in Five100px.swift. If you look at the code of this class, you’ll see that it overrides both isEqual and hash. Both of these methods use an integer for the id property so ordering and uniquing EquipmentInfo objects will still be a relatively fast operation.
                //println("JSON 2 \(JSON)")
                /*
                if let items = (JSON as NSDictionary).valueForKey("equipment") as? NSArray {
                for item in items {
                let str = item["ID"]
                println("item = \(str)")
                // construct your model objects here
                }
                // self.equipmentSet.addObjectsFromArray(items)
                }
                */
                
                
                let equipmentInfos = ((JSON as NSDictionary).valueForKey("equipment") as [NSDictionary]).map {
                    EquipmentInfo(id: $0["ID"] as String, name: $0["name"] as String, typeName: $0["typeName"] as String, make: $0["make"] as String, model: $0["model"] as String, status: $0["status"] as String, crew: $0["crew"] as String, mileage: $0["mileage"] as String, fuel: $0["fuel"] as String, engine: $0["engine"] as String, pic: $0["pic"] as String)
                }
                
                //println("photoInfos = \(equipmentInfos)")
                //println("photoInfos[0]['genus'] \(equipmentInfos[0])")
                
                // 8 store number of photos to update collectionView
                let lastItem = self.equipmentSet.count
                // 9 If someone uploaded new photos to 500px.com before you scrolled, the next batch of photos you get might contain a few photos that you’d already downloaded. That’s why you defined var photos = NSMutableOrderedSet() as a set; since all items in a set must be unique, this guarantees you won’t show a photo more than once.
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
                
                
                
                // 10 Here you create an array of NSIndexPath objects to insert into collectionView
                let indexPaths = (lastItem..<self.equipmentSet.count).map { NSIndexPath(forItem: $0, inSection: 0) }
                
                // 11 Inserts the items in the collection view – but does so on the main queue, because all UIKit operations must be done on the main queue
                //dispatch_async(dispatch_get_main_queue()) {
                // self.collectionView!.insertItemsAtIndexPaths(indexPaths)
                //}
                println("self.equipmentListTableView.reloadData()")
                //self.equipmentListTableView.reloadData()
                
                //self.currentPage++
                
                self.equipmentListTableView.reloadData()
                self.refreshControl.endRefreshing()
                
                // }
            }
            
            //self.populatingPhotos = false
            
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
            sd = sd.reversedSortDescriptor as NSSortDescriptor
            equipmentSet.sortUsingDescriptors([self.sd])
            self.equipmentListTableView.reloadData()
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        println("self.equipmentSet.count = \(self.equipmentSet.count)")
        return self.equipmentSet.count
        //return self.nameArray.count  //Currently Giving default Value
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        //println("tableview.cellForRowAtIndexPath")
        let id = (self.equipmentSet.objectAtIndex(indexPath.row) as EquipmentInfo).id
        let status = (self.equipmentSet.objectAtIndex(indexPath.row) as EquipmentInfo).status
        let name = (self.equipmentSet.objectAtIndex(indexPath.row) as EquipmentInfo).name
        let typeName = (self.equipmentSet.objectAtIndex(indexPath.row) as EquipmentInfo).typeName
        let make = (self.equipmentSet.objectAtIndex(indexPath.row) as EquipmentInfo).make
        let crew = (self.equipmentSet.objectAtIndex(indexPath.row) as EquipmentInfo).crew
        
        //let imageURL = self.equipmentSet.objectAtIndex(indexPath.row) as NSString
        
        
        //println("make = \(make)")
        
        var cell:EquipmentTableViewCell = equipmentListTableView.dequeueReusableCellWithIdentifier("cell") as EquipmentTableViewCell
        
        cell.id = id
        cell.setStatus(status)
        cell.nameLbl.text = name
        cell.typeNameLbl.text = typeName
        cell.makeLbl.text = make
        cell.crewLbl.text = crew
        /*
        cell.equipName.text = self.nameArray[indexPath.row] as NSString
        cell.equipMake.text = self.makeArray[indexPath.row] as NSString
        cell.equipModel.text = self.modelArray[indexPath.row] as NSString
        cell.equipType.text = self.typeArray[indexPath.row] as NSString
        cell.equipCrew.text = self.crewArray[indexPath.row] as NSString
        */
        
        return cell;
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
        let id = (self.equipmentSet.objectAtIndex(indexPath.row) as EquipmentInfo).id
        //displayEquipment()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var eq = self.equipmentSet.objectAtIndex(indexPath.row) as EquipmentInfo
        println("\(eq)")
        let equipmentViewController = EquipmentViewController(equip: eq)
        navigationController?.pushViewController(equipmentViewController, animated: true )
        
    }
    
    /*
    
    func displayEquipment() {
    let equipmentViewController = EquipmentViewController()
    navigationController?.pushViewController(equipmentViewController, animated: true )
    }
    */
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}