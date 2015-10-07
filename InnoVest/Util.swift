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
    
    static func getSimulateXmlRequest(record:Record, valDateStr:String) -> String
    {
        let paramBody = getRecordXmlBodyForSimulateRequest(record, valDateStr: valDateStr)
        let xmlText = XmlDefaults.xmlHead + XmlDefaults.inputParametersHead + paramBody + XmlDefaults.inputParametersTail
        return xmlText
    }
    
    static func getRegisterNewAccountXmlRequest(record:Record, valDateStr: String, userID: String)->String
    {
        let paramBody = getRecordXmlBodyForRegisterNewAccountRequest(record, valDateStr: valDateStr, userID: userID)
        let xmlText = XmlDefaults.xmlHead + XmlDefaults.inputParametersHead + paramBody + XmlDefaults.inputParametersTail
        return xmlText
    }
    
    static func getSaveSessionXmlRequest(record:Record, valDateStr: String, userID: String)->String
    {
        let paramBody = getRecordXmlBody(record, valDateStr: valDateStr, userID: userID)
        let xmlText = XmlDefaults.xmlHead + XmlDefaults.inputParametersHead + paramBody + XmlDefaults.inputParametersTail
        return xmlText
    }
    
    static func getRecordXmlBodyForRegisterNewAccountRequest(record:Record, valDateStr:String, userID: String)->String
    {
        let bodyXml = getXmlParamLine(SaveRecordFieldsEn.valuationDate, typeStr: "S", value: valDateStr)
            + getXmlParamLine(SaveRecordFieldsEn.birthDate, typeStr: "S", value: record.userInfo.birthDate)
            + getXmlParamLine(SaveRecordFieldsEn.maturityDate, typeStr: "S", value: record.userInfo.maturityDate)
            + getXmlParamLine(SaveRecordFieldsEn.underlying, typeStr: "S", value: Record.defaultUnderlying)
            + getXmlParamLine(SaveRecordFieldsEn.communication, typeStr: "S", value: record.userInfo.communication)
            + getXmlParamLine(SaveRecordFieldsEn.address, typeStr: "S", value: record.userInfo.address)
            + getXmlParamLine(SaveRecordFieldsEn.userID, typeStr: "S", value: userID)
        return bodyXml
    }
    
    static func getRecordXmlBodyForSimulateRequest(record: Record, valDateStr: String)->String{
        let bodyXml = getXmlParamLine(SaveRecordFieldsEn.valuationDate, typeStr: "S", value: valDateStr)
            + getXmlParamLine(SaveRecordFieldsEn.birthDate, typeStr: "S", value: record.userInfo.birthDate)
            + getXmlParamLine(SaveRecordFieldsEn.maturityDate, typeStr: "S", value: record.userInfo.maturityDate)
            + getXmlParamLine(SaveRecordFieldsEn.underlying, typeStr: "S", value: Record.defaultUnderlying)
            
            + getXmlParamLine(SaveRecordFieldsEn.fundAssetT0, typeStr: "D", value: record.resultsT0.fundAsset.description)
            + getXmlParamLine(SaveRecordFieldsEn.guaranteeAssetT0, typeStr: "D", value: record.resultsT0.guaranteeAsset.description)
            + getXmlParamLine(SaveRecordFieldsEn.guaranteedPayoutT0, typeStr: "D", value: record.resultsT0.guaranteedPayout.description)
            
            + getXmlParamLine(SaveRecordFieldsEn.newInvSPEUR, typeStr: "D", value: record.triggerInfo.newInvSPEUR.description)
            + getXmlParamLine(SaveRecordFieldsEn.newInvGLEUR, typeStr: "D", value: record.triggerInfo.newInvGLEUR.description)
        
        return bodyXml
    
    }
    
    static func getRecordXmlBody(record: Record, valDateStr:String, userID: String) -> String
    {
        let bodyXml = getXmlParamLine(SaveRecordFieldsEn.valuationDate, typeStr: "S", value: valDateStr)
                    + getXmlParamLine(SaveRecordFieldsEn.userID, typeStr: "S", value: userID)
                    + getXmlParamLine(SaveRecordFieldsEn.birthDate, typeStr: "S", value: record.userInfo.birthDate)
                    + getXmlParamLine(SaveRecordFieldsEn.maturityDate, typeStr: "S", value: record.userInfo.maturityDate)
                    + getXmlParamLine(SaveRecordFieldsEn.underlying, typeStr: "S", value: Record.defaultUnderlying)
                    + getXmlParamLine(SaveRecordFieldsEn.communication, typeStr: "S", value: record.userInfo.communication)
                    + getXmlParamLine(SaveRecordFieldsEn.address, typeStr: "S", value: record.userInfo.address)
            
                    + getXmlParamLine(SaveRecordFieldsEn.fundAssetT0, typeStr: "D", value: record.resultsT0.fundAsset.description)
                    + getXmlParamLine(SaveRecordFieldsEn.guaranteeAssetT0, typeStr: "D", value: record.resultsT0.guaranteeAsset.description)
                    + getXmlParamLine(SaveRecordFieldsEn.guaranteedPayoutT0, typeStr: "D", value: record.resultsT0.guaranteedPayout.description)
                    + getXmlParamLine(SaveRecordFieldsEn.projectedPayoutT0, typeStr: "D", value: record.resultsT0.projectedPayout.description)
            
                    + getXmlParamLine(SaveRecordFieldsEn.newInvSPEUR, typeStr: "D", value: record.triggerInfo.newInvSPEUR.description)
                    + getXmlParamLine(SaveRecordFieldsEn.newInvGLEUR, typeStr: "D", value: record.triggerInfo.newInvGLEUR.description)
                    + getXmlParamLine(SaveRecordFieldsEn.triggerType, typeStr: "S", value: Record.defaultTriggerType)
                    + getXmlParamLine(SaveRecordFieldsEn.triggerThreshold, typeStr: "D", value: record.triggerInfo.triggerLevel.description)
        
        return bodyXml
    }
    
    static func getXmlParamLine(key: String, typeStr: String, value: String)-> String
    {
        let typedValue = typeStr + "\t" + value
        let xmlLine = XmlDefaults.parameterHead + key + XmlDefaults.parameterMid + typedValue + XmlDefaults.parameterTail
        return xmlLine
    }
    
    private static func getConnectionCustom(xmlTextContent:String)->((URLRequestConvertible, [String: AnyObject]?) -> (NSMutableURLRequest, NSError?)){
        let custom: (URLRequestConvertible, [String: AnyObject]?) -> (NSMutableURLRequest, NSError?) = {
            (URLRequest, parameters) in
            let mutableURLRequest = URLRequest.URLRequest.mutableCopy() as! NSMutableURLRequest
            mutableURLRequest.setValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            let data = (xmlTextContent as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            mutableURLRequest.HTTPBody = data
            return (mutableURLRequest, nil)
        }
        return custom
    }

    private static func printResponse(response:Response<String, NSError>, xmlRequest: String, fn:String){
        print(response.request)
        print(response.response)
        print(response.result.value)
        print(response.result.error)
        Util.writeToDocumentsFile(fn+"Request.xml", fileContent: xmlRequest)
        Util.writeToDocumentsFile(fn+"Response.xml", fileContent: response.result.value!)
    }
//    static func sendXmlRequest<T>(xmlTextContent:String, url:String, completion: <T>(res:T)->Void, debugFileNameStr:String){
//        let custom = getConnectionCustom(xmlTextContent)
//        Alamofire.request(.POST, url, parameters: Dictionary(), encoding: .Custom(custom)).responseString
//            { response in
//                print(response.request)
//                print(response.response)
//                print(response.result.value)
//                print(response.result.error)
//                
//                Util.writeToDocumentsFile(debugFileNameStr+"Request.xml", fileContent: xmlTextContent)
//                Util.writeToDocumentsFile(debugFileNameStr+"Response.xml", fileContent: response.result.value!)
//                completion(res: response.result.value!)
//        }
//    }
    
    static func sendSaveRecordRequest(record:Record, valDate: String, userName: String, completion: (res :String)->Void)
    {
        let xmlTextContent = getSaveSessionXmlRequest(record, valDateStr: valDate, userID: userName)
        
        
        let url = StaticDefaults.urlSaveRecord
        let custom = getConnectionCustom(xmlTextContent)
        Alamofire.request(.POST, url, parameters: Dictionary(), encoding: .Custom(custom)).responseString
            { response in
                printResponse(response, xmlRequest: xmlTextContent, fn: "SaveSession")
                completion(res: response.result.value!)
        }
        
    }
    
    static func sendLoadRecordRequest(userName: String, completion: (recordLocal:Record)->Void)
    {
        let xmlTextContent = getLoadUserRecordXmlRequest(userName)
        
        let url = StaticDefaults.urlLoadRecord
        let custom = getConnectionCustom(xmlTextContent)
        Alamofire.request(.POST, url, parameters: Dictionary(), encoding: .Custom(custom)).responseString
            { response in
                printResponse(response,xmlRequest: xmlTextContent,fn: "LocadRecord")
                let record = Util.xmlText2Record(response.result.value!)
                completion(recordLocal: record)
        }

    }

    static func sendSimulateRequest(record:Record, valDate: String, completion: (recordLocal:Record)->Void)
    {
        let xmlTextContent = getSimulateXmlRequest(record, valDateStr: valDate)
        let url = StaticDefaults.urlSimulate
        let custom = getConnectionCustom(xmlTextContent)
        Alamofire.request(.POST, url, parameters: Dictionary(), encoding: .Custom(custom)).responseString
            { response in
                printResponse(response, xmlRequest: xmlTextContent,fn: "Simulate")

                //                var param = self.proceedXMLText(strOut)
                let record = Util.xmlText2Record(response.result.value!)
                completion(recordLocal: record)
        }
        
    }

    
    static func sendRegisterNewAccountRequest(record:Record, valDate: String, userName: String, completion: (res :String)->Void)
    {
        let xmlTextContent = getRegisterNewAccountXmlRequest(record, valDateStr: valDate, userID: userName)
        
        let url = StaticDefaults.urlRegisterNewAccount
        let custom = getConnectionCustom(xmlTextContent)
        Alamofire.request(.POST, url, parameters: Dictionary(), encoding: .Custom(custom)).responseString
            { (response) in
                printResponse(response, xmlRequest: xmlTextContent,fn: "RegisterNewAccount")
                completion(res: response.result.value!)
        }
        
    }
    
    
    static func xmlText2Param(xmlText:String) -> [String:String]{
        var param = [String:String]()
        let xml = SWXMLHash.parse(xmlText)
//        if let resultText = xml[Defaults.responseXmlLevel1][Defaults.responseXmlLevel2][Defaults.responseXmlLevel3].element?.text
        if let resultText = xml["qwbWebService"]["results"]["result"].element?.text
        {
            print(resultText)
            param = text2Param(resultText)
        }
        return param
    }
    
    static func xmlText2Record(xmlText:String)->Record
    {
        let param = self.xmlText2Param(xmlText)
        let record = Util.param2record(param)
        return record
    }
    
    private static func text2Param(text:String)->[String:String]
    {
        var param = [String:String]()
        let lines = text.characters.split{$0=="\n"}.map { String($0) }
        for line in lines
        {
            var words = line.characters.split{$0=="\t"}.map { String($0) }
            if (words.count==1){
                param[words[0]]=""
            }else{
                param[words[0]]=words[1]
            }
        }
        
        return param
    }
    
    static func record2param(record:Record)->[String:String]{
        var out = [String: String]()

        //UserInfo
        out["UserInfo"]="yes"
        out[RecordFieldsEN.birthDate]=record.userInfo.birthDate
        out[RecordFieldsEN.maturityDate]=record.userInfo.maturityDate
        out[RecordFieldsEN.communication]=record.userInfo.communication
        out[RecordFieldsEN.address]=record.userInfo.address
        
        //ResultsT0
        out["ResultsT1"]="yes"
        out[RecordFieldsEN.fundAssetT0]=record.resultsT0.fundAsset.description
        out[RecordFieldsEN.guaranteeAssetT0]=record.resultsT0.guaranteeAsset.description
        out[RecordFieldsEN.totalAssetT0]=record.resultsT0.totalAsset.description
        out[RecordFieldsEN.guaranteedPayoutT0]=record.resultsT0.guaranteedPayout.description
        out[RecordFieldsEN.projectedPayoutT0]=record.resultsT0.projectedPayout.description
        
        //ResultsNewInv
        out["ResultsNewInv"]="yes"
        out[RecordFieldsEN.fundAssetNewSP]=record.resultsNewInv.fundAsset.description
        out[RecordFieldsEN.guaranteeAssetNewSP]=record.resultsNewInv.guaranteeAsset.description
        out[RecordFieldsEN.totalAssetNewSP]=record.resultsNewInv.totalAsset.description
        out[RecordFieldsEN.guaranteedPayoutNewSP]=record.resultsNewInv.guaranteedPayout.description
        out[RecordFieldsEN.projectedPayoutNewSP]=record.resultsNewInv.projectedPayout.description

        //ResultsT1
        out["ResultsT1"]="yes"
        out[RecordFieldsEN.fundAssetT1]=record.resultsT1.fundAsset.description
        out[RecordFieldsEN.guaranteeAssetT1]=record.resultsT1.guaranteeAsset.description
        out[RecordFieldsEN.totalAssetT1]=record.resultsT1.totalAsset.description
        out[RecordFieldsEN.guaranteedPayoutT1]=record.resultsT1.guaranteedPayout.description
        out[RecordFieldsEN.projectedPayoutT1]=record.resultsT1.projectedPayout.description
        
        
        //TriggerInfo
        out["TriggerInfo"]="yes"
        out[RecordFieldsEN.newInvSPEUR]=record.triggerInfo.newInvSPEUR.description
        out[RecordFieldsEN.newInvGLEUR]=record.triggerInfo.newInvGLEUR.description
//        out[RecordFieldsEN.]=record.triggerInfo.triggerType
//        out["triggerLevel"]=record.triggerInfo.triggerLevel.description
        
        return out
    }
    
    static func param2record(param: [String:String])->Record{

        let record = Record()
        
        //UserInfo
        if param[RecordFieldsEN.userInfoTitle] == "yes"
        {
            record.userInfo = param2userInfo(param)
        }
        
        //ResultsT0
        if param[RecordFieldsEN.resultsT0Title]=="yes"
        {
            record.resultsT0 = param2resultsT0(param)
        }
        
        //ResultsNewInv
        if param[RecordFieldsEN.resultsNewSPTitle]=="yes"
        {
            record.resultsNewInv = param2resultsNewInv(param)
        }
        
        //ResultsT1
        if param[RecordFieldsEN.resultsT1Title]=="yes"
        {
            record.resultsT1 = param2resultsT1(param)
        }
        
        
        //TriggerInfo
        if param[RecordFieldsEN.triggerSetupTitle]=="yes"
        {
            record.triggerInfo = param2triggerInfo(param)
        }

        
        
        return record
    }
    
    static func str2double(s:String)-> Double{
        //        return NSNumberFormatter().numberFromString(s)!.doubleValue
        return (s as NSString).doubleValue
    }
    

    static func param2userInfo(param: [String: String])-> UserInfo{
        let userInfo = UserInfo()
        userInfo.birthDate = param[RecordFieldsEN.birthDate]!
        userInfo.maturityDate = param[RecordFieldsEN.maturityDate]!
        userInfo.communication = param[RecordFieldsEN.communication]!
        userInfo.address = param[RecordFieldsEN.address]!
        
        return userInfo
    }
    
    static func param2resultsT0(param: [String: String])-> ResultsBase{
        let resultsT0 = ResultsBase()
        resultsT0.fundAsset = str2double(param[RecordFieldsEN.fundAssetT0]!)
        resultsT0.guaranteeAsset = str2double(param[RecordFieldsEN.guaranteeAssetT0]!)
        resultsT0.totalAsset = resultsT0.fundAsset + resultsT0.guaranteeAsset
        resultsT0.guaranteedPayout = str2double(param[RecordFieldsEN.guaranteedPayoutT0]!)
        resultsT0.projectedPayout = str2double(param[RecordFieldsEN.projectedPayoutT0]!)
        
        return resultsT0
    }
    
    static func param2resultsNewInv(param: [String: String])-> ResultsBase{
        let resultsNewInv = ResultsBase()
        resultsNewInv.fundAsset = str2double(param[RecordFieldsEN.fundAssetNewSP]!)
        resultsNewInv.guaranteeAsset = str2double(param[RecordFieldsEN.guaranteeAssetNewSP]!)
        resultsNewInv.totalAsset = resultsNewInv.fundAsset + resultsNewInv.guaranteeAsset
        resultsNewInv.guaranteedPayout = str2double(param[RecordFieldsEN.guaranteedPayoutNewSP]!)
        resultsNewInv.projectedPayout = str2double(param[RecordFieldsEN.projectedPayoutNewSP]!)
        
        return resultsNewInv
    }
    
    static func param2resultsT1(param: [String: String])-> ResultsBase{
        let resultsT1 = ResultsBase()
        resultsT1.fundAsset = str2double(param[RecordFieldsEN.fundAssetT1]!)
        resultsT1.guaranteeAsset = str2double(param[RecordFieldsEN.guaranteeAssetT1]!)
        resultsT1.totalAsset = resultsT1.fundAsset + resultsT1.guaranteeAsset
        resultsT1.guaranteedPayout = str2double(param[RecordFieldsEN.guaranteedPayoutT1]!)
        resultsT1.projectedPayout = str2double(param[RecordFieldsEN.projectedPayoutT1]!)
        
        return resultsT1
    }
    
    static func param2triggerInfo(param: [String: String])-> TriggerInfo{
        let triggerInfo = TriggerInfo()
        triggerInfo.newInvSPEUR = str2double(param[RecordFieldsEN.newInvSPEUR]!)
        triggerInfo.newInvGLEUR = str2double(param[RecordFieldsEN.newInvGLEUR]!)
//        triggerInfo.triggerType = param[RecordFieldsEN.]!
//        triggerInfo.triggerLevel = str2double(param["triggerLevel"]!)
        
        return triggerInfo
    }
    
    static func writeToDocumentsFile(fileName:String,fileContent:String) {
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true){
            let dir = dirs[0] //documents directory
            let path = (dir as NSString).stringByAppendingPathComponent(fileName);
            print("path = " + path)
            do {
                //writing
                try fileContent.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
            } catch _ {
            };
            
        }
    }
    
    static func date2str(date: NSDate)-> String
    {
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormater.stringFromDate(date)
        return dateStr
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