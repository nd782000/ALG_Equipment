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

class NewItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var layoutVars:LayoutVars = LayoutVars()
    var items:TableView = TableView()
    var itemArray:[String]! = []
    var itemDetails:[NSDictionary]! = []
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(){
        super.init(nibName:nil,bundle:nil)
        self.view.backgroundColor = layoutVars.backgroundColor
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
        
        Alamofire.request(.POST, "http://atlanticlawnandgarden.com/cp/app/items.php")
            .responseJSON { (request, response, data, error) in
                let allData: NSDictionary! = data as! NSDictionary!
                if let itemData: NSArray! = allData["items"] as! NSArray! {
                    for thisItem in itemData {
                        self.addItem(thisItem as! NSDictionary)
                    }
                    self.items.reloadData()
                } else {
                    println("FAIL \(allData)")
                }
        }
        
        items.delegate = self
        items.dataSource = self
        items.registerClass(Cell.self, forCellReuseIdentifier: "cell")
        items.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        self.view.addSubview(items)
        var label:H1Label = H1Label(text: "Select Item")
        self.view.addSubview(label)
        let layoutDictionary = [
            "table":self.items,
            "label":label
        ]
        
        let tableConstraint_H:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[table]-15-|", options: nil, metrics: nil, views: layoutDictionary)
        let labelConstraint_H:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[label]-15-|", options: nil, metrics: nil, views: layoutDictionary)
        let viewsConstraint_V:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-75-[label(40)]-5-[table]-15-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: layoutDictionary)
        
        self.view.addConstraints(tableConstraint_H)
        self.view.addConstraints(labelConstraint_H)
        self.view.addConstraints(viewsConstraint_V)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return itemArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:Cell = items.dequeueReusableCellWithIdentifier("cell") as! Cell
        
        cell.textLabel?.text = itemArray[indexPath.row] as String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //println(" cell Selected #\(indexPath.row)! %@ ",dataArray[indexPath.row] as NSString)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var item:NSDictionary! = itemDetails[indexPath.row]
        let itemViewController = ItemViewController(item: item)
        navigationController?.pushViewController(itemViewController, animated: true )
    }

    
    func addItem(item:NSDictionary) {
        var name = item["name"] as! String!
        println("ITEM: \(item)")
        itemDetails.append(item)
        println("ADD ITEM:\(name)")
        itemArray.append(name)
    }
    
    func goBack(){
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}