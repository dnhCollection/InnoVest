//
//  ViewController.swift
//  InsuranceInvestSingleView
//
//  Created by chendong.xiaohong on 2015-08-22.
//  Copyright (c) 2015 dd. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var birthDate: UILabel!
    @IBOutlet weak var maturityDate: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var communication: UILabel!
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var cashOutAmount: UITextField!
    
    @IBOutlet weak var newInvSPEURInput: UITextField!
    @IBOutlet weak var newInvGLEURInput: UITextField!
    
    @IBOutlet weak var underlyingDisplay: UILabel!
    
    @IBOutlet weak var fundAssetT0Display: UILabel!
    @IBOutlet weak var guaranteeAssetT0Display: UILabel!
    @IBOutlet weak var totalAssetT0Display: UILabel!
    @IBOutlet weak var guaranteedPayoutT0Display: UILabel!
    @IBOutlet weak var projectedPayoutT0Display: UILabel!
    
    
    @IBOutlet weak var fundAssetNewInvDisplay: UILabel!
    @IBOutlet weak var guaranteeAssetNewInvDisplay: UILabel!
    @IBOutlet weak var totalAssetNewInvDisplay: UILabel!
    @IBOutlet weak var guaranteedPayoutNewInvDisplay: UILabel!
    @IBOutlet weak var projectedPayoutNewInvDisplay: UILabel!
    
    @IBOutlet weak var fundAssetT1Display: UILabel!
    @IBOutlet weak var guaranteeAssetT1Display: UILabel!
    @IBOutlet weak var totalAssetT1Display: UILabel!
    @IBOutlet weak var guaranteedPayoutT1Display: UILabel!
    @IBOutlet weak var projectedPayoutT1Display: UILabel!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var isWebService = false
    
    var recordOld = Record()
    var recordOldT0Updated = Record()
    var recordNew = Record()
    
    let storeEngine = StorageEngine()
    var calcEngine = CalculationEngine()
    
    var reductionAmount = 0.0
    
    private struct storyBoard {
        static let SequeMessageCashOut = "cashOutMessage"
        static let DefaultKeyUnderlying = "underlyingKey"
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.text = defaults.stringForKey("userName")
        userName.userInteractionEnabled = false
        // the following if-let block initialize the record storage in case of new Account
        if let paramNewAccount = defaults.objectForKey("recordNewAccount") as? [String:String]{
            let recordNewAccount = Util.param2record(paramNewAccount)
            storeEngine.storeRecord(recordNewAccount, userName: userName.text)
            defaults.removeObjectForKey("recordNewAccount")
        }
        
        //var strText = AlamorfirePlayaround.playAlamofire(userName)
        loadAndUpdateT0(userName.text)
        
        cashOutAmount.placeholder = "0"
        
        underlyingDisplay.text = Underlyings.germanStocks.description
        
        var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
        self.newInvSPEURInput.delegate = self
        self.newInvGLEURInput.delegate = self
        self.cashOutAmount.delegate = self
        self.userName.delegate = self
        
    }
    
    @IBAction func loadAndUpdateT0(sender: UIButton) {
        
        loadAndUpdateT0(userName.text)
    }
    
    private func loadAndUpdateT0(userName : String)
    {
        var recordOld = Record()
        func completionLoadRecordWeb(recordLocal:Record)->Void{
            recordOld = recordLocal
            let ttm = getTimeToMaturity(recordOld)
            calcEngine.timeToMaturity = ttm
//            recordOldT0Updated = calcEngine.updateT0(recordOld)
            recordOldT0Updated = recordOld // temporary no update necessary, since no market data update yet.
            displayRecord(recordOldT0Updated)
        }
        storeEngine.loadRecordWeb(userName, completion: completionLoadRecordWeb)
//        recordOld = storeEngine.loadRecord(userName)
        
    }
    
    func DismissKeyboard(){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
    }
    @IBAction func editCashOutAmount(sender: UITextField) {
        
        if !(sender.text == "all")
        {
        reductionAmount = min(recordOld.resultsT0.totalAsset, Util.str2double(cashOutAmount.text))
        // validation: cashout-amount <= totalAsset
            cashOutAmount.text = reductionAmount.description
        }
    }
    
    @IBAction func editNewInvestment(sender: UITextField) {
        recordOldT0Updated.triggerInfo.newInvSPEUR = NSNumberFormatter().numberFromString(sender.text!)!.doubleValue
    }

    @IBAction func editNewInvGL(sender: UITextField) {
        recordOldT0Updated.triggerInfo.newInvGLEUR = NSNumberFormatter().numberFromString(sender.text!)!.doubleValue
    }

    
    @IBAction func segueToUnderlying(sender: UIButton) {
        performSegueWithIdentifier("showUnderlying", sender: self)
    }
    
    @IBAction func goBack(segue: UIStoryboardSegue){
        let identifier = segue.identifier!
        if let label = underlyingDisplay{
            switch identifier{
            case "backFromGermanStocks": underlyingDisplay.text = Underlyings.germanStocks.description
            case "backFromEuroStocks": underlyingDisplay.text = Underlyings.euroStocks.description
            case"backFromWorldStocks": underlyingDisplay.text = Underlyings.worldStocks.description
            default: underlyingDisplay.text = Underlyings.defaults.description
            }
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? UnderlyingVC{
            if let ppc = vc.popoverPresentationController{
                ppc.permittedArrowDirections = UIPopoverArrowDirection.Any
                ppc.delegate = self
//                var popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("UnderlyingVC") as! UIViewController
//                popoverContent.preferredContentSize = CGSize(width: 200, height: 300)
            }
        }
        
        if let identifier = segue.identifier {
            switch identifier{
            case storyBoard.SequeMessageCashOut:
                if let tvc = segue.destinationViewController as? MessageVC {
                    if let ppc = tvc.popoverPresentationController{
                        ppc.delegate = self
                    }
                    tvc.message = "Your cash-out order has been executed successfully !!"
                }
            default: break
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    @IBAction func cashOut(sender: UIButton) {
        
        DismissKeyboard()
        
        if (cashOutAmount.text == "all"){
            reductionAmount = recordOld.resultsT0.totalAsset
        }
        var reductionRatio = 1.0 - reductionAmount/recordOld.resultsT0.totalAsset
        recordOld.resultsT0.totalAsset = recordOld.resultsT0.totalAsset * reductionRatio
        recordOld.resultsT0.guaranteedPayout = recordOld.resultsT0.guaranteedPayout * reductionRatio
        
        if reductionAmount > 0 {
            recordOldT0Updated = calcEngine.updateT0(recordOld)
            displayRecord(recordOldT0Updated)
            storeEngine.storeRecord(recordOldT0Updated, userName: userName.text)
            
            let investNowConfirmAlert = UIAlertController(
                title: "Please confirm your order: Cash-out " + displayDouble(reductionAmount)+"€",
                message: "",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            let actionAgree = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: confirm)
            investNowConfirmAlert.addAction(actionAgree)
            
            let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            investNowConfirmAlert.addAction(actionCancel)
            
            presentViewController(investNowConfirmAlert, animated: true, completion: nil)
            
            cashOutAmount.text = "0"
            reductionAmount = 0
        }

    }
    

    private func getTimeToMaturity(record: Record)-> Double {
        let maturityStr = recordOld.userInfo.maturityDate
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let startDate = NSDate()
        let endDate = dateFormater.dateFromString(maturityStr)
        let cal = NSCalendar.currentCalendar()
//        let unit:NSCalendarUnit = .CalenderUnitDay
        let components = cal.components(NSCalendarUnit.CalendarUnitDay, fromDate: startDate, toDate: endDate!, options: nil)
        
        let timeToMaturityProxy = Double(components.day) / 365.0
        return timeToMaturityProxy
    }
    
    func confirm(alert: UIAlertAction!){
        let confirmAlert=UIAlertController(
            title: "Confirmation", message: "Your order has been excecuted sussccesfully", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let actionOk = UIAlertAction(title: "Continue to explore", style:UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) -> Void in println("do nothing")})
        confirmAlert.addAction(actionOk)

        let actionLogout = UIAlertAction(title: "Save & Logout", style:UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) -> Void in
            self.performSegueWithIdentifier("saveSessionLogOut", sender: self)})
        confirmAlert.addAction(actionLogout)

        
        presentViewController(confirmAlert, animated: true, completion: nil)
    }
    
    private func testConnectWebService(){
        var xmlText = "<?xml version=\"1.0\" standalone=\"yes\"?>        <inputParameters><parameter name=\"userID\" type=\"typedValue\">S\tFinSol_User</parameter></inputParameters>"
        let length = xmlText.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        
        var linkUrl = "http://65.52.141.177:5000/QwbWebService/Ergo/InitialPolicyInfo/"
        
        var url: NSURL = NSURL(string: linkUrl)!
        println(url)
        
        //        let request = NSURLRequest(URL: url)
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = xmlText.dataUsingEncoding(NSUTF8StringEncoding)
        request.setValue("text/xml", forHTTPHeaderField: "Content-Type")
        request.setValue(length.description, forHTTPHeaderField: "Content-Length")
        var response : AutoreleasingUnsafeMutablePointer <NSURLResponse?> = nil
        var err : NSErrorPointer = nil
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: err)
        //        (request, returningResponse: response, error: err)
        
        //        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
        //            {
        //            data, response, error in
        //
        //            if error != nil{
        //                println("error = \(error)")
        //                return
        //            }
        //
        //            println("response = \(response)")
        //
        //            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
        //            println("responseString = \(responseString)")
        //        }
        //        task.resume()
        
        //        var isOk = xmlText.writeToURL(imgURL, atomically: true, encoding: NSUTF8StringEncoding, error: nil)

    }
    
    @IBAction func investNow(sender: UIButton) {
        recordOld.resultsT0 = recordNew.resultsT1
        
        //storeEngine.storeRecord(recordOld, userName: userName.text)
        func saveSessionCompletion(res:String){
            println(res)
        }
        storeEngine.storeRecordWeb(recordOld, userName: userName.text, completion: saveSessionCompletion)
        loadAndUpdateT0(userName.text)
        
        
        let investNowConfirmAlert = UIAlertController(
            title: "General Investment Agreement",
            message: "Your are going to order a new investment of " + displayDouble(recordNew.triggerInfo.newInvSPEUR) + "€."+"\n Do you agree with the General Investment Agreement? \n(You can read the complete text of the General Investment Agreement under the link: ***)",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        let actionAgree = UIAlertAction(title: "Agree", style: UIAlertActionStyle.Default, handler: confirm)
        investNowConfirmAlert.addAction(actionAgree)
        
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        investNowConfirmAlert.addAction(actionCancel)
        
        presentViewController(investNowConfirmAlert, animated: true, completion: nil)

    }
    
    @IBAction func saveSession(sender: UIButton) {
//        storeEngine.storeRecord(recordOldT0Updated, userName: userName.text)
        func saveSessionCompletion(res:String){
            println(res)
        }
        storeEngine.storeRecordWeb(recordOldT0Updated, userName: userName.text, completion: saveSessionCompletion)
        loadAndUpdateT0(userName.text)
        performSegueWithIdentifier("saveSessionLogOut", sender: self)
    }
    
  
    @IBAction func simulate(sender: UIButton) {
        setInfo()
        
//        recordNew = calcEngine.simulate(recordOldT0Updated)
        
        func simulateCompletion(recordLocal:Record){
            recordNew = recordLocal
            displayRecord(recordNew)

        }
        calcEngine.simulateWeb(recordOldT0Updated, completion: simulateCompletion)
        
        DismissKeyboard()
        
    }
 
    private func setInfo(){
        recordOldT0Updated.userInfo.birthDate = birthDate.text!
        recordOldT0Updated.userInfo.maturityDate = maturityDate.text!
        recordOldT0Updated.userInfo.gender = gender.text!
        recordOldT0Updated.userInfo.communication = communication.text!
        recordOldT0Updated.userInfo.address = address.text!
        recordOldT0Updated.triggerInfo.newInvSPEUR = NSNumberFormatter().numberFromString(newInvSPEURInput.text!)!.doubleValue
        recordOldT0Updated.triggerInfo.newInvGLEUR = NSNumberFormatter().numberFromString(newInvGLEURInput.text!)!.doubleValue
    }
    
    private func displayRecordUserInfoPart(record: Record){
        birthDate.text = record.userInfo.birthDate
        maturityDate.text = record.userInfo.maturityDate
        gender.text = record.userInfo.gender
        communication.text = record.userInfo.communication
        address.text = record.userInfo.address
    }
    
    private func displayRecordT0Part(record:Record){
        fundAssetT0Display.text = displayDouble(record.resultsT0.fundAsset)
        guaranteeAssetT0Display.text = displayDouble(record.resultsT0.guaranteeAsset)
        totalAssetT0Display.text = displayDouble(record.resultsT0.totalAsset)
        guaranteedPayoutT0Display.text = displayDouble(record.resultsT0.guaranteedPayout)
        projectedPayoutT0Display.text = displayDouble(record.resultsT0.projectedPayout)
        
    }
    
    private func displayRecordTriggerInfoPart(record: Record){
        newInvSPEURInput.text = displayDouble(record.triggerInfo.newInvSPEUR)
        newInvGLEURInput.text = displayDouble(record.triggerInfo.newInvGLEUR)
    }
    
    private func displayRecord(record:Record){
        
        displayRecordUserInfoPart(record)
        
        displayRecordT0Part(record)
        
        fundAssetNewInvDisplay.text = displayDouble(record.resultsNewInv.fundAsset)
        guaranteeAssetNewInvDisplay.text = displayDouble(record.resultsNewInv.guaranteeAsset)
        totalAssetNewInvDisplay.text = displayDouble(record.resultsNewInv.totalAsset)
        guaranteedPayoutNewInvDisplay.text = displayDouble(record.resultsNewInv.guaranteedPayout)
        projectedPayoutNewInvDisplay.text = displayDouble(record.resultsNewInv.projectedPayout)
        
        fundAssetT1Display.text = displayDouble(record.resultsT1.fundAsset)
        guaranteeAssetT1Display.text = displayDouble(record.resultsT1.guaranteeAsset)
        totalAssetT1Display.text = displayDouble(record.resultsT1.totalAsset)
        guaranteedPayoutT1Display.text = displayDouble(record.resultsT1.guaranteedPayout)
        projectedPayoutT1Display.text = displayDouble(record.resultsT1.projectedPayout)
        
//        displayRecordTriggerInfoPart(record)
    }
    
    private func displayDouble(d:Double)-> String{
        var s:String = String(format:"%.1f", d)
        return s
    }
    
    override func shouldAutorotate() -> Bool {
        switch UIDevice.currentDevice().orientation {
        case .Portrait, .PortraitUpsideDown, .Unknown:
            return true
        default:
            return false
        }
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue) | Int(UIInterfaceOrientationMask.PortraitUpsideDown.rawValue)
    }
}
