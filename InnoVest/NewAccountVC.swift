//
//  NewAccountVC.swift
//  Inno Saving Invest
//
//  Created by chendong.xiaohong on 2015-09-11.
//  Copyright (c) 2015 FinSol. All rights reserved.
//

import UIKit

class NewAccountVC: UIViewController {
    
    @IBOutlet weak var newUserName: UITextField!
    
    @IBOutlet weak var birthDateInput: UITextField!
    @IBOutlet weak var maturityDateInput: UITextField!
    @IBOutlet weak var genderInput: UITextField!
    @IBOutlet weak var communicationInput: UITextField!
    @IBOutlet weak var addressInput: UITextField!
    
    var recordInit = Record()
    
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        newUserName.placeholder = "Please enter new User-Name"
    }
    
    @IBAction func registerNewAccount(sender: UIButton)
    {
        if !newUserName.text.isEmpty{
            
            recordInit.userInfo.birthDate = birthDateInput.text
            recordInit.userInfo.maturityDate = maturityDateInput.text
            recordInit.userInfo.gender = genderInput.text
            recordInit.userInfo.communication = communicationInput.text
            recordInit.userInfo.address = addressInput.text
            
            self.defaults.setObject(Util.record2param(recordInit), forKey: "recordNewAccount")
            
            println("very thing fine till now")
            
            performSegueWithIdentifier("newAccountToMainVC", sender: self)
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = segue.identifier
        
        switch identifier!{
            case "newAccountToMainVC": self.defaults.setObject(newUserName.text!, forKey: "userName")
        default: println("unknown segue identifier")
        }
    }
    
    
    
}
