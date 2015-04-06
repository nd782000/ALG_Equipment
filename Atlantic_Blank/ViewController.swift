//
//  ViewController.swift
//  Atlantic_Blank
//
//  Created by Nicholas Digiando on 4/6/15.
//  Copyright (c) 2015 Nicholas Digiando. All rights reserved.
//

import UIKit

protocol LoginDelegate{
    func setLoginStatus()
    //func toggleLeftPanel()
}

class ViewController: UIViewController, UIActionSheetDelegate, LoginDelegate  {
    
    var menuButton:UIBarButtonItem!
    var delegate:MenuDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        menuButton = UIBarButtonItem(title: "Menu", style: .Plain, target: self, action: "displayMenuView")
        navigationItem.rightBarButtonItem = menuButton
        
        
    }
    
    
    func displayMenuView() {
        println("displayMenuView")
        
        
        var sheet: UIActionSheet = UIActionSheet()
        let title: String = "Menu"
        sheet.title  = title
        sheet.delegate = self
        sheet.addButtonWithTitle("Cancel")
        sheet.addButtonWithTitle("Equipment List")
        sheet.addButtonWithTitle("Maintenance Schedule")
        sheet.addButtonWithTitle("Log In / Out")
        sheet.cancelButtonIndex = 0;
        sheet.showInView(self.view);
        
    }
    
    
    
    
    //Action Sheet Delegate
    func actionSheet(sheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        println("index %d %@", buttonIndex, sheet.buttonTitleAtIndex(buttonIndex));
        
        
        switch (buttonIndex) {
        case 1:
            delegate.menuChange(1)
            break;
        case 2:
            delegate.menuChange(2)
            break;
        case 3:
            delegate.menuChange(3)
            break;
            
        default:
            break;
        }
        
        
        
    }
    
    
    
    
    
    func setLoginStatus() {
        
        
        //self.loginButton.title = "Log Out"
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