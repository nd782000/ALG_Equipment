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
    
    var infoMode:Int! = 0
    
    var infoView: UIView! = UIView()
    
    var crewLbl:GreyLabel!
    var crew:GreyLabel!
    var ctLbl:GreyLabel!
    var ct:GreyLabel!
    var notesLbl:GreyLabel!
    var notes:GreyLabel!
    
    var statusBtn:Button!
    var statusLbl:Label!
    var statusValueLbl:Label!
    var statusTxtField: PaddedTextField!
    var statusPicker :Picker!
    
    var items:[NSDictionary]!
    
    var custPhone:GreyLabel!
    var custAddr:GreyLabel!
    
    var dateInfoLabel:GreyLabel!
    
    let statusArray = ["New", "Dispatched", "In Progress", "Complete", "Cancelled"]
    
    var dateLbl:Label!
    var dateValueLbl:Label!
    var dateTxtField: PaddedTextField!
    
    let datePickerView = DatePicker()
    var dateFormatter = NSDateFormatter()
    
    var activeTextField:PaddedTextField?
    
    
    var itemsLbl:Label!
    var itemsTableView: TableView!
    
    var itemArray:[String]! = ["New Item +","Regular Maintenance","Oil Filter","Spark Plug","Air Filter","Fuel Filter","Blades","Belts","Tires"]
    
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
        self.customerBtn.titleLabel?.textAlignment = NSTextAlignment.Left
        var custIcon:UIImageView = UIImageView()
        custIcon.backgroundColor = UIColor.clearColor()
        custIcon.contentMode = .ScaleAspectFill
        custIcon.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        var custImg = UIImage(named:"custIcon.png")
        custIcon.image = custImg
        self.customerBtn.addSubview(custIcon)
        self.customerBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 10)
        self.customerBtn.addTarget(self, action: "showCustInfo", forControlEvents: UIControlEvents.TouchUpInside)
        self.dateBtn = Button(titleText: "10/11/15")
        var dateIcon:UIImageView = UIImageView()
        dateIcon.backgroundColor = UIColor.clearColor()
        dateIcon.contentMode = .ScaleAspectFill
        dateIcon.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        var dateImg = UIImage(named:"calIcon.png")
        dateIcon.image = dateImg
        self.dateBtn.addSubview(dateIcon)
        self.dateBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 10)
        self.dateBtn.addTarget(self, action: "showDateInfo", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(customerBtn)
        self.view.addSubview(dateBtn)
        
        // Info Window
        
        self.infoView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.infoView.backgroundColor = UIColor(hex:0xFFFFFF, op: 0.8)
        self.infoView.layer.cornerRadius = 4
        
        self.crewLbl = GreyLabel()
        self.crewLbl.text = "Crew:"
        self.crewLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.crew = GreyLabel()
        self.crew.text = "SHP"
        self.crew.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.ctLbl = GreyLabel()
        self.ctLbl.text = "Charge Type:"
        self.ctLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.ct = GreyLabel()
        self.ct.text = "FC"
        self.ct.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.notesLbl = GreyLabel()
        self.notesLbl.text = "Notes:"
        self.notesLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.notes = GreyLabel()
        self.notes.text = "Some notes"
        self.notes.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        self.notes.numberOfLines = 3
        self.notes.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.custPhone = GreyLabel(icon: true)
        self.custPhone.text = "(401) 239 6337"
        var phoneIcon:UIImageView = UIImageView()
        phoneIcon.backgroundColor = UIColor.clearColor()
        phoneIcon.contentMode = .ScaleAspectFill
        phoneIcon.frame = CGRect(x: 0, y: 1, width: 20, height: 20)
        var phoneImg = UIImage(named:"phoneIcon.png")
        phoneIcon.image = phoneImg
        custPhone.addSubview(phoneIcon)
        
        self.custAddr = GreyLabel(icon: true)
        self.custAddr.text = "129 Narragansett Ave, Jamestown, RI, 02840"
        self.custAddr.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        self.custAddr.numberOfLines = 0
        var mapIcon:UIImageView = UIImageView()
        mapIcon.backgroundColor = UIColor.clearColor()
        mapIcon.contentMode = .ScaleAspectFill
        mapIcon.frame = CGRect(x: 0, y: 1, width: 20, height: 20)
        var mapImg = UIImage(named:"mapIcon.png")
        mapIcon.image = mapImg
        custAddr.addSubview(mapIcon)
        
        self.dateInfoLabel = GreyLabel(icon: true)
        self.dateInfoLabel.text = "Not sure what would be here yet"
        self.dateInfoLabel.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        self.dateInfoLabel.numberOfLines = 0
        var dateInfoIcon:UIImageView = UIImageView()
        dateInfoIcon.backgroundColor = UIColor.clearColor()
        dateInfoIcon.contentMode = .ScaleAspectFill
        dateInfoIcon.frame = CGRect(x: 0, y: 1, width: 20, height: 20)
        var dateInfoImg = UIImage(named:"phoneIcon.png")
        dateInfoIcon.image = dateInfoImg
        dateInfoLabel.addSubview(dateInfoIcon)
        
        self.infoView.addSubview(crewLbl)
        self.infoView.addSubview(crew)
        self.infoView.addSubview(ctLbl)
        self.infoView.addSubview(ct)
        self.infoView.addSubview(notesLbl)
        self.infoView.addSubview(notes)
        
        self.statusBtn = Button(titleText: "In Progress")
        self.statusBtn.backgroundColor = UIColor(hex:0xE09E43, op:1)
        var inProgIcon:UIImageView = UIImageView()
        inProgIcon.backgroundColor = UIColor.clearColor()
        inProgIcon.contentMode = .ScaleAspectFill
        inProgIcon.frame = CGRect(x: (layoutVars.fullWidth/2)-84, y: 10, width: 20, height: 20)
        var inProgImg = UIImage(named:"clockIcon.png")
        inProgIcon.image = inProgImg
        self.statusBtn.addSubview(inProgIcon)
        self.view.addSubview(statusBtn)
        
        //just a temp hook up to usage view controller
        self.statusBtn.addTarget(self, action: "showUsageVC", forControlEvents: UIControlEvents.TouchUpInside)
        
        var tableHead:UIView! = UIView()
        var statusTH: THead = THead(text: "Sts.")
        var nameTH: THead = THead(text: "Name")
        var estTH: THead = THead(text: "Est.")
        var actTH: THead = THead(text: "Act.")
        
        tableHead.backgroundColor = layoutVars.buttonTint
        tableHead.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableHead.addSubview(statusTH)
        tableHead.addSubview(nameTH)
        tableHead.addSubview(estTH)
        tableHead.addSubview(actTH)
        
        self.view.addSubview(tableHead)
        
        self.itemsTableView  =   TableView()
        self.itemsTableView.autoresizesSubviews = true
        self.itemsTableView.delegate  =  self
        self.itemsTableView.dataSource  =  self
        self.itemsTableView.layer.cornerRadius = 0
        self.itemsTableView.registerClass(ItemCell.self, forCellReuseIdentifier: "cell")
        //self.itemsTableView.tableHeaderView = tableHead
        self.view.addSubview(self.itemsTableView)
        
        self.view.addSubview(infoView)
        
        //status
        
        self.statusLbl = Label(text: "Work Order Status")
        self.statusValueLbl = Label(text:"Status Value")
        self.infoView.addSubview(statusLbl)
        
        //date
        
        self.dateLbl = Label(text: "Work Order Date")
        
        self.dateValueLbl = Label(text: "Date Value")
        
        //items
        
        self.itemsLbl = Label(text: "Work Order Items")
        
        
        
        
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
        let metricsDictionary = ["fullWidth": layoutVars.fullWidth - 30, "nameWidth": layoutVars.fullWidth - 150]
        
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
        
        //main views
        let viewsDictionary = [
            "customerBtn":self.customerBtn,
            "dateBtn":self.dateBtn,
            "info":self.infoView,
            "th":tableHead,
            "table":self.itemsTableView,
            "status":self.statusBtn
        ]
        
        //size constraints
        let btnConstraint_H:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[customerBtn]-15-[dateBtn]-15-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let infoViewConstraint_H:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[info]-15-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let tableConstraint_H:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[table]-15-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let thvConstraint_H:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[th]-15-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let statusConstraint_H:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[status]-15-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let pageConstraint_V1:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-79-[customerBtn(40)]-15-[info]-15-[th][table]-15-[status(40)]-15-|", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let pageConstraint_V2:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-79-[dateBtn(40)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        
        self.view.addConstraints(btnConstraint_H)
        self.view.addConstraints(infoViewConstraint_H)
        self.view.addConstraints(tableConstraint_H)
        self.view.addConstraints(thvConstraint_H)
        self.view.addConstraints(statusConstraint_H)
        self.view.addConstraints(pageConstraint_V1)
        self.view.addConstraints(pageConstraint_V2)
        
        
        // Tablehead
        let thDictionary = [
            "sts":statusTH,
            "name":nameTH,
            "est":estTH,
            "act":actTH
        ]
        let thConstraint_H:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[sts(35)]-5-[name]-5-[est(40)]-5-[act(40)]-0-|", options: nil, metrics: metricsDictionary, views: thDictionary)
        let thConstraint_V1:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-3-[sts(20)]-3-|", options: nil, metrics: metricsDictionary, views: thDictionary)
        let thConstraint_V2:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-3-[name(20)]-3-|", options: nil, metrics: metricsDictionary, views: thDictionary)
        let thConstraint_V3:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-3-[est(20)]-3-|", options: nil, metrics: metricsDictionary, views: thDictionary)
        let thConstraint_V4:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-3-[act(20)]-3-|", options: nil, metrics: metricsDictionary, views: thDictionary)
        tableHead.addConstraints(thConstraint_H)
        tableHead.addConstraints(thConstraint_V1)
        tableHead.addConstraints(thConstraint_V2)
        tableHead.addConstraints(thConstraint_V3)
        tableHead.addConstraints(thConstraint_V4)
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
    
    func showCustInfo() {
        println("SHOW CUST INFO")
        if(self.infoMode != 1) {
            for view in self.infoView.subviews {
                view.removeFromSuperview()
            }
            self.infoView.addSubview(self.custPhone)
            self.infoView.addSubview(self.custAddr)
            
            //auto layout group
            let infoDictionary = [
                "phone": self.custPhone,
                "addr": self.custAddr
            ]
            let metricsDictionary = ["fullWidth": layoutVars.fullWidth - 30, "nameWidth": layoutVars.fullWidth - 150]
            self.dateBtn.backgroundColor = layoutVars.buttonTint
            self.customerBtn.backgroundColor = layoutVars.buttonActive
            self.infoMode = 1
            
            let infoConstraint_CH:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[phone]-10-|", options: nil, metrics: metricsDictionary, views: infoDictionary)
            let infoConstraint_CH1:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[addr]-10-|", options: nil, metrics: metricsDictionary, views: infoDictionary)
            let infoConstraint_CV:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[phone]-10-[addr]-10-|", options: nil, metrics: metricsDictionary, views: infoDictionary)
            
            self.infoView.addConstraints(infoConstraint_CH)
            self.infoView.addConstraints(infoConstraint_CH1)
            self.infoView.addConstraints(infoConstraint_CV)
        } else {
            for view in self.infoView.subviews {
                view.removeFromSuperview()
            }
            self.infoView.addSubview(crewLbl)
            self.infoView.addSubview(crew)
            self.infoView.addSubview(ctLbl)
            self.infoView.addSubview(ct)
            self.infoView.addSubview(notesLbl)
            self.infoView.addSubview(notes)
            //auto layout group
            let infoDictionary = [
                "crewLbl":self.crewLbl,
                "crew":self.crew,
                "ctLbl":self.ctLbl,
                "ct":self.ct,
                "notesLbl":self.notesLbl,
                "notes":self.notes
            ]
            let metricsDictionary = ["fullWidth": layoutVars.fullWidth - 30, "nameWidth": layoutVars.fullWidth - 150]
            
            //size constraint
            let infoConstraint_H:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[crewLbl(60)][crew]-15-[ctLbl(115)][ct]-10-|", options: nil, metrics: metricsDictionary, views: infoDictionary)
            let infoConstraint_H2:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[notesLbl(60)][notes]-10-|", options: nil, metrics: metricsDictionary, views: infoDictionary)
            let infoConstraint_V:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[crewLbl]-10-[notesLbl]-10-|", options: nil, metrics: metricsDictionary, views: infoDictionary)
            let infoConstraint_V1:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[crew]-10-[notes]-10-|", options: nil, metrics: metricsDictionary, views: infoDictionary)
            let infoConstraint_V2:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[ctLbl]-10-[notesLbl]-10-|", options: nil, metrics: metricsDictionary, views: infoDictionary)
            let infoConstraint_V3:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[ct]-10-[notes]-10-|", options: nil, metrics: metricsDictionary, views: infoDictionary)
            
            self.customerBtn.backgroundColor = layoutVars.buttonTint
            self.infoMode = 0
            
            self.infoView.addConstraints(infoConstraint_H)
            self.infoView.addConstraints(infoConstraint_H2)
            self.infoView.addConstraints(infoConstraint_V)
            self.infoView.addConstraints(infoConstraint_V1)
            self.infoView.addConstraints(infoConstraint_V2)
            self.infoView.addConstraints(infoConstraint_V3)
        }
        
    }
    
    func showDateInfo() {
        println("SHOW DATE INFO")
        if(self.infoMode != 2) {
            for view in self.infoView.subviews {
                view.removeFromSuperview()
            }
            self.infoView.addSubview(self.dateInfoLabel)
            
            //auto layout group
            let infoDictionary = [
                "date": self.dateInfoLabel
            ]
            let metricsDictionary = ["fullWidth": layoutVars.fullWidth - 30, "nameWidth": layoutVars.fullWidth - 150]
            
            self.customerBtn.backgroundColor = layoutVars.buttonTint
            self.dateBtn.backgroundColor = layoutVars.buttonActive
            self.infoMode = 2
            
            let infoConstraint_CH:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[date]-10-|", options: nil, metrics: metricsDictionary, views: infoDictionary)
            let infoConstraint_CV:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[date]-10-|", options: nil, metrics: metricsDictionary, views: infoDictionary)
            
            self.infoView.addConstraints(infoConstraint_CH)
            self.infoView.addConstraints(infoConstraint_CV)
        } else {
            for view in self.infoView.subviews {
                view.removeFromSuperview()
            }
            self.infoView.addSubview(crewLbl)
            self.infoView.addSubview(crew)
            self.infoView.addSubview(ctLbl)
            self.infoView.addSubview(ct)
            self.infoView.addSubview(notesLbl)
            self.infoView.addSubview(notes)
            //auto layout group
            let infoDictionary = [
                "crewLbl":self.crewLbl,
                "crew":self.crew,
                "ctLbl":self.ctLbl,
                "ct":self.ct,
                "notesLbl":self.notesLbl,
                "notes":self.notes
            ]
            let metricsDictionary = ["fullWidth": layoutVars.fullWidth - 30, "nameWidth": layoutVars.fullWidth - 150]
            
            //size constraint
            let infoConstraint_H:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[crewLbl(60)][crew]-15-[ctLbl(115)][ct]-10-|", options: nil, metrics: metricsDictionary, views: infoDictionary)
            let infoConstraint_H2:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[notesLbl(60)][notes]-10-|", options: nil, metrics: metricsDictionary, views: infoDictionary)
            let infoConstraint_V:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[crewLbl]-10-[notesLbl]-10-|", options: nil, metrics: metricsDictionary, views: infoDictionary)
            let infoConstraint_V1:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[crew]-10-[notes]-10-|", options: nil, metrics: metricsDictionary, views: infoDictionary)
            let infoConstraint_V2:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[ctLbl]-10-[notesLbl]-10-|", options: nil, metrics: metricsDictionary, views: infoDictionary)
            let infoConstraint_V3:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[ct]-10-[notes]-10-|", options: nil, metrics: metricsDictionary, views: infoDictionary)
            
            self.dateBtn.backgroundColor = layoutVars.buttonTint
            self.infoMode = 0
            
            self.infoView.addConstraints(infoConstraint_H)
            self.infoView.addConstraints(infoConstraint_H2)
            self.infoView.addConstraints(infoConstraint_V)
            self.infoView.addConstraints(infoConstraint_V1)
            self.infoView.addConstraints(infoConstraint_V2)
            self.infoView.addConstraints(infoConstraint_V3)
        }
        
    }
    
    
    
    
    func showUsageVC() {
        let usageViewController = UsageEntryViewController()
        navigationController?.pushViewController(usageViewController, animated: true )
 
        
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
        
        if(indexPath.row == 0) {
            var cell:UITableViewCell = itemsTableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
            cell.textLabel?.text = "New Item"
            return cell;
        } else {
            let id = "1"
            let status = indexPath.row
            let name = itemArray[indexPath.row]
            let est = "24"
            let act = "12"
            
            var cell:ItemCell = itemsTableView.dequeueReusableCellWithIdentifier("cell") as! ItemCell
            
            cell.id = id
            cell.setStatus(status)
            cell.nameLbl.text = name
            cell.estLbl.text = est
            cell.actLbl.text = act
            return cell;
        }
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(" cell Selected")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.row == 0){
            self.newItem()
        }else{
            var item = items[indexPath.row]
        
        }
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        
        var selCell:NSIndexPath! = indexPath
        
        if(indexPath.row != 0) {
        
            var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Remove" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                let shareMenu = UIAlertController(title: nil, message: "Are you sure you want to remove this item?", preferredStyle: .ActionSheet)

                let removeAction = UIAlertAction(title: "Remove", style: UIAlertActionStyle.Destructive) { action -> Void in
                    self.itemArray.removeAtIndex(selCell.row)
                    self.itemsTableView.deleteRowsAtIndexPaths([selCell], withRowAnimation: UITableViewRowAnimation.Left)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
                
                shareMenu.addAction(removeAction)
                shareMenu.addAction(cancelAction)
                
                self.presentViewController(shareMenu, animated: true, completion: nil)
            })
            
            return [shareAction]
        
        } else {
            var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "New" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                self.newItem()
            })
            
            return [shareAction]
        }
        
    }
    
    func newItem() {
        println("NEW ITEM")
        let itemViewController:NewItemViewController! = NewItemViewController()
        navigationController?.pushViewController(itemViewController, animated: true )
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









