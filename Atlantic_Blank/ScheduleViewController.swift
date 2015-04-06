//
//  ScheduleViewController.swift
//  Atlantic_Blank
//
//  Created by Nicholas Digiando on 4/6/15.
//  Copyright (c) 2015 Nicholas Digiando. All rights reserved.
//

import Foundation
import UIKit


class ScheduleViewController: ViewController, UITableViewDelegate, UITableViewDataSource{
    
    var layoutVars:LayoutVars = LayoutVars()
    
    var scheduleTableView: UITableView!
    var itemArray:NSMutableArray!
    var scheduleArray:NSMutableArray!
    var historyArray:NSMutableArray!
    var history:Bool!
    
    
    
    var customerLbl:UILabel = UILabel()
    
    //var delegate:MenuDelegate!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = layoutVars.backgroundColor
        title = "Schedule"
        
       self.history = false
        
        scheduleArray = ["WorkOrder1","WorkOrder2","WorkOrder3","WorkOrder4","WorkOrder5","WorkOrder6","WorkOrder7"]
        historyArray = ["WorkOrder8","WorkOrder9","WorkOrder10","WorkOrder11","WorkOrder12","WorkOrder13","WorkOrder14","WorkOrder15","WorkOrder16","WorkOrder17"]
        itemArray = scheduleArray
        let items = ["Schedule", "History"]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        // Set up Frame and SegmentedControl
        let frame = UIScreen.mainScreen().bounds
        customSC.frame = CGRectMake(frame.minX + 10, frame.minY + 66,
            frame.width - 20, 40)
        customSC.layer.cornerRadius = 5.0  // Don't let background bleed
        customSC.backgroundColor = UIColor.blackColor()
        customSC.tintColor = UIColor.whiteColor()
        customSC.addTarget(self, action: "changeSearchOptions:", forControlEvents: .ValueChanged)
        self.view.addSubview(customSC)
        
        
        
        
        var tableX = (self.view.frame.size.width - 300)/2;
        //search bar
        
        
       // let ds = MyData()
        //table.dataSource = ds
        
        self.scheduleTableView =  UITableView()
        
        //segmented controller
        
        
        
        //result table
        
        self.scheduleTableView.frame = CGRectMake(10, 106, self.view.frame.size.width - 20, self.view.frame.size.height - 106)
        self.scheduleTableView.layer.cornerRadius = 4.0
        //equipmentListTableView.setTranslatesAutoresizingMaskIntoConstraints(false) //allows for autolayout
        self.scheduleTableView.delegate  =  self
        self.scheduleTableView.dataSource  =  self
        self.scheduleTableView.registerClass(ScheduleTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.scheduleTableView)
        

    }
    
    func changeSearchOptions(sender: UISegmentedControl) {
        println("changeSearchOptions")
        switch sender.selectedSegmentIndex {
        case 1:
            self.itemArray = self.scheduleArray
            self.history = false
            self.scheduleTableView.reloadData()
        case 2:
            self.history = true
             self.itemArray = self.historyArray
            self.scheduleTableView.reloadData()
        default:
            self.scheduleTableView.reloadData()
          
        }
    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //if self.history == true{
            //return self.historyArray.count  //Currently Giving default Value
           // itemArray = scheduleArray
        //}else{
             //return self.scheduleArray.count
            //itemArray = historyArray
       // }
       return self.itemArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        
        var cell:ScheduleTableViewCell = scheduleTableView.dequeueReusableCellWithIdentifier("cell") as ScheduleTableViewCell
       // if is_searching == true{
           // cell.equipName.text = searchingDataArray[indexPath.row] as NSString
           // cell.equipDescription.text = "\(indexPath.row)"
       // }else{
            // if self.history == true{
                cell.equipName.text = self.itemArray[indexPath.row] as NSString
                cell.equipDescription.text = "\(indexPath.row)"
            // }else{
               // cell.equipName.text = self.scheduleArray[indexPath.row] as NSString
                //cell.equipDescription.text = "\(indexPath.row)"
        //}
        
        //}
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //displayEquipment()
        
        let workOrderViewController = WorkOrderViewController()
        navigationController?.pushViewController(workOrderViewController, animated: true )
        
        
        
    }
    
    

    
    
    
    
    
    
    
    func displayItem() {
        println("Yo")
        //let itemViewController = ItemViewController()
        //navigationController?.pushViewController(itemViewController, animated: true )
        
        let newMaintenanceItemViewController = NewMaintenanceItemViewController()
        navigationController?.pushViewController(newMaintenanceItemViewController, animated: true )
        

        
        
    }
    
    func goBack(){
        navigationController?.popViewControllerAnimated(true)
        
    }

    func setLabel(lblText:String) {
        customerLbl.text = lblText
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