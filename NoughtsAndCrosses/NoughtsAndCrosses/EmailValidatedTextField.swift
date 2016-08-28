//
//  EmailValidatedTextField.swift
//  Onboarding
//
//  Created by Josh Broomberg on 2016/05/31.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class EmailValidatedTextField: UITextField, UITextFieldDelegate {
    var imageView: UIImageView = UIImageView()
    
    override func drawRect(rect: CGRect) {
        self.delegate = self
        imageView = UIImageView(frame: CGRectMake(self.frame.width-30, 5, 22, 22))
        self.addSubview(imageView)
    }
    
    func validate() -> Bool {
        updateUI()
        return valid()
    }
    
    func valid() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self.text!)
        
    }
    
    func updateUI() {
        if (self.valid())   {
            imageView.image = UIImage(named: "input_valid")
        }   else    {
            imageView.image = UIImage(named: "input_invalid")
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if string == "" {
            self.text = self.text![self.text!.startIndex..<self.text!.endIndex.predecessor()]
        } else {
            self.text = self.text! + string
        }
        
        updateUI()
        
        return false
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.endEditing(true)
        return false
        
    }
    
}
