//
//  NewEquipmentViewController.swift
//  Atlantic_Blank
//
//  Created by Nicholas Digiando on 4/6/15.
//  Copyright (c) 2015 Nicholas Digiando. All rights reserved.
//


import Foundation
import UIKit
import Alamofire


class NewEquipmentViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIPickerViewDelegate, UITextFieldDelegate,  UIScrollViewDelegate {
    
    var test = 1;
    
    var scrollView: UIScrollView!
    var tapBtn:UIButton!
    var loadingView:UIView!
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    var layoutVars:LayoutVars = LayoutVars()
    var typeValue:String!
    var typeCode:String!
    var typeID:Int!
    var typePicker: Picker!
    var typeTxtField: PaddedTextField!
    var nameTxtField: PaddedTextField!
    var nameValue: String!
    var makeTxtField: PaddedTextField!
    var modelTxtField: PaddedTextField!
    var serialTxtField: PaddedTextField!
    var dealerTxtField: PaddedTextField!
    var mileageTxtField: PaddedTextField!
    var engineTxtField: PaddedTextField!
    var fuelTxtField: PaddedTextField!
    var purchasedTxtField: PaddedTextField!
    var statusTxtField: PaddedTextField!
    var statusValue: Int!
    var statusPicker: Picker!
    var crewValue:Int!
    var crewPicker :Picker!
    var crewTxtField: PaddedTextField!
    var imgHasChanged: Bool! = false
    var backButton: UIButton!
    var defaultImage : UIImage = UIImage(named:"blank.png")!
    var activeTextField:PaddedTextField?

    
    var imageView:UIImageView!
    var progressView:UIProgressView!
    var progressValue:Float!
    var progressLbl:Label!
    
    let datePickerView = DatePicker()
    var dateFormatter = NSDateFormatter()
    
    var submitEquipmentButton:Button!
    
