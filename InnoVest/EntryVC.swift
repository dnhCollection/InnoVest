//
//  ViewController.swift
//  Inno Saving Invest
//
//  Created by chendong.xiaohong on 2015-09-10.
//  Copyright (c) 2015 FinSol. All rights reserved.
//

import UIKit

class EntryVC: UIViewController {

    var userName : String = ""
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func start(sender: UIButton) {
        let alert = UIAlertController(
            title: "Play around or Login ?",
            message: "",
            preferredStyle: UIAlertControllerStyle.ActionSheet
        )

        let action1 = UIAlertAction(title: "Play around", style: UIAlertActionStyle.Default, handler: sequeToMainView)
        alert.addAction(action1)

        let action2 = UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: goLogin)
        alert.addAction(action2)

        let action3 = UIAlertAction(title: "New Account", style: UIAlertActionStyle.Default, handler: newAccount)
        alert.addAction(action3)
        
        let action4 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(action4)
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func sequeToMainView(alert: UIAlertAction!){
        self.defaults.setObject(StaticDefaults.playaroundAccountName, forKey: "userName")
        performSegueWithIdentifier("showMainView", sender: nil)
//        println("test foo")
    }
    
    func goLogin(alert: UIAlertAction!){
        let loginAlert = UIAlertController(
            title: "Start",
            message: "Login",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        
        loginAlert.addTextFieldWithConfigurationHandler { (field:UITextField!) -> Void in
            let lastUserName = Util.readFromDocumentsFile(StaticDefaults.lastLoginFN)
            if lastUserName == ""
            {
                field.placeholder = lastUserName
            }
            else
            {
                field.placeholder = "user name"
            }

        }

        let action2 = UIAlertAction(title: "Login", style: UIAlertActionStyle.Default,
            handler: {(action: UIAlertAction) -> Void in
                let tf = loginAlert.textFields?.first as? UITextField!
                //if tf != nil {self.userName = tf!.text}
                if tf != nil {self.defaults.setObject(tf!.text, forKey: "userName")}
                self.performSegueWithIdentifier("showMainView", sender: nil)
        })
        loginAlert.addAction(action2)
        
        
        let action3 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        loginAlert.addAction(action3)
        
        presentViewController(loginAlert, animated: true, completion: nil)

    }

    func newAccount(alert: UIAlertAction!){
        performSegueWithIdentifier("showNewAccount", sender: nil)
    }
    
}

