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
    
    
    @IBOutlet weak var underlyingButton: UIButton!
    @IBOutlet weak var valDateField: UITextField!
    
    
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
    let actInd = ActivityIndicatorUtil()

    var valDate = NSDate()
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
            //storeEngine.storeRecord(recordNewAccount, userName: userName.text!)
            store(recordNewAccount, valDate: valDate)
            defaults.removeObjectForKey("recordNewAccount")
        }
        
        
        load(userName.text!, valDate: valDate)
        
        cashOutAmount.placeholder = "0"
        
        //        valDate = NSDate()
        //        let nowStr = Util.date2str(valDate)
        //valDateField.placeholder = "2015-01-01"
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
        self.newInvSPEURInput.delegate = self
        self.newInvGLEURInput.delegate = self
        self.cashOutAmount.delegate = self
        self.userName.delegate = self
        
    }
    
    
    /**
     feature "load"
     */
    @IBAction func loadAndUpdateT0(sender: UIButton) {
        load(userName.text!, valDate: valDate)
    }

    
    /**
     feature "cash-out"
     */
    @IBAction func cashOut(sender: UIButton) {
        
        DismissKeyboard()
        
        let investNowConfirmAlert = UIAlertController(
                title: "Please confirm your order: Cash-out " + displayDouble(reductionAmount)+"€",
                message: "",
                preferredStyle: UIAlertControllerStyle.Alert
        )
        let actionAgree = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: conductCashOut)
        investNowConfirmAlert.addAction(actionAgree)
            
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        investNowConfirmAlert.addAction(actionCancel)
            
        presentViewController(investNowConfirmAlert, animated: true, completion: nil)

    }

    func conductCashOut(alert: UIAlertAction!)
    {
        if (cashOutAmount.text == "all"){
            reductionAmount = recordOld.resultsT0.totalAsset
        }
        
        if reductionAmount > 0
        {
        
        let reductionRatio = 1.0 - reductionAmount/recordOld.resultsT0.totalAsset
        recordOld.resultsT0.totalAsset = recordOld.resultsT0.totalAsset * reductionRatio
        recordOld.resultsT0.fundAsset = recordOld.resultsT0.fundAsset * reductionRatio
        recordOld.resultsT0.guaranteeAsset = recordOld.resultsT0.guaranteeAsset * reductionRatio
        recordOld.resultsT0.guaranteedPayout = recordOld.resultsT0.guaranteedPayout * reductionRatio

        func simulateCompletion(recordLocal:Record){
            recordOldT0Updated.resultsT0 = recordLocal.resultsT1
            displayRecord(recordOldT0Updated)
            store(recordOldT0Updated, valDate:valDate)
            actInd.hideActivityIndicator(self.view)
            confirm(alert)
        }
        actInd.showActivityIndicator(self.view)
        recordOld.triggerInfo = TriggerInfo()
            calcEngine.simulateWeb(recordOld, valDate: valDate, completion: simulateCompletion)

        cashOutAmount.text = "0"
        reductionAmount = 0
        }
    }
    
    /**
     feature "Simulate/Illustrate"
     */
    @IBAction func simulate(sender: UIButton) {
        DismissKeyboard()
        setInfo()
        func simulateCompletion(recordLocal:Record){
            recordNew = recordLocal
            displayRecord(recordNew)
            actInd.hideActivityIndicator(self.view)
        }
        actInd.showActivityIndicator(self.view)
        calcEngine.simulateWeb(recordOldT0Updated, valDate: valDate, completion: simulateCompletion)
    }
    
    
    /**
     feature "Invest-Now"
    */
    @IBAction func investNow(sender: UIButton) {
        
        
        let investNowConfirmAlert = UIAlertController(
            title: "General Investment Agreement",
            message: "Your are going to order a new investment of " + displayDouble(recordNew.triggerInfo.newInvSPEUR) + "€."+"\n Do you agree with the General Investment Agreement? \n(You can read the complete text of the General Investment Agreement under the link: ***)",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        let actionAgree = UIAlertAction(title: "Agree", style: UIAlertActionStyle.Default, handler: investNowConfirmed)
        investNowConfirmAlert.addAction(actionAgree)
        
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        investNowConfirmAlert.addAction(actionCancel)
        
        presentViewController(investNowConfirmAlert, animated: true, completion: nil)
        
    }
    
    func conductInvestNow()
    {
        recordOldT0Updated.resultsT0 = recordNew.resultsT1  // in a later version, T0 record should be update at this place
        store(recordOldT0Updated, valDate: valDate)
        load(userName.text!, valDate: valDate)
    }
    
    /**
     feature "Save-Session"
    */
    @IBAction func saveSession(sender: UIButton) {
        store(recordOldT0Updated, valDate: valDate)
        load(userName.text!, valDate: valDate)
        Util.writeToDocumentsFile(StaticDefaults.lastLoginFN, fileContent: userName.text!)
        performSegueWithIdentifier("saveSessionLogOut", sender: self)
    }



    private func store(recordToStore: Record, valDate: NSDate){
        if userName.text == StaticDefaults.playaroundAccountName {  // playaround account will be stored locally
            storeEngine.storeRecord(recordToStore, valDate: valDate, userName: userName.text!)
        }else{
            func saveSessionCompletion(res:String){
                print(res)
                actInd.hideActivityIndicator(self.view)
            }
            actInd.showActivityIndicator(self.view)
            storeEngine.storeRecordWeb(recordToStore, valDate: valDate, userName: userName.text!, completion: saveSessionCompletion)
            
        }
    }
    
    
    private func load(id : String, valDate: NSDate)->Record{
        var record = Record()
        if userName.text == StaticDefaults.playaroundAccountName   // playaround account will be stored locally
        {
            self.recordOld = storeEngine.loadRecord(id)
            self.recordOldT0Updated = self.recordOld
            displayRecord(self.recordOldT0Updated)
        }
        else
        {
            func completionLoadRecordWeb(recordLocal:Record)->Void{
                self.recordOld = recordLocal
                calcEngine.timeToMaturity = getTimeToMaturity(recordOld)
                //            recordOldT0Updated = calcEngine.updateT0(recordOld)    // temporary no update necessary, since no market data update yet.
                self.recordOldT0Updated = self.recordOld
                displayRecord(self.recordOldT0Updated)
                actInd.hideActivityIndicator(self.view)
            }
            actInd.showActivityIndicator(self.view)
            storeEngine.loadRecordWeb(id, valDate: valDate, completion: completionLoadRecordWeb)
        }
        return record
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
        reductionAmount = min(recordOld.resultsT0.totalAsset, Util.str2double(cashOutAmount.text!))
        cashOutAmount.text = reductionAmount.description
        }
    }
    
    @IBAction func editNewInvestment(sender: UITextField) {
        recordOldT0Updated.triggerInfo.newInvSPEUR = NSNumberFormatter().numberFromString(sender.text!)!.doubleValue
    }

    @IBAction func editNewInvGL(sender: UITextField) {
        recordOldT0Updated.triggerInfo.newInvGLEUR = NSNumberFormatter().numberFromString(sender.text!)!.doubleValue
    }

    @IBAction func editValDate(sender: UITextField) {
//        valDate = Util.str2Date(sender.text!)
    }
    
    @IBAction func editValDateBegin(sender: UITextField) {
//        var customView:UIView = UIView(frame: CGRectMake(0, 100, 320, 160))
//        customView.backgroundColor = UIColor.clearColor()
//        
//        var datePicker:UIDatePicker
//        datePicker = UIDatePicker(frame: CGRectMake(0, 0, 320, 160))
//        datePicker.datePickerMode = UIDatePickerMode.Date
//        
//        
//        customView.addSubview(datePicker)
//        valDateField.inputView = customView
//        var doneButton:UIButton = UIButton (frame: CGRectMake(100, 100, 100, 44))
//        doneButton.setTitle("Done", forState: UIControlState.Normal)
//        doneButton.addTarget(self, action: "datePickerSelected", forControlEvents: UIControlEvents.TouchUpInside)
//        doneButton.backgroundColor = UIColor .grayColor()
//        valDateField.inputAccessoryView = doneButton
    }
    
    
    @IBAction func segueToUnderlying(sender: UIButton) {
        performSegueWithIdentifier("showUnderlying", sender: self)
    }
    
    @IBAction func goBack(segue: UIStoryboardSegue){
        let identifier = segue.identifier!
            switch identifier{
            case "backFromGermanStocks": underlyingButton.setTitle(Underlyings.germanStocks.description, forState: .Normal)
            case "backFromEuroStocks": underlyingButton.setTitle(Underlyings.euroStocks.description, forState: .Normal)
            case"backFromWorldStocks": underlyingButton.setTitle(Underlyings.worldStocks.description, forState: .Normal)
            default: underlyingButton.setTitle(Underlyings.defaults.description, forState: .Normal)
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
    
    

    private func getTimeToMaturity(record: Record)-> Double {
        let maturityStr = recordOld.userInfo.maturityDate
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let startDate = NSDate()
        let endDate = dateFormater.dateFromString(maturityStr)
        let cal = NSCalendar.currentCalendar()
//        let unit:NSCalendarUnit = .CalenderUnitDay
        let components = cal.components(NSCalendarUnit.Day, fromDate: startDate, toDate: endDate!, options: [])
        
        let timeToMaturityProxy = Double(components.day) / 365.0
        return timeToMaturityProxy
    }
    
    
    func investNowConfirmed(alert: UIAlertAction!)
    {
        conductInvestNow()
        confirm(alert)
    }
    
    func confirm(alert: UIAlertAction!){
        let confirmAlert=UIAlertController(
            title: "Confirmation", message: "Your order has been excecuted sussccesfully", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let actionOk = UIAlertAction(title: "Continue to explore", style:UIAlertActionStyle.Default, handler: {(action: UIAlertAction) -> Void in print("do nothing")})
        confirmAlert.addAction(actionOk)

        let actionLogout = UIAlertAction(title: "Save & Logout", style:UIAlertActionStyle.Default, handler: {(action:UIAlertAction) -> Void in
            self.performSegueWithIdentifier("saveSessionLogOut", sender: self)})
        confirmAlert.addAction(actionLogout)

        
        presentViewController(confirmAlert, animated: true, completion: nil)
    }
    
    private static func testConnectWebService(){
        let xmlText = "<?xml version=\"1.0\" standalone=\"yes\"?>        <inputParameters><parameter name=\"userID\" type=\"typedValue\">S\tFinSol_User</parameter></inputParameters>"
        let length = xmlText.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        
        let linkUrl = "http://65.52.141.177:5000/QwbWebService/Ergo/InitialPolicyInfo/"
        
        let url: NSURL = NSURL(string: linkUrl)!
        print(url)
        
        //        let request = NSURLRequest(URL: url)
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = xmlText.dataUsingEncoding(NSUTF8StringEncoding)
        request.setValue("text/xml", forHTTPHeaderField: "Content-Type")
        request.setValue(length.description, forHTTPHeaderField: "Content-Length")
        let response : AutoreleasingUnsafeMutablePointer <NSURLResponse?> = nil
        let err : NSErrorPointer = nil
        var data: NSData?
        do {
            data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
        } catch let error as NSError {
            err.memory = error
            data = nil
        }
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
        let s:String = String(format:"%.1f", d)
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
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait  }
    
    
}