    let picker = UIImagePickerController()
    
    
    var eTypes:[String] = ["-- None Selected --"]
    var eTypeIDs:[Int] = [0]
    var eTypeCodes:[String] = ["00"]
    var nextNames:[String] = [""]
    var crewIDs:[Int] = [0]
    var crew:[String] = ["-- None Selected --"]
    var statusIDs:[Int] = [0,1,2,3,4]
    var statuses:[String] = ["-- None Selected --", "Online", "Out of Service", "Needs Repairing", "Winterized"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.typeID = 0 as Int
        self.crewValue = 0 as Int
        self.statusValue = 0 as Int
        
        self.loadingView = UIView(frame: CGRect(x: 0, y: 0, width: self.screenSize.width, height: self.screenSize.height))
        
        
        Alamofire.request(.POST, "http://atlanticlawnandgarden.com/cp/app/equipmentPickers.php")
            .responseJSON { (request, response, data, error) in
                let allData: NSDictionary! = data as! NSDictionary!
                if let typeData: NSArray! = allData["types"] as! NSArray! {
                    for thisType in typeData {
                        self.addType(thisType as! NSDictionary)
                    }
                } else {
                    println("FAIL \(allData)")
                }
                
                self.typePicker.reloadAllComponents()
                
                if let crewData: NSArray! = allData["crews"] as! NSArray! {
                    for thisCrew in crewData {
                        self.addCrew(thisCrew as! NSDictionary)
                    }
                } else {
                    println("FAIL \(allData)")
                }
                
                self.crewPicker.reloadAllComponents()
        }
        
        
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
    
        self.tapBtn = UIButton()
        self.tapBtn.frame = CGRectMake(0, 0, screenSize.width, 1000)
        self.tapBtn.backgroundColor = UIColor.clearColor()
        self.tapBtn.addTarget(self, action: "DismissKeyboard", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.scrollView.addSubview(self.tapBtn)
        
        // Do any additional setup after loading the view.
        view.backgroundColor = layoutVars.backgroundColor
        title = "New Equipment"
        
        
        //custom back button
        backButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.addTarget(self, action: "goBack", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setTitle("Back", forState: UIControlState.Normal)
        backButton.titleLabel!.font =  layoutVars.buttonFont
        backButton.sizeToFit()
        var backButtonItem:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem  = backButtonItem
        
        
        //var cameraButton = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "displayPickerOptions")
        //navigationItem.rightBarButtonItem = cameraButton
        self.picker.delegate = self
        
        self.typePicker = Picker()
        self.typePicker.delegate = self
        self.typeTxtField = PaddedTextField(placeholder: "Type")
        self.typeTxtField.tag = 1
        self.typeTxtField.delegate = self
        self.typeTxtField.inputView = typePicker
        self.scrollView.addSubview(self.typeTxtField)
        

        self.scrollView.addSubview(self.typeTxtField)
        
        self.nameTxtField = PaddedTextField(placeholder: "Name")
        self.nameTxtField.tag = 2
        self.nameTxtField.delegate = self
        self.scrollView.addSubview(self.nameTxtField)
        
        self.makeTxtField = PaddedTextField(placeholder: "Make")
        self.makeTxtField.tag = 3
        self.makeTxtField.delegate = self
        self.scrollView.addSubview(self.makeTxtField)
        
        self.modelTxtField = PaddedTextField(placeholder: "Model")
        self.modelTxtField.tag = 4
        self.modelTxtField.delegate = self
        self.scrollView.addSubview(self.modelTxtField)
        
        self.serialTxtField = PaddedTextField(placeholder: "Serial")
        self.serialTxtField.tag = 5
        self.serialTxtField.delegate = self
        self.scrollView.addSubview(self.serialTxtField)
        
        
        self.dealerTxtField = PaddedTextField(placeholder: "Dealer")
        self.dealerTxtField.tag = 6
        self.dealerTxtField.delegate = self
        self.scrollView.addSubview(self.dealerTxtField)
        

        self.mileageTxtField = PaddedTextField(placeholder: "Milage")
        self.mileageTxtField.tag = 7
        self.mileageTxtField.delegate = self
        self.mileageTxtField.keyboardType = UIKeyboardType.NumberPad
        self.scrollView.addSubview(self.mileageTxtField)
        
        self.engineTxtField = PaddedTextField(placeholder: "Engine Type")
        self.engineTxtField.tag = 8
        self.engineTxtField.delegate = self
        self.scrollView.addSubview(self.engineTxtField)
        
        self.fuelTxtField = PaddedTextField(placeholder: "Fuel Type")
        self.fuelTxtField.tag = 9
        self.fuelTxtField.delegate = self
        self.scrollView.addSubview(self.fuelTxtField)


        
        datePickerView.addTarget( self, action: "handleDatePicker", forControlEvents: UIControlEvents.ValueChanged )
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.maximumDate = NSDate.new()
        
        //usDateFormat now contains an optional string "MM/dd/yyyy".
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        self.purchasedTxtField = PaddedTextField(placeholder: "Purchased Date")
        self.purchasedTxtField.tag = 10
        self.purchasedTxtField.delegate = self
        self.purchasedTxtField.inputView = self.datePickerView
        self.scrollView.addSubview(self.purchasedTxtField)
        
        
        self.crewPicker = Picker()
        self.crewPicker.delegate = self
        self.crewTxtField = PaddedTextField(placeholder: "Crew / Employee")
        self.crewTxtField.tag = 11
        self.crewTxtField.delegate = self
        self.crewTxtField.inputView = crewPicker
        self.scrollView.addSubview(self.crewTxtField)
        
        
        
        self.imageView = UIImageView()
        self.imageView.backgroundColor = layoutVars.backgroundLight
        self.imageView.layer.borderWidth = 2
        self.imageView.layer.borderColor = layoutVars.borderColor
        self.imageView.contentMode = .ScaleAspectFill
        let tapGesture = UITapGestureRecognizer(target: self, action: "displayPickerOptions:")
        self.imageView.addGestureRecognizer(tapGesture)
        self.imageView.userInteractionEnabled = true
        
        self.imageView.image = self.defaultImage
        self.imageView.clipsToBounds = true
        
        self.imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.scrollView.addSubview(self.imageView)
        
        
        self.statusPicker = Picker()
        self.statusPicker.delegate = self
        self.statusTxtField = PaddedTextField(placeholder: "Status")
        self.statusTxtField.tag = 11
        self.statusTxtField.delegate = self
        self.statusTxtField.inputView = statusPicker
        self.scrollView.addSubview(self.statusTxtField)
        
        self.progressView = UIProgressView()
        self.progressView.tintColor = UIColor.blueColor()
        self.progressView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.loadingView.addSubview(self.progressView)
        
        self.progressLbl = Label(text: "Uploading...", valueMode: false)
        self.progressLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.progressLbl.textAlignment = NSTextAlignment.Center
        self.loadingView.addSubview(self.progressLbl)
        
        self.submitEquipmentButton = Button(titleText: "Submit")
        self.submitEquipmentButton.addTarget(self, action: "saveData", forControlEvents: UIControlEvents.TouchUpInside)
        self.scrollView.addSubview(self.submitEquipmentButton)
        
        
        
        
        /////////////////  Auto Layout   ////////////////////////////////////////////////
        
        //apply to each view
        //itemsTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        //auto layout group
        let viewsDictionary = [
            "type":self.typeTxtField,
            "name":self.nameTxtField,
            "make":self.makeTxtField,
            "model":self.modelTxtField,
            "serial":self.serialTxtField,
            "dealer":self.dealerTxtField,
            "mileage":self.mileageTxtField,
            "engine":self.engineTxtField,
            "fuel":self.fuelTxtField,
            "purchased":self.purchasedTxtField,
            "crew":self.crewTxtField,
            "status":self.statusTxtField,
            "image":self.imageView,
            "submit":self.submitEquipmentButton
        ]

        
        let sizeVals = ["width": self.view.frame.size.width - 30,"height": 40]
        
        //////////////   auto layout position constraints   /////////////////////////////
        
        let viewsConstraint_H1:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[type(width)]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H2:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[name]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H3:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[make]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H4:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[model]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H5:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[serial]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H6:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[dealer]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H7:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[mileage]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H8:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[engine]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H9:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[fuel]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H10:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[purchased]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H11:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[crew]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H12:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[image]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H13:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[status]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H14:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[submit]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_V:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[type(height)]-15-[name(height)]-15-[make(height)]-15-[model(height)]-15-[serial(height)]-15-[dealer(height)]-15-[mileage(height)]-15-[engine(height)]-15-[fuel(height)]-15-[purchased(height)]-15-[crew(height)]-15-[status(height)]-15-[image(width)]-15-[submit(height)]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        
        self.scrollView.addConstraints(viewsConstraint_H1)
        self.scrollView.addConstraints(viewsConstraint_H2)
        self.scrollView.addConstraints(viewsConstraint_H3)
        self.scrollView.addConstraints(viewsConstraint_H4)
        self.scrollView.addConstraints(viewsConstraint_H5)
        self.scrollView.addConstraints(viewsConstraint_H6)
        self.scrollView.addConstraints(viewsConstraint_H7)
        self.scrollView.addConstraints(viewsConstraint_H8)
        self.scrollView.addConstraints(viewsConstraint_H9)
        self.scrollView.addConstraints(viewsConstraint_H10)
        self.scrollView.addConstraints(viewsConstraint_H11)
        self.scrollView.addConstraints(viewsConstraint_H12)
        self.scrollView.addConstraints(viewsConstraint_H13)
        self.scrollView.addConstraints(viewsConstraint_H14)
        self.scrollView.addConstraints(viewsConstraint_V)
        
        
        let progressDictionary = [
            "bar":self.progressView,
            "label":self.progressLbl
        ]


        let progConstraint_H1:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[bar]-15-|", options: nil, metrics: sizeVals, views: progressDictionary)
        let progConstraint_H2:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[label]-15-|", options: nil, metrics: sizeVals, views: progressDictionary)

        let progConstraint_V:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-100-[label(height)]-4-[bar(4)]", options: nil, metrics: sizeVals, views: progressDictionary)
        
        self.loadingView.addConstraints(progConstraint_H1)
        self.loadingView.addConstraints(progConstraint_H2)
        
        self.loadingView.addConstraints(progConstraint_V)
        
        
        self.loadingView.backgroundColor = UIColor.whiteColor()
        self.loadingView.alpha = 0
        self.view.addSubview(loadingView)
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scrollView.frame = view.bounds
        // self.containerView.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height)
    }
    
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        if (pickerView == typePicker) {
            // Do something
            return self.eTypes.count
        }else if (pickerView == crewPicker){
            return self.crew.count
        } else {
            return self.statuses.count
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if (pickerView == typePicker) {
            // Do something
            return self.eTypes[row]
        }else if (pickerView == crewPicker){
            return self.crew[row]
        } else {
            return self.statuses[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // typeTxtField.text = "\(self.type[row])"
        // selected value in Uipickerview in Swift
        
        if (pickerView == typePicker) {
            self.typeValue = self.eTypes[row]
            self.typeID = self.eTypeIDs[row]
            self.typeCode = self.eTypeCodes[row]
            self.typeTxtField.text=self.eTypes[row]
            self.nameTxtField.text=self.nextNames[row]
            println("type ID: \(self.typeValue)")
            println("type: \(self.typeID)")
            println("type code: \(self.typeCode)")
        } else if (pickerView == crewPicker) {
            self.crewValue=self.crewIDs[row]
            self.crewTxtField.text=self.crew[row]
            println("crew ID: \(self.crewValue)")
            println("crew: \(self.crew[row])")
        } else {
            self.statusValue = self.statusIDs[row]
            self.statusTxtField.text=self.statuses[row]
            println("status ID: \(self.statusValue)")
            println("status: \(self.statuses[row])")
        }
    
    }
    
    func showCamera() {
        println("TEST")
    }
    
    
    func handleDatePicker()
    {
        println("PURCHASE DATE: \(dateFormatter.stringFromDate(datePickerView.date))")
        self.purchasedTxtField.text =  dateFormatter.stringFromDate(datePickerView.date)
    }
    
    
    
    //Action Sheet Delegate
    func actionSheet(sheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        println("index %d %@", buttonIndex, sheet.buttonTitleAtIndex(buttonIndex));
        
        
        switch (buttonIndex) {
        case 1:
            println("camera")
            if UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
            {
                picker.sourceType = UIImagePickerControllerSourceType.Camera
                picker.cameraCaptureMode = .Photo
                picker.allowsEditing = true
                picker.delegate = self
                [self .presentViewController(picker, animated: true , completion: nil)]
            }
            break;
        case 2:
            println("library")
            if UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
            {
                picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                picker.allowsEditing = true
                picker.delegate = self
                [self .presentViewController(picker, animated: true , completion: nil)]
            }
            break;
            
            
        default:
            break;
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        println("PLEASE SCROLL")
        let offset = (textField.frame.origin.y - 79)
        var scrollPoint : CGPoint = CGPointMake(0, offset)
        self.scrollView.setContentOffset(scrollPoint, animated: true)
        self.activeTextField = textField as? PaddedTextField
        textField.textColor = UIColor(hex:0x333333, op: 1)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        println("HELLLOOOOO")
        self.scrollView.setContentOffset(CGPointZero, animated: true)
        if(count(textField.text) > 0) {
            UIView.animateWithDuration(0.75, animations: {() -> Void in
                textField.backgroundColor = UIColor(hex:0xEDFFF7, op: 0.75)
                textField.layer.borderColor = UIColor(hex:0x005100, op: 0.6).CGColor
            })
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        println("NEXT")
        switch (textField.tag) {
            case nameTxtField.tag:
                makeTxtField.becomeFirstResponder()
                break;
            case makeTxtField.tag:
                modelTxtField.becomeFirstResponder()
                break;
            case modelTxtField.tag:
                serialTxtField.becomeFirstResponder()
                break;
            case serialTxtField.tag:
                dealerTxtField.becomeFirstResponder()
                break;
            case dealerTxtField.tag:
                mileageTxtField.becomeFirstResponder()
                break;
            case engineTxtField.tag:
                fuelTxtField.becomeFirstResponder()
                break;
            case fuelTxtField.tag:
                purchasedTxtField.becomeFirstResponder()
                break;
            case purchasedTxtField.tag:
                crewTxtField.becomeFirstResponder()
                break;
            case crewTxtField.tag:
                statusTxtField.becomeFirstResponder()
                break;
            default:
                break;
        }
        return true
    }

    
    func displayPickerOptions(gesture: UIGestureRecognizer) {
        println("displayCamera")
        var sheet: UIActionSheet = UIActionSheet()
        let title: String = "Add a Photo"
        sheet.title  = title
        sheet.delegate = self
        sheet.addButtonWithTitle("Cancel")
        sheet.addButtonWithTitle("From Camera")
        sheet.addButtonWithTitle("From Library")
        sheet.cancelButtonIndex = 0;
        sheet.showInView(self.view);
    }
    
    
    
    
    func addType(thisType:NSDictionary!) {
        var typename = thisType["name"] as! String!
        eTypes.append(typename)
        var newtypeID = thisType["ID"] as! String!
        eTypeIDs.append(newtypeID.toInt()!)
        var newtypeCode = thisType["code"] as! String!
        eTypeCodes.append(newtypeCode)
        var nextName = thisType["nextName"] as! String!
        nextNames.append(nextName)
    }
    
    
    func addCrew(thisCrew:NSDictionary!) {
        var crewname = thisCrew["name"] as! String!
        crew.append(crewname)
        var crewID = thisCrew["ID"] as! String!
        crewIDs.append(crewID.toInt()!)
    }
    
    
    
    
    //Image Picker Delegates
    //pick image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        
        
        self.imageView.image = chosenImage //4
        self.imgHasChanged = true
        
        
        
        
        dismissViewControllerAnimated(true, completion: nil) //5
    }
    //cancel
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    func urlRequestWithComponents(urlString:String, parameters:NSDictionary) -> (URLRequestConvertible, NSData) {
        
        // create url request to send
        var mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        //let boundaryConstant = "myRandomBoundary12345"
        let boundaryConstant = "NET-POST-boundary-\(arc4random())-\(arc4random())"
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        // add parameters
        for (key, value) in parameters {
            
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            if value is NetData {
                // add image
                var postData = value as! NetData
                
                
                //uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(postData.filename)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                
                // append content disposition
                var filenameClause = " filename=\"\(postData.filename)\""
                let contentDispositionString = "Content-Disposition: form-data; name=\"\(key)\";\(filenameClause)\r\n"
                let contentDispositionData = contentDispositionString.dataUsingEncoding(NSUTF8StringEncoding)
                uploadData.appendData(contentDispositionData!)
                
                
                // append content type
                //uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!) // mark this.
                let contentTypeString = "Content-Type: \(postData.mimeType.getString())\r\n\r\n"
                let contentTypeData = contentTypeString.dataUsingEncoding(NSUTF8StringEncoding)
                uploadData.appendData(contentTypeData!)
                uploadData.appendData(postData.data)
                
            }else{
                uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
            }
        }
        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        
        // return URLRequestConvertible and NSData
        return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }
    
    
    func saveData(){
        
        if(self.typeID == 0){
            println("Select Type")
            
            self.typeTxtField.backgroundColor = UIColor(hex:0x800800, op: 0.2)
            self.typeTxtField.layer.borderColor = UIColor(hex:0x800800, op: 0.6).CGColor
            self.typeTxtField.becomeFirstResponder()
            
            var alert = UIAlertController(title: "Select equipment type", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        if(self.statusValue == 0){
            println("Select Status")
            
            self.statusTxtField.backgroundColor = UIColor(hex:0x800800, op: 0.2)
            self.statusTxtField.layer.borderColor = UIColor(hex:0x800800, op: 0.6).CGColor
            statusTxtField.becomeFirstResponder()
            
            var alert = UIAlertController(title: "Select equipment status", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        
        if(self.imgHasChanged == false){
            println("choose an image")
            
            self.imageView.layer.borderColor = UIColor(hex:0x800800, op: 0.6).CGColor
            imageView.becomeFirstResponder()
            
            var alert = UIAlertController(title: "Select an Image", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        println("saveData: \(self.imageView.image)")
        showLoadingScreen()
        
        var parameters = [
            "pic"       :NetData(jpegImage: self.imageView.image!, compressionQuanlity: 1.0, filename: "myImage.jpeg"),
            "type"      :self.typeID,
            "typeCode"  :self.typeCode,
            "make"      :self.makeTxtField.text,
            "model"     :self.modelTxtField.text,
            "serial"    :self.serialTxtField.text,
            "dealer"    :self.dealerTxtField.text,
            "mileage"   :self.mileageTxtField.text,
            "engine"    :self.engineTxtField.text,
            "fuel"      :self.fuelTxtField.text,
            "purchased" :self.purchasedTxtField.text,
            "crew"      :self.crewValue,
            "status"    :self.statusValue
        ]
        
        
        println("parameters = \(parameters)")
        
        let urlRequest = self.urlRequestWithComponents("http://www.atlanticlawnandgarden.com/cp/functions/new/equipment.php", parameters: parameters)
        
        //let urlRequest = self.urlRequestWithComponents("http://test.plantcombos.com/uploadApp.php", parameters: parameters)
        
        
        
        Alamofire.upload(urlRequest.0, urlRequest.1)
            .progress { _, totalBytesRead, totalBytesExpectedToRead in
                println("ENTER .PROGRESSS")
                println("\(totalBytesRead) of \(totalBytesExpectedToRead)")
                
                self.progressView.alpha = 1.0
                dispatch_async(dispatch_get_main_queue()) {
                    // 6
                    self.progressView.setProgress(Float(totalBytesRead) / Float(totalBytesExpectedToRead), animated: true)
                    
                    // 7
                    if totalBytesRead == totalBytesExpectedToRead {
                        self.hideLoadingScreen()
                    }
                }
                
            }
            
            
            .responseString { (request, response, JSON, error) in
                println("REQUEST \(request)")
                println("RESPONSE \(response)")
                println("JSON \(JSON)")
                println("ERROR \(error)")
            }
            .responseJSON { (request, response, JSON, error) in
                
                println("REQUEST \(request)")
                println("RESPONSE \(response)")
                println("JSON \(JSON)")
                println("ERROR \(error)")
        }
    }
    
    
    
    func showLoadingScreen(){
        self.view.userInteractionEnabled = false
        self.backButton.userInteractionEnabled = false
        UIView.animateWithDuration(0.75, animations: {() -> Void in
            self.loadingView.alpha = 1
        })
    }
    
    func hideLoadingScreen(){
        
        for view in self.scrollView.subviews {
            if let fld = view as? PaddedTextField {
                fld.reset()
            } else {
                print("BAD")
            }
        }
        
        UIView.animateWithDuration(0.75, animations: {() -> Void in
            self.loadingView.alpha = 0
            self.view.userInteractionEnabled = true
        })
        self.backButton.userInteractionEnabled = true
        
        //reset values
        self.typePicker.selectRow(0, inComponent: 0, animated: true)
        self.makeTxtField.text = ""
        self.modelTxtField.text = ""
        self.nameTxtField.text = ""
        self.serialTxtField.text = ""
        self.dealerTxtField.text = ""
        self.mileageTxtField.text = ""
        self.engineTxtField.text = ""
        self.fuelTxtField.text = ""
        self.progressValue = 0
        self.progressView.progress = progressValue
        self.purchasedTxtField.text = ""
        self.crewPicker.selectRow(0, inComponent: 0, animated: true)
        self.typePicker.selectRow(0, inComponent: 0, animated: true)
        self.statusPicker.selectRow(0, inComponent: 0, animated: true)
        self.typeValue = ""
        self.typeTxtField.text = ""
        self.crewTxtField.text = ""
        self.statusTxtField.text = ""
        self.imageView.image = self.defaultImage
        self.typeID = 0
        self.crewValue = 0
        self.statusValue = 0

    }
    
    
    func goBack(){
        navigationController?.popViewControllerAnimated(true)
        
    }

    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}