//
//  UsageListViewController.swift
//  Atlantic_Blank
//
//  Created by nicholasdigiando on 4/9/15.
//  Copyright (c) 2015 Nicholas Digiando. All rights reserved.
//


import Foundation
import UIKit


class UsageListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var layoutVars:LayoutVars = LayoutVars()
    
    var usageListTableView: TableView!
    var usageNameArray:NSMutableArray!
    var usageHourArray:NSMutableArray!
    var usageMinuteArray:NSMutableArray!
    var usageTotalArray:NSMutableArray!
    
    var usageID:String!
    var usageName:String!
    
    
    var hourTotal:Int!
    var minuteTotal:Int!
    
    var usageTotalLbl: Label!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = layoutVars.backgroundColor
        title = "Usage List"
        
        
        //custom back button
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.addTarget(self, action: "goBack", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setTitle("Back", forState: UIControlState.Normal)
        backButton.titleLabel!.font =  layoutVars.buttonFont
        backButton.sizeToFit()
        var backButtonItem:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem  = backButtonItem
        
        usageNameArray = ["Nick DiGiando","Nick DiGiando","Brian Sykes","Luis Palma","Brian Sykes","Braulio Ramirez"]
        usageHourArray = ["10","2","5","7","7","5"]
        usageMinuteArray = ["0","15","5","12","12","0"]
        usageTotalArray = ["10 hrs.","2 hrs. 15 mins.","5 hrs.","7 hrs. 12 mins.","7 hrs. 12 mins.","5 hrs."]
        
        
        self.usageListTableView =  TableView()
        
       
        self.usageListTableView.delegate  =  self
        self.usageListTableView.dataSource  =  self
        self.usageListTableView.registerClass(UsageTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.usageListTableView)
        
        self.usageTotalLbl = Label()
        self.view.addSubview(self.usageTotalLbl)
        
        
        /////////  Auto Layout   //////////////////////////////////////
        
        
        let usageViewsDictionary = ["view1": self.usageListTableView,"view2": self.usageTotalLbl]
        
        let metricsDictionary = ["fullWidth": self.view.frame.size.width - 30,"fullHeight":self.view.frame.size.height-126]
        
        //size constraint
        
        let usageLabelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view2(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: usageViewsDictionary)
        self.usageTotalLbl.addConstraints(usageLabelConstraint_H as [AnyObject])

        let usageTableConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view1(fullWidth)]-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: usageViewsDictionary)
        let usageTableConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-76-[view1(fullHeight)]-[view2(30)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: usageViewsDictionary)
        self.view.addConstraints(usageTableConstraint_H as [AnyObject])
        self.view.addConstraints(usageTableConstraint_V as [AnyObject])
        
    }
    
    func computeTimeTotal(){
        for hour in usageHourArray
        {
            println("\(hour)")
           // hourTotal
            
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.usageNameArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:UsageTableViewCell = usageListTableView.dequeueReusableCellWithIdentifier("cell") as! UsageTableViewCell
        
        cell.usageNameLbl.text = self.usageNameArray[indexPath.row] as! NSString as String
        cell.usageTotalLbl.text = self.usageTotalArray[indexPath.row] as! NSString as String
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        usageName =  self.usageNameArray[indexPath.row] as! NSString as String
        usageID = String(indexPath.row)
        
    }
    
    
    func goBack(){
        
              navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}