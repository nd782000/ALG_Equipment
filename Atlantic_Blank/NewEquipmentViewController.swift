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
    
    
    var layoutVars:LayoutVars = LayoutVars()
    //var customerLbl:UILabel = UILabel()
    var typeValue:String!
    var typePicker :UIPickerView!
    var makeTxtField: UITextField!
    var modelTxtField: UITextField!
    var serialTxtField: UITextField!
    var dealerTxtField: UITextField!
    var mileageTxtField: UITextField!
    var engineTxtField: UITextField!
    var fuelTxtField: UITextField!
    var purchasedTxtField: UITextField!
    var crewValue:String!
    var crewPicker :UIPickerView!
    
    var imageView:UIImageView!
    var progressView:UIProgressView!
    var progressValue:Float!
    var progressLbl:UILabel!
    
    
    var submitEquipmentButton:UIButton!
    
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
        self.scrollView.contentSize = CGSizeMake(layoutVars.fullWidth, 1500)
        self.view.addSubview(self.scrollView)
        
        // self.containerView = UIView()
        
        //self.scrollView.addSubview(self.containerView)
        
        
        //container view for auto layout
        self.containerView = UIView()
        self.containerView.backgroundColor = layoutVars.backgroundColor
        self.containerView.frame = CGRectMake(0, 0, 500, 2500)
        self.scrollView.addSubview(self.containerView)
        
        self.tapBtn = UIButton()
        self.tapBtn.frame = CGRectMake(0, 0, 500, 2500)
        self.tapBtn.backgroundColor = UIColor.clearColor()
        self.tapBtn.addTarget(self, action: "DismissKeyboard", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.containerView.addSubview(self.tapBtn)
        
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
        
        self.typePicker = UIPickerView()
        self.typePicker.backgroundColor = UIColor.whiteColor()
        self.typePicker.layer.cornerRadius = 4.0
        self.typePicker.delegate = self
        self.typePicker.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.containerView.addSubview(self.typePicker)
        
        self.makeTxtField = UITextField()
        self.makeTxtField.backgroundColor = UIColor.whiteColor()
        self.makeTxtField.layer.cornerRadius = 4.0
        self.makeTxtField.attributedPlaceholder = NSAttributedString(string:"Make",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.makeTxtField.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.containerView.addSubview(self.makeTxtField)
        
        self.modelTxtField = UITextField()
        self.modelTxtField.backgroundColor = UIColor.whiteColor()
        self.modelTxtField.layer.cornerRadius = 4.0
        self.modelTxtField.attributedPlaceholder = NSAttributedString(string:"Model",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.modelTxtField.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.containerView.addSubview(self.modelTxtField)
        
        self.serialTxtField = UITextField()
        self.serialTxtField.backgroundColor = UIColor.whiteColor()
        self.serialTxtField.layer.cornerRadius = 4.0
        self.serialTxtField.attributedPlaceholder = NSAttributedString(string:"Serial",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.serialTxtField.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.containerView.addSubview(self.serialTxtField)
        
        
        self.dealerTxtField = UITextField()
        self.dealerTxtField.backgroundColor = UIColor.whiteColor()
        self.dealerTxtField.layer.cornerRadius = 4.0
        self.dealerTxtField.attributedPlaceholder = NSAttributedString(string:"Dealer",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.dealerTxtField.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.containerView.addSubview(self.dealerTxtField)
        
        self.mileageTxtField = UITextField()
        self.mileageTxtField.backgroundColor = UIColor.whiteColor()
        self.mileageTxtField.layer.cornerRadius = 4.0
        self.mileageTxtField.keyboardType = UIKeyboardType.NumberPad
        self.mileageTxtField.attributedPlaceholder = NSAttributedString(string:"Mileage",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.mileageTxtField.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.containerView.addSubview(self.mileageTxtField)
        
        self.engineTxtField = UITextField()
        self.engineTxtField.backgroundColor = UIColor.whiteColor()
        self.engineTxtField.layer.cornerRadius = 4.0
        self.engineTxtField.attributedPlaceholder = NSAttributedString(string:"Engine Type",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.engineTxtField.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.containerView.addSubview(self.engineTxtField)
        
        self.fuelTxtField = UITextField()
        self.fuelTxtField.backgroundColor = UIColor.whiteColor()
        self.fuelTxtField.layer.cornerRadius = 4.0
        self.fuelTxtField.attributedPlaceholder = NSAttributedString(string:"Fuel Type",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.fuelTxtField.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.containerView.addSubview(self.fuelTxtField)
        
        self.purchasedTxtField = UITextField()
        self.purchasedTxtField.backgroundColor = UIColor.whiteColor()
        self.purchasedTxtField.layer.cornerRadius = 4.0
        self.purchasedTxtField.attributedPlaceholder = NSAttributedString(string:"Purchased Date",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.purchasedTxtField.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.containerView.addSubview(self.purchasedTxtField)
        
        self.crewPicker = UIPickerView()
        self.crewPicker.backgroundColor = UIColor.whiteColor()
        self.crewPicker.layer.cornerRadius = 4.0
        self.crewPicker.delegate = self
        self.crewPicker.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.containerView.addSubview(self.crewPicker)
        
        
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
        
        self.progressLbl = UILabel()
        self.progressLbl.alpha = 0
        self.progressLbl.text = "Uploading..."
        self.progressLbl.textAlignment = NSTextAlignment.Center
        self.progressLbl.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.containerView.addSubview(self.progressLbl)
        
        
        
        self.submitEquipmentButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        self.submitEquipmentButton.backgroundColor = layoutVars.buttonColor1
        self.submitEquipmentButton.setTitle("Submit", forState: UIControlState.Normal)
        
        self.submitEquipmentButton.titleLabel!.font =  layoutVars.buttonFont
        self.submitEquipmentButton.setTitleColor(layoutVars.buttonTextColor, forState: UIControlState.Normal)
        self.submitEquipmentButton.layer.cornerRadius = 4.0
        self.submitEquipmentButton.addTarget(self, action: "saveData", forControlEvents: UIControlEvents.TouchUpInside)
        self.submitEquipmentButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.containerView.addSubview(self.submitEquipmentButton)
        
        
        
        
        /////////////////  Auto Layout   ////////////////////////////////////////////////
        
        //apply to each view
        //itemsTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        //auto layout group
        let viewsDictionary = [
            "view1":self.typePicker,
            "view3":self.makeTxtField,
            "view4":self.modelTxtField,
            "view5":self.serialTxtField,
            "view6":self.dealerTxtField,
            "view7":self.mileageTxtField,
            "view8":self.engineTxtField,
            "view9":self.fuelTxtField,
            "view10":self.purchasedTxtField,
            "view11":self.crewPicker,
            "view12":self.imageView,
            "view13":self.progressView,
            "view14":self.progressLbl,
            "view15":self.submitEquipmentButton
        ]
        
        let metricsDictionary = ["fullWidth": self.view.frame.size.width - 100,"btnHeight":40]
        
        ///////////////   size constraints   ////////////////////////////////////////////
        
        let typePickerConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view1(fullWidth)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let typePickerConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view1(162)]", options: nil, metrics: nil, views: viewsDictionary)
        self.typePicker.addConstraints(typePickerConstraint_H)
        self.typePicker.addConstraints(typePickerConstraint_V)
        

        let makeConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view3(fullWidth)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let makeConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view3(btnHeight)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        self.makeTxtField.addConstraints(makeConstraint_H)
        self.makeTxtField.addConstraints(makeConstraint_V)
        
        let modelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view4(fullWidth)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let modelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view4(btnHeight)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        self.modelTxtField.addConstraints(modelConstraint_H)
        self.modelTxtField.addConstraints(modelConstraint_V)
        
        let serialConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view5(fullWidth)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let serialConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view5(btnHeight)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        self.serialTxtField.addConstraints(serialConstraint_H)
        self.serialTxtField.addConstraints(serialConstraint_V)
        
        let dealerConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view6(fullWidth)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let dealerConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view6(btnHeight)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        self.dealerTxtField.addConstraints(dealerConstraint_H)
        self.dealerTxtField.addConstraints(dealerConstraint_V)
        
        let mileageConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view7(fullWidth)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let mileageConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view7(btnHeight)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        self.mileageTxtField.addConstraints(mileageConstraint_H)
        self.mileageTxtField.addConstraints(mileageConstraint_V)
        
        let engineConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view8(fullWidth)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let engineConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view8(btnHeight)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        self.engineTxtField.addConstraints(engineConstraint_H)
        self.engineTxtField.addConstraints(engineConstraint_V)
        
        let fuelConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view9(fullWidth)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let fuelConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view9(btnHeight)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        self.fuelTxtField.addConstraints(fuelConstraint_H)
        self.fuelTxtField.addConstraints(fuelConstraint_V)
        
        let purchasedConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view10(fullWidth)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let purchasedConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view10(btnHeight)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        self.purchasedTxtField.addConstraints(purchasedConstraint_H)
        self.purchasedTxtField.addConstraints(purchasedConstraint_V)
        
        let crewConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view11(fullWidth)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let crewConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view11(162)]", options: nil, metrics: nil, views: viewsDictionary)
        self.crewPicker.addConstraints(crewConstraint_H)
        self.crewPicker.addConstraints(crewConstraint_V)
        
        
        let imageConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view12(fullWidth)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let imageConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view12(fullWidth)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        self.imageView.addConstraints(imageConstraint_H)
        self.imageView.addConstraints(imageConstraint_V)
        
        let progressConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view13(fullWidth)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let progressConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view13(5)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        self.progressView.addConstraints(progressConstraint_H)
        self.progressView.addConstraints(progressConstraint_V)
        
        let progressLblConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view14(fullWidth)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let progressLblConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view14(30)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        self.progressLbl.addConstraints(progressLblConstraint_H)
        self.progressLbl.addConstraints(progressLblConstraint_V)
        
        let submitConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:[view15(fullWidth)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        let submitConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[view15(btnHeight)]", options: nil, metrics: metricsDictionary, views: viewsDictionary)
        self.submitEquipmentButton.addConstraints(submitConstraint_H)
        self.submitEquipmentButton.addConstraints(submitConstraint_V)
        
        
        
        //////////////   auto layout position constraints   /////////////////////////////
        
        let viewsConstraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-50-[view1]", options: nil, metrics: nil, views: viewsDictionary)
        let viewsConstraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[view1]-20-[view3]-20-[view4]-20-[view5]-20-[view6]-20-[view7]-20-[view8]-20-[view9]-20-[view10]-20-[view11]-20-[view12]-3-[view13]-8-[view14]-10-[view15]", options:  NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewsDictionary)
        
        self.containerView.addConstraints(viewsConstraint_H)
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
            println("values:----------\(self.typeValue)");
        }else{
            self.crewValue=self.crew[row]
            println("values:----------\(self.crewValue)");
            
        }
        
        
        
        
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
            /*.progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
            //self.progressValue =
            
            self.progressView.progress = (totalBytesWritten as Float / totalBytesExpectedToWrite as Float)
            println("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
            }
            */
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
                
                
                
                // self.progressView.setProgress(Float(totalBytesRead) / Float(totalBytesExpectedToRead), animated: true)
                //self.progressView.alpha = 1.0
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
    
    func keyboardWillShow(sender: NSNotification) {
        self.scrollView.contentOffset.y -= 150
        println("SHOW KEYBOARD")
        println(scrollView.contentOffset.y)
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.scrollView.contentOffset.y += 150
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        //tableView.endEditing(true)
        
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}