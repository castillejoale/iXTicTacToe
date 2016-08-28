//
//  RegistrationViewController.swift
//  Onboarding
//
//  Created by Josh Broomberg on 2016/05/27.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit
import SwiftyJSON

class RegistrationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: EmailValidatedTextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        
        passwordField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtontapped(sender: UIButton) {
        
        let email = emailField.text!
        let password = passwordField.text!
        
        if !emailField.validate() {
            return
        }
        
        //new registration code 
        UserController.sharedInstance.registerUser(email,password: password, presentingViewController: self, viewControllerCompletionFunction: {(user,message) in self.registrationComplete(user,message:message)})
        
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func registrationComplete(user:User?,message:String?) {
        
        if let _ = user   {
        
            //successfully registered
            let alert = UIAlertController(title:"Registration Successful", message:"You will now be logged in", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {(action) in
                //when the user clicks "Ok", do the following
                let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.navigateToLoggedInNavigationController()
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }   else    {
            
            //registration failed
            let alert = UIAlertController(title:"Registration Failed", message:message!, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: {
                
            })
            
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
