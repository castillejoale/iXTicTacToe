//
//  AuthorisationMenuViewController.swift
//  Onboarding
//
//  Created by Josh Broomberg on 2016/05/27.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit
import SwiftyJSON

class LandingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        
        
        self.navigationController?.pushViewController(LoginViewController(nibName: "LoginViewController", bundle: nil), animated: true)
    }
    
    @IBAction func registerButtonTapped(sender: UIButton) {
        self.navigationController?.pushViewController(RegistrationViewController(nibName: "RegistrationViewController", bundle: nil), animated: true)
    }
    
}
