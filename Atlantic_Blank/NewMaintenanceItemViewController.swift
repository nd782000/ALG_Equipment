//
//  NewMaintenanceItemViewController.swift
//  Atlantic_Blank
//
//  Created by Nicholas Digiando on 4/6/15.
//  Copyright (c) 2015 Nicholas Digiando. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class NewMaintenanceItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate{
    
    var layoutVars:LayoutVars = LayoutVars()
    var customerLbl:UILabel = UILabel()
    
    var nameTxtField: UITextField!
    var makeTxtField: UITextField!
    var modelTxtField: UITextField!
    var dealerTxtField: UITextField!
    var purchasedTxtField: UITextField!
    var serialTxtField: UITextField!
    
    var imageView:UIImageView!
    
    //var delegate:MenuDelegate!
    
    let picker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Looks for single or multiple taps.
        var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
        
        
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
        
        
        
        self.nameTxtField = UITextField()
        self.nameTxtField.frame = CGRectMake(50, 100, 200, 30)
        self.nameTxtField.backgroundColor = UIColor.whiteColor()
        self.nameTxtField.layer.cornerRadius = 4.0
        self.nameTxtField.attributedPlaceholder = NSAttributedString(string:"Name",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.view.addSubview(self.nameTxtField)
        
        self.makeTxtField = UITextField()
        self.makeTxtField.frame = CGRectMake(50, 140, 200, 30)
        self.makeTxtField.backgroundColor = UIColor.whiteColor()
        self.makeTxtField.layer.cornerRadius = 4.0
        self.makeTxtField.attributedPlaceholder = NSAttributedString(string:"Make",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.view.addSubview(self.makeTxtField)
        
        self.modelTxtField = UITextField()
        self.modelTxtField.frame = CGRectMake(50, 180, 200, 30)
        self.modelTxtField.backgroundColor = UIColor.whiteColor()
        self.modelTxtField.layer.cornerRadius = 4.0
        self.modelTxtField.attributedPlaceholder = NSAttributedString(string:"Model",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.view.addSubview(self.modelTxtField)
        
        self.dealerTxtField = UITextField()
        self.dealerTxtField.frame = CGRectMake(50, 220, 200, 30)
        self.dealerTxtField.backgroundColor = UIColor.whiteColor()
        self.dealerTxtField.layer.cornerRadius = 4.0
        self.dealerTxtField.attributedPlaceholder = NSAttributedString(string:"Dealer",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.view.addSubview(self.dealerTxtField)
        
        self.purchasedTxtField = UITextField()
        self.purchasedTxtField.frame = CGRectMake(50, 260, 200, 30)
        self.purchasedTxtField.backgroundColor = UIColor.whiteColor()
        self.purchasedTxtField.layer.cornerRadius = 4.0
        self.purchasedTxtField.attributedPlaceholder = NSAttributedString(string:"Purchase Date",attributes:[NSForegroundColorAttributeName: layoutVars.buttonColor1])
        self.view.addSubview(self.purchasedTxtField)
        
        self.imageView = UIImageView()
        var thumbX = (self.view.frame.size.width - 300)/2;
        self.imageView.frame = CGRectMake(thumbX, 300, 300, 200)
        self.imageView.contentMode = .ScaleAspectFit //3
        self.view.addSubview(self.imageView)
        
        
        var submitEquipmentButton   = UIButton.buttonWithType(UIButtonType.System) as UIButton
        submitEquipmentButton.frame = CGRectMake(100, 500, 100, 50)
        submitEquipmentButton.backgroundColor = layoutVars.buttonColor1
        submitEquipmentButton.setTitle("Submit", forState: UIControlState.Normal)
        submitEquipmentButton.titleLabel!.font =  layoutVars.buttonFont
        submitEquipmentButton.setTitleColor(layoutVars.buttonTextColor, forState: UIControlState.Normal)
        submitEquipmentButton.layer.cornerRadius = 4.0
        
        submitEquipmentButton.addTarget(self, action: "saveData", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(submitEquipmentButton)
        
        
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
        println("saveData")
        
        var parameters = [
            "pic"           :NetData(jpegImage: self.imageView.image!, compressionQuanlity: 1.0, filename: "myImage.jpg"),
            "otherParm"     :"Value"
        ]
        
        
        let urlRequest = self.urlRequestWithComponents("http://www.atlanticlawnandgarden.com/cp/uploads/upload_equipment_image.php", parameters: parameters)
        
        //let urlRequest = self.urlRequestWithComponents("http://test.plantcombos.com/uploadApp.php", parameters: parameters)
        
        
        
        Alamofire.upload(urlRequest.0, urlRequest.1)
            .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                println("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
            }
            .responseJSON { (request, response, JSON, error) in
                println("REQUEST \(request)")
                println("RESPONSE \(response)")
                println("JSON \(JSON)")
                println("ERROR \(error)")
        }
        
        
        
    }
    
    
    
    
    
    
    func goBack(){
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    func setLabel(lblText:String) {
        customerLbl.text = lblText
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
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}