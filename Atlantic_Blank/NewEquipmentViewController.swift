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
    // var containerView: UIView!
    var containerView:UIView!
    var tapBtn:UIButton!
    var loadingView:UIView!
    
    //let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    var layoutVars:LayoutVars = LayoutVars()
    var typeValue:String!
    var typePicker: Picker!
    var typeTxtField: PaddedTextField!
    var makeTxtField: PaddedTextField!
    var modelTxtField: PaddedTextField!
    var serialTxtField: PaddedTextField!
    var dealerTxtField: PaddedTextField!
    var mileageTxtField: PaddedTextField!
    var engineTxtField: PaddedTextField!
    var fuelTxtField: PaddedTextField!
    var purchasedTxtField: PaddedTextField!
    var crewValue:String!
    var crewPicker :Picker!
    var crewTxtField: PaddedTextField!
    
    var activeTextField:PaddedTextField?

    
    var imageView:UIImageView!
    var progressView:UIProgressView!
    var progressValue:Float!
    var progressLbl:Label!
    
    let datePickerView = DatePicker()
    var dateFormatter = NSDateFormatter()
    
    var submitEquipmentButton:Button!
    
    let picker = UIImagePickerController()
    
    
    var eTypes:[String] = []
    let crew = ["LC1", "LC2", "LC3", "MS1", "TR1", "TR2", "TR3"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("OLD TYPES: \(eTypes)")
        Alamofire.request(.POST, "http://atlanticlawnandgarden.com/cp/app/equipmentTypes.php")
            .responseJSON { (request, response, data, error) in
                //println("TYPES JSON\(data)")
                if let allTypes = data as? NSArray {
                    for thisType in allTypes {
                        var typename = thisType["name"] as String!
                        self.addType(typename)
                        //println("Type Name: \(typename)");
                    }
                }
                self.typePicker.reloadAllComponents()
        }
        
        println("NEW TYPES: \(eTypes)")
        
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSizeMake(layoutVars.fullWidth, 1000)
        self.view.addSubview(self.scrollView)
        
        //container view for auto layout
        self.containerView = UIView()
        self.containerView.backgroundColor = layoutVars.backgroundColor

        
        self.containerView.frame = CGRectMake(0, 0, 500, 2500)

        self.scrollView.addSubview(self.containerView)
        
        self.tapBtn = UIButton()
        self.tapBtn.frame = CGRectMake(0, 0, 500, 2500)
        self.tapBtn.backgroundColor = UIColor.clearColor()
        self.tapBtn.addTarget(self, action: "DismissKeyboard", forControlEvents: UIControlEvents.TouchUpInside)
        
        //self.containerView.addSubview(self.tapBtn)
        
        // Do any additional setup after loading the view.
        view.backgroundColor = layoutVars.backgroundColor
        title = "New Equipment"
        
        
        //custom back button
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        backButton.addTarget(self, action: "goBack", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setTitle("Back", forState: UIControlState.Normal)
        backButton.titleLabel!.font =  layoutVars.buttonFont
        backButton.sizeToFit()
        var backButtonItem:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem  = backButtonItem
        
        
        var cameraButton = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "displayPickerOptions")
        navigationItem.rightBarButtonItem = cameraButton
        self.picker.delegate = self
        
        let typeToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        var typeItems = [AnyObject]()
        //making done button
        let tnextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "tnextPressed")
        tnextButton
        typeItems.append(tnextButton)
        typeToolbar.barStyle = UIBarStyle.Black
        typeToolbar.setItems(typeItems, animated: true)
        
        self.typePicker = Picker()
        self.typePicker.delegate = self
        self.typeTxtField = PaddedTextField()
        self.typeTxtField.delegate = self
        self.typeTxtField.tag = 9
        self.typeTxtField.inputView = typePicker
        self.typeTxtField.inputAccessoryView = typeToolbar
        self.typeTxtField.attributedPlaceholder = NSAttributedString(string:"Equipment Type",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.containerView.addSubview(self.typeTxtField)
        

        self.containerView.addSubview(self.typeTxtField)
        
        self.makeTxtField = PaddedTextField()
        self.makeTxtField.delegate = self
        self.makeTxtField.tag = 1
        self.makeTxtField.attributedPlaceholder = NSAttributedString(string:"Make",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.containerView.addSubview(self.makeTxtField)
        
        self.modelTxtField = PaddedTextField()
        self.modelTxtField.delegate = self
        self.modelTxtField.tag = 2
        self.modelTxtField.attributedPlaceholder = NSAttributedString(string:"Model",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.containerView.addSubview(self.modelTxtField)
        
        self.serialTxtField = PaddedTextField()
        self.serialTxtField.delegate = self
        self.serialTxtField.tag = 3
        self.serialTxtField.attributedPlaceholder = NSAttributedString(string:"Serial",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.containerView.addSubview(self.serialTxtField)
        
        
        self.dealerTxtField = PaddedTextField()
        self.dealerTxtField.delegate = self
        self.dealerTxtField.tag = 4
        self.dealerTxtField.attributedPlaceholder = NSAttributedString(string:"Dealer",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.containerView.addSubview(self.dealerTxtField)
        
        let mileageToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        var mileageItems = [AnyObject]()
        //making done button
        let mnextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "mnextPressed")
        mileageItems.append(mnextButton)
        mileageToolbar.barStyle = UIBarStyle.Black
        mileageToolbar.setItems(mileageItems, animated: true)
        self.mileageTxtField = PaddedTextField()
        self.mileageTxtField.delegate = self
        self.mileageTxtField.tag = 5
        self.mileageTxtField.inputAccessoryView = mileageToolbar
        self.mileageTxtField.keyboardType = UIKeyboardType.NumberPad
        self.mileageTxtField.attributedPlaceholder = NSAttributedString(string:"Mileage",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.containerView.addSubview(self.mileageTxtField)
        
        self.engineTxtField = PaddedTextField()
        self.engineTxtField.delegate = self
        self.engineTxtField.tag = 6
        self.engineTxtField.attributedPlaceholder = NSAttributedString(string:"Engine Type",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.containerView.addSubview(self.engineTxtField)
        
        self.fuelTxtField = PaddedTextField()
        self.fuelTxtField.delegate = self
        self.fuelTxtField.tag = 7
        self.fuelTxtField.attributedPlaceholder = NSAttributedString(string:"Fuel Type",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.containerView.addSubview(self.fuelTxtField)

        //datePickerView.datePickerMode = UIDatePickerMode.Date
        //DatePickerView.backgroundColor = layoutVars.backgroundLight
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        var items = [AnyObject]()
        //making done button
        let nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "nextPressed")
        items.append(nextButton)
        toolbar.barStyle = UIBarStyle.Black
        toolbar.setItems(items, animated: true)
        
        datePickerView.addTarget( self, action: "handleDatePicker", forControlEvents: UIControlEvents.ValueChanged )
        
        //usDateFormat now contains an optional string "MM/dd/yyyy".
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        self.purchasedTxtField = PaddedTextField()
        self.purchasedTxtField.delegate = self
        self.purchasedTxtField.tag = 8
        self.purchasedTxtField.inputView = self.datePickerView
        self.purchasedTxtField.inputAccessoryView = toolbar
        self.purchasedTxtField.attributedPlaceholder = NSAttributedString(string:"Purchased Date",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.containerView.addSubview(self.purchasedTxtField)
        
        
        let crewToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        var crewItems = [AnyObject]()
        //making done button
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "donePressed")
        crewItems.append(doneButton)
        crewToolbar.barStyle = UIBarStyle.Black
        crewToolbar.setItems(crewItems, animated: true)
        
        self.crewPicker = Picker()
        self.crewPicker.delegate = self
        self.crewTxtField = PaddedTextField()
        self.crewTxtField.delegate = self
        self.crewTxtField.tag = 9
        self.crewTxtField.inputView = crewPicker
        self.crewTxtField.inputAccessoryView = crewToolbar
        self.crewTxtField.attributedPlaceholder = NSAttributedString(string:"Select Crew / Employee",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.containerView.addSubview(self.crewTxtField)
        
        
        self.imageView = UIImageView()
        self.imageView.backgroundColor = UIColor.grayColor()
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.containerView.addSubview(self.imageView)
        
        self.progressView = UIProgressView()
        self.progressView.alpha = 0
        self.progressView.tintColor = UIColor.blueColor()
        self.progressView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.containerView.addSubview(self.progressView)
        
        self.progressLbl = Label(titleText: "Uploading...")
        self.progressLbl.alpha = 0
        self.progressLbl.textAlignment = NSTextAlignment.Center
        self.containerView.addSubview(self.progressLbl)
        
        
        self.submitEquipmentButton = Button(titleText: "Submit")
       // self.submitEquipmentButton = Button.buttonWithType(UIButtonType.System) as UIButton
        //self.submitEquipmentButton.backgroundColor = layoutVars.buttonColor1
        //self.submitEquipmentButton.setTitle("Submit", forState: UIControlState.Normal)
        
       // self.submitEquipmentButton.titleLabel!.font =  layoutVars.buttonFont
        //self.submitEquipmentButton.setTitleColor(layoutVars.buttonTextColor, forState: UIControlState.Normal)
        //self.submitEquipmentButton.layer.cornerRadius = 4.0
        self.submitEquipmentButton.addTarget(self, action: "saveData", forControlEvents: UIControlEvents.TouchUpInside)
        //self.submitEquipmentButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.containerView.addSubview(self.submitEquipmentButton)
        
        
        
        
        /////////////////  Auto Layout   ////////////////////////////////////////////////
        
        //apply to each view
        //itemsTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        //auto layout group
        let viewsDictionary = [
            "view1":self.typeTxtField,
            "view2":self.makeTxtField,
            "view3":self.modelTxtField,
            "view4":self.serialTxtField,
            "view5":self.dealerTxtField,
            "view6":self.mileageTxtField,
            "view7":self.engineTxtField,
            "view8":self.fuelTxtField,
            "view9":self.purchasedTxtField,
            "view10":self.crewTxtField,
            "view11":self.imageView,
            "view12":self.progressView,
            "view13":self.progressLbl,
            "view14":self.submitEquipmentButton
        ]
        
        let sizeVals = ["width": self.view.frame.size.width - 30,"height": 40]
        
        //////////////   auto layout position constraints   /////////////////////////////
        
        let viewsConstraint_H1:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[view1(width)]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H2:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[view2(width)]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H3:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[view3(width)]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H4:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[view4(width)]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H5:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[view5(width)]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H6:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[view6(width)]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H7:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[view7(width)]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H8:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[view8(width)]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H9:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[view9(width)]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H10:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[view10(width)]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H11:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[view11(width)]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H12:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[view12(width)]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H13:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[view13(width)]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_H14:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[view14(width)]-15-|", options: nil, metrics: sizeVals, views: viewsDictionary)
        let viewsConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[view1(height)]-15-[view2(height)]-15-[view3(height)]-15-[view4(height)]-15-[view5(height)]-15-[view6(height)]-15-[view7(height)]-15-[view8(height)]-15-[view9(height)]-15-[view10(height)]-15-[view11(width)]-3-[view12(height)]-8-[view13(height)]-10-[view14(height)]", options: nil, metrics: sizeVals, views: viewsDictionary)
        
        self.containerView.addConstraints(viewsConstraint_H1)
        self.containerView.addConstraints(viewsConstraint_H2)
        self.containerView.addConstraints(viewsConstraint_H3)
        self.containerView.addConstraints(viewsConstraint_H4)
        self.containerView.addConstraints(viewsConstraint_H5)
        self.containerView.addConstraints(viewsConstraint_H6)
        self.containerView.addConstraints(viewsConstraint_H7)
        self.containerView.addConstraints(viewsConstraint_H8)
        self.containerView.addConstraints(viewsConstraint_H9)
        self.containerView.addConstraints(viewsConstraint_H10)
        self.containerView.addConstraints(viewsConstraint_H11)
        self.containerView.addConstraints(viewsConstraint_H12)
        self.containerView.addConstraints(viewsConstraint_H13)
        self.containerView.addConstraints(viewsConstraint_H14)
        self.containerView.addConstraints(viewsConstraint_V)
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
            
        }else{
            return self.crew.count
        }
        
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        if (pickerView == typePicker) {
            // Do something
            return self.eTypes[row]
        }else{
            return self.crew[row]
        }
        
        
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        // typeTxtField.text = "\(self.type[row])"
        // selected value in Uipickerview in Swift
        
        if (pickerView == typePicker) {
            self.typeValue=self.eTypes[row]
            self.typeTxtField.text=self.eTypes[row]
            println("values:----------\(self.typeValue)");
        }else{
            self.crewValue=self.crew[row]
            self.crewTxtField.text=self.crew[row]
            println("values:----------\(self.crewValue)");
        }
    
    }
    
    
    
    
    func handleDatePicker()
    {
        println("PURCHASE DATE: \(dateFormatter.stringFromDate(datePickerView.date))")
        self.purchasedTxtField.text =  dateFormatter.stringFromDate(datePickerView.date)
    }
    
    
    
    //Action Sheet Delegate
    func actionSheet(sheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
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
    
    func textFieldDidBeginEditing(textField: PaddedTextField) {
        println("PLEASE SCROLL")
        let offset = (textField.frame.origin.y - 79)
        var scrollPoint : CGPoint = CGPointMake(0, offset)
        self.scrollView.setContentOffset(scrollPoint, animated: true)
        self.activeTextField = textField
    }
    
    func textFieldTextDidEndEditing(textField: PaddedTextField) {
        self.scrollView.setContentOffset(CGPointZero, animated: true)
    }
    
    
    func textFieldShouldReturn(textField: PaddedTextField!) -> Bool {
        textField.resignFirstResponder()
        println("NEXT")
        switch (textField.tag) {
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
            default:
                break;
        }
        return true
    }
   
    func tnextPressed() {
        println("NEXT")
        self.typeTxtField.resignFirstResponder()
        self.makeTxtField.becomeFirstResponder()
    }
    
    func mnextPressed() {
        println("NEXT")
        self.mileageTxtField.resignFirstResponder()
        self.engineTxtField.becomeFirstResponder()
    }
    
    func nextPressed() {
        println("NEXT")
        self.purchasedTxtField.resignFirstResponder()
        self.crewTxtField.becomeFirstResponder()
    }
    
    func donePressed() {
        println("DONE")
        self.crewTxtField.resignFirstResponder()
    }

    
    func displayPickerOptions() {
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
    
    
    
    
    func addType(type: String) {
        eTypes.append(type)
        println("ADDING TYPE: \(type)")
    }
    
    
    
    
    //Image Picker Delegates
    //pick image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var chosenImage = info[UIImagePickerControllerOriginalImage] as UIImage //2
        
        
        self.imageView.image = chosenImage //4
        
        
        
        
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
                var postData = value as NetData
                
                
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
        if(self.imageView.image == nil){
            println("choose an image")
            var alert = UIAlertController(title: "Selct an Image", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            
            
            return
        }
        
        println("saveData")
        showLoadingScreen()
        
        var parameters = [
            "pic"           :NetData(jpegImage: self.imageView.image!, compressionQuanlity: 1.0, filename: "myImage.jpeg"),
            "type"      :self.typeValue,
            "make"      :self.makeTxtField.text,
            "model"     :self.modelTxtField.text,
            "serial"    :self.serialTxtField.text,
            "dealer"    :self.dealerTxtField.text,
            "mileage"   :self.mileageTxtField.text,
            "engine"    :self.engineTxtField.text,
            "fuel"      :self.fuelTxtField.text,
            "purchased" :self.purchasedTxtField.text,
            "crew"      :self.crewValue,
            "status" : "To be added later"
        ]
        
        
        var otherParam: AnyObject? = parameters["otherParm"]
        println("parameters = \(otherParam)")
        
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
                        self.progressView.alpha = 0
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
        self.loadingView = UIButton(frame: CGRect(x: 0, y: 0, width: 500, height: 1500))
        loadingView.backgroundColor = UIColor.grayColor()
        loadingView.alpha = 0.5
        self.scrollView.addSubview(loadingView)
        self.progressView.alpha = 1.0
        self.progressLbl.alpha = 1.0
        self.view.userInteractionEnabled = false
        
        
    }
    
    func hideLoadingScreen(){
        self.loadingView.removeFromSuperview()
        self.progressView.alpha = 0
        self.progressLbl.alpha = 0
        //reset values
        self.typePicker.selectRow(0, inComponent: 0, animated: true)
        self.makeTxtField.text = ""
        self.modelTxtField.text = ""
        self.serialTxtField.text = ""
        self.dealerTxtField.text = ""
        self.mileageTxtField.text = ""
        self.engineTxtField.text = ""
        self.fuelTxtField.text = ""
        self.purchasedTxtField.text = ""
        self.crewPicker.selectRow(0, inComponent: 0, animated: true)
        self.typeValue = ""
        self.crewValue = ""
        self.imageView.image = nil
        
        
        self.view.userInteractionEnabled = true
        
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