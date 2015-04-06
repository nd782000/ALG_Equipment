//
//  ItemListViewController.swift
//  Atlantic_Blank
//
//  Created by Nicholas Digiando on 4/6/15.
//  Copyright (c) 2015 Nicholas Digiando. All rights reserved.
//

import Foundation
import UIKit


class ItemListViewController: ViewController, UITableViewDelegate, UITableViewDataSource{
    
    var layoutVars:LayoutVars = LayoutVars()
    
    var itemListTableView: UITableView!
    var itemArray:NSMutableArray!
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = layoutVars.backgroundColor
        title = "Item List"
        
        
        //custom back button
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        backButton.addTarget(self, action: "goBack", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setTitle("Back", forState: UIControlState.Normal)
        backButton.titleLabel!.font =  layoutVars.buttonFont
        backButton.sizeToFit()
        var backButtonItem:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem  = backButtonItem
        
        
        
        
        
        itemArray = ["Labor","Equipment Maintenance","Repair","Winterize","Spark Plugs","Air Filter","Fuel Filter","Oil Filter"]
        
        
        
        
        
        
        self.itemListTableView =  UITableView()
        
        //segmented controller
        
        
        
        //result table
        
        //self.scheduleTableView.frame = CGRectMake(10, 106, self.view.frame.size.width - 20, self.view.frame.size.height - 106)
        self.itemListTableView.layer.cornerRadius = 4.0
        self.itemListTableView.setTranslatesAutoresizingMaskIntoConstraints(false) //allows for autolayout
        self.itemListTableView.delegate  =  self
        self.itemListTableView.dataSource  =  self
        self.itemListTableView.registerClass(ItemTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.itemListTableView)
        
        
        
        /////////  Auto Layout   //////////////////////////////////////
        
        //auto layout group
        let itemViewsDictionary = ["view1": self.itemListTableView]
        
        let metricsDictionary = ["fullWidth": self.view.frame.size.width - 20,"fullHeight":self.view.frame.size.height]
        
        println("123")
        
        //size constraint
        let itemTableConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view1(fullWidth)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: itemViewsDictionary)
        let itemTableConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view1(fullHeight)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: itemViewsDictionary)
        self.view.addConstraints(itemTableConstraint_H)
        self.view.addConstraints(itemTableConstraint_V)
        
        
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.itemArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:ItemTableViewCell = itemListTableView.dequeueReusableCellWithIdentifier("cell") as ItemTableViewCell
        
        cell.itemName.text = self.itemArray[indexPath.row] as NSString
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        //un checks all cells
        for var i=0;i<self.itemArray.count;i++
        {
            let indexP = NSIndexPath(forRow: i, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexP)
            cell?.accessoryType = .None
        }
        
        
        //checks selected cell
        var newCell = tableView.cellForRowAtIndexPath(indexPath)
        newCell?.accessoryType = .Checkmark
        
    }
    
    
    func goBack(){
        navigationController?.popViewControllerAnimated(true)
        
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