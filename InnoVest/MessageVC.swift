//
//  MessageVC.swift
//  InsuranceInvestSingleView
//
//  Created by chendong.xiaohong on 2015-09-08.
//  Copyright (c) 2015 dd. All rights reserved.
//

import UIKit

class MessageVC: UIViewController {

    @IBOutlet weak var messageView: UITextView!
    
    var message: String=""{
        didSet {
            messageView?.text = message
        }
    }
    
    override var preferredContentSize: CGSize{
        get{
            return CGSize(width: 200, height: 70)
        }
        set{
            
        }
    }
    
    override func viewDidLoad() {
        messageView?.text = message
    }
}

