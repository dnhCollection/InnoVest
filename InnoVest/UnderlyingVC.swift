//
//  UnderlyingVC.swift
//  
//
//  Created by chendong.xiaohong on 2015-09-08.
//
//

import UIKit

class UnderlyingVC: UIViewController {

    
    
    @IBAction func germanStocks(sender: UIButton) {
        
        //TODO: unwinding sague back
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func euroStocks(sender: UIButton) {
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func worldStocks(sender: UIButton) {
        //dismissViewControllerAnimated(true, completion: nil)

    }
    
    override var preferredContentSize: CGSize{
        get{
            return CGSize(width: 200, height: 200)
        }
        set{
            
        }
    }
    
    
    
}
