//
//  LoginViewController.swift
//  Onboarding
//
//  Created by Josh Broomberg on 2016/05/27.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: EmailValidatedTextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log in"
        // Do any additional setup after loading the view.
        
        passwordField.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

    @IBAction func backButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        let email = emailField.text!
        let password = passwordField.text!
        
        if !emailField.validate() {
            return
        }
    
        UserController.sharedInstance.loginUser(email, password: password, presentingViewController: self, viewControllerCompletionFunction:{(user, message) in self.loginCallComplete(user,message:message)} )
    }
    
    func loginCallComplete(user:User?,message:String?)   {
        
        if let _ = user   {
            
            //successfully registered
            let alert = UIAlertController(title:"Login Successful", message:"You will now be logged in", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {(action) in
                //when the user clicks "Ok", do the following
                let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.navigateToLoggedInNavigationController()
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }   else    {
            
            //registration failed
            let alert = UIAlertController(title:"Login Failed", message:message!, preferredStyle: UIAlertControllerStyle.Alert)
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
