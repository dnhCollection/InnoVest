//
//  Util.swift
//  InsuranceInvestSingleView
//
//  Created by chendong.xiaohong on 2015-08-31.
//  Copyright (c) 2015 dd. All rights reserved.
//

import Foundation
import Alamofire


class Util{
    
    static func getLoadUserRecordXmlRequest(userName: String) -> String
    {
        let xmlTemplate1 = "<?xml version=\"1.0\" standalone=\"yes\"?>        <inputParameters><parameter name=\"userID\" type=\"typedValue\">S\t"
        let xmlTemplate2 = "</parameter></inputParameters>"
        
        let xmlRequestStr = xmlTemplate1 + userName + xmlTemplate2
        return xmlRequestStr
    }
    
    static func sendLoadRecordRequest(userName: String, completion: (result:String)->Void)
    {
        let xmlTextContent = getLoadUserRecordXmlRequest(userName)
        let custom: (URLRequestConvertible, [String: AnyObject]?) -> (NSURLRequest, NSError?) = {
            (URLRequest, parameters) in
            let mutableURLRequest = URLRequest.URLRequest.mutableCopy() as! NSMutableURLRequest
            mutableURLRequest.setValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            let data = (xmlTextContent as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            mutableURLRequest.HTTPBody = data
            return (mutableURLRequest, nil)
        }
        
        let url = Defaults.urlLoadRecord
        
        Alamofire.request(.POST, url, parameters: Dictionary(), encoding: .Custom(custom)).responseString
            { (request, response, responseStr, error) in
                println(request)
                println(response)
                println(responseStr)
                println(error)
//                Util.writeToDocumentsFile("UserRecord.xml", fileContent: string!)
//                var param = self.proceedXMLText(strOut)
                completion(result:responseStr!)
        }

    }
    
    private static func proceedXMLText(xmlText:String) -> [String:String]{
        var param = [String:String]()
        var xml = SWXMLHash.parse(xmlText)
        if let resultText = xml[Defaults.responseXmlLevel1][Defaults.responseXmlLevel2][Defaults.responseXmlLevel3].element?.text
        {
            println(resultText)
            param = text2Param(resultText)
        }
        return param
    }
    
    private static func proceedXMLText(xmlText:String)->Record
    {
        let param = self.proceedXMLText(xmlText)
        let record = Util.param2record(param)
        return record
    }
    
    private static func text2Param(text:String)->[String:String]
    {
        var param = [String:String]()
        var lines = split(text){$0=="\n"}
        for line in lines
        {
            var words = split(line){$0=="\t"}
            param[words[0]]=words[1]
        }
        
        return param
    }
    
    static func record2param(record:Record)->[String:String]{
        var out = [String: String]()

        //UserInfo
        out["UserInfo"]="yes"
        out["birthDate"]=record.userInfo.birthDate
        out["maturityDate"]=record.userInfo.maturityDate
        out["communication"]=record.userInfo.communication
        out["address"]=record.userInfo.address
        
        //ResultsNewInv
        out["ResultsT1"]="yes"
        out["fundAssetT0"]=record.resultsT0.fundAsset.description
        out["guarantneeAssetT0"]=record.resultsT0.guaranteeAsset.description
        out["totalAssetT0"]=record.resultsT0.totalAsset.description
        out["guaranteedPayoutT0"]=record.resultsT0.guaranteedPayout.description
        out["projectedPayoutT0"]=record.resultsT0.projectedPayout.description
        
        //ResultsNewInv
        out["ResultsNewInv"]="yes"
        out["fundAssetNewInv"]=record.resultsNewInv.fundAsset.description
        out["guarantneeAssetNewInv"]=record.resultsNewInv.guaranteeAsset.description
        out["totalAssetNewInv"]=record.resultsNewInv.totalAsset.description
        out["guaranteedPayoutNewInv"]=record.resultsNewInv.guaranteedPayout.description
        out["projectedPayoutNewInv"]=record.resultsNewInv.projectedPayout.description

        //ResultsT1
        out["ResultsT1"]="yes"
        out["fundAssetT1"]=record.resultsT1.fundAsset.description
        out["guarantneeAssetT1"]=record.resultsT1.guaranteeAsset.description
        out["totalAssetT1"]=record.resultsT1.totalAsset.description
        out["guaranteedPayoutT1"]=record.resultsT1.guaranteedPayout.description
        out["projectedPayoutT1"]=record.resultsT1.projectedPayout.description
        
        
        //TriggerInfo
        out["TriggerInfo"]="yes"
        out["newInvSPEUR"]=record.triggerInfo.newInvSPEUR.description
        out["newInvGLEUR"]=record.triggerInfo.newInvGLEUR.description
        out["triggerType"]=record.triggerInfo.triggerType
        out["triggerLevel"]=record.triggerInfo.triggerLevel.description
        
        return out
    }
    
    static func param2record(param: [String:String])->Record{

        var record = Record()
        
        //UserInfo
//        param["UserInfo"]="yes"
        record.userInfo = param2userInfo(param)
        
        //ResultsT0
//        param["ResultsT0"]="yes"
        record.resultsT0 = param2resultsT0(param)
        
        //ResultsNewInv
//        param["ResultsNewInv"]="yes"
        record.resultsNewInv = param2resultsNewInv(param)
        
        //ResultsT1
//        out["ResultsT1"]="yes"
        record.resultsT1 = param2resultsT1(param)
        
        //TriggerInfo
//        out["TriggerInfo"]="yes"
        record.triggerInfo = param2triggerInfo(param)
        
        
        return record
    }
    
    static func str2double(s:String)-> Double{
        //        return NSNumberFormatter().numberFromString(s)!.doubleValue
        return (s as NSString).doubleValue
    }
    

    static func param2userInfo(param: [String: String])-> UserInfo{
        var userInfo = UserInfo()
        userInfo.birthDate = param["birthDate"]!
        userInfo.maturityDate = param["maturityDate"]!
        userInfo.communication = param["communication"]!
        userInfo.address = param["address"]!
        
        return userInfo
    }
    
    static func param2resultsT0(param: [String: String])-> ResultsBase{
        var resultsT0 = ResultsBase()
        resultsT0.fundAsset = str2double(param["fundAssetT0"]!)
        resultsT0.guaranteeAsset = str2double(param["guarantneeAssetT0"]!)
        resultsT0.totalAsset = str2double(param["totalAssetT0"]!)
        resultsT0.guaranteedPayout = str2double(param["guaranteedPayoutT0"]!)
        resultsT0.projectedPayout = str2double(param["projectedPayoutT0"]!)
        
        return resultsT0
    }
    
    static func param2resultsNewInv(param: [String: String])-> ResultsBase{
        var resultsNewInv = ResultsBase()
        resultsNewInv.fundAsset = str2double(param["fundAssetNewInv"]!)
        resultsNewInv.guaranteeAsset = str2double(param["guarantneeAssetNewInv"]!)
        resultsNewInv.totalAsset = str2double(param["totalAssetNewInv"]!)
        resultsNewInv.guaranteedPayout = str2double(param["guaranteedPayoutNewInv"]!)
        resultsNewInv.projectedPayout = str2double(param["projectedPayoutNewInv"]!)
        
        return resultsNewInv
    }
    
    static func param2resultsT1(param: [String: String])-> ResultsBase{
        var resultsT1 = ResultsBase()
        resultsT1.fundAsset = str2double(param["fundAssetT1"]!)
        resultsT1.guaranteeAsset = str2double(param["guarantneeAssetT1"]!)
        resultsT1.totalAsset = str2double(param["totalAssetT1"]!)
        resultsT1.guaranteedPayout = str2double(param["guaranteedPayoutT1"]!)
        resultsT1.projectedPayout = str2double(param["projectedPayoutT1"]!)
        
        return resultsT1
    }
    
    static func param2triggerInfo(param: [String: String])-> TriggerInfo{
        var triggerInfo = TriggerInfo()
        triggerInfo.newInvSPEUR = str2double(param["newInvSPEUR"]!)
        triggerInfo.newInvGLEUR = str2double(param["newInvGLEUR"]!)
        triggerInfo.triggerType = param["triggerType"]!
        triggerInfo.triggerLevel = str2double(param["triggerLevel"]!)
        
        return triggerInfo
    }
    
    static func writeToDocumentsFile(fileName:String,fileContent:String) {
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
            let dir = dirs[0] //documents directory
            let path = dir.stringByAppendingPathComponent(fileName);
            println("path = " + path)
            //writing
            fileContent.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil);
            
        }
    }
}

//var newInvSPEUR = 0.0
//var newInvGLEUR = 0.0
//var triggerType = "xxx"
//var triggerLevel = 0.0


//var birthDate = "1970-01-01"
//var maturityDate = "2040-01-01"
//var communication = "SMS"
//var address = "01780000000"