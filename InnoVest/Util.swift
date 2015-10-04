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
        var paramBody = getRecordXmlBodyForSimulateRequest(record, valDateStr: valDateStr)
        var xmlText = XmlDefaults.xmlHead + XmlDefaults.inputParametersHead + paramBody + XmlDefaults.inputParametersTail
        return xmlText
    }
    
    static func getSaveSessionXmlRequest(record:Record, valDateStr: String, userID: String)->String
    {
        var paramBody = getRecordXmlBody(record, valDateStr: valDateStr, userID: userID)
        var xmlText = XmlDefaults.xmlHead + XmlDefaults.inputParametersHead + paramBody + XmlDefaults.inputParametersTail
        return xmlText
    }
    
    static func getRecordXmlBodyForSimulateRequest(record: Record, valDateStr: String)->String{
        var bodyXml = getXmlParamLine(SaveRecordFieldsEn.valuationDate, typeStr: "S", value: valDateStr)
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
        var bodyXml = getXmlParamLine(SaveRecordFieldsEn.valuationDate, typeStr: "S", value: valDateStr)
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
    //<parameter name="valuationDate" type="typedValue">S	2015-07-07</parameter>
    //<parameter name="underlyingMIF" type="typedValue">S	WorldStocks</parameter>
    //<parameter name="birthDate" type="typedValue">S	1977-08-01</parameter>
    //<parameter name="maturityDate" type="typedValue">S	2035-01-01</parameter>
    //<parameter name="fundAssetT0" type="typedValue">D	 80.8636329858427</parameter>
    //<parameter name="guaranteeAssetT0" type="typedValue">D	 16.7363670141572</parameter>
    //<parameter name="guaranteeLevelT0" type="typedValue">D	 100</parameter>
    //<parameter name="performanceT0" type="typedValue">D	 300.807226804884</parameter>
    //<parameter name="communicationMedia" type="typedValue">S	SMS</parameter>
    //<parameter name="address" type="typedValue">S	xxx</parameter>
    //<parameter name="userID" type="typedValue">S	n217665</parameter>
    //<parameter name="newSP" type="typedValue">D	 0</parameter>
    //<parameter name="guaranteeLevelNewSP" type="typedValue">D	 0</parameter>
    //<parameter name="triggerType" type="typedValue">S	Vertragsguthaben gestiegen um:</parameter>
    //<parameter name="triggerThreshold" type="typedValue">D	 0</parameter>
    
    
    static func getXmlParamLine(key: String, typeStr: String, value: String)-> String
    {
        let typedValue = typeStr + "\t" + value
        let xmlLine = XmlDefaults.parameterHead + key + XmlDefaults.parameterMid + typedValue + XmlDefaults.parameterTail
        return xmlLine
    }
    
    static func sendLoadRecordRequest(userName: String, completion: (recordLocal:Record)->Void)
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
        
        let url = StaticDefaults.urlLoadRecord
        
        Alamofire.request(.POST, url, parameters: Dictionary(), encoding: .Custom(custom)).responseString
            { (request, response, responseStr, error) in
                println(request)
                println(response)
                println(responseStr)
                println(error)
                Util.writeToDocumentsFile("LoadRecordRequest.xml", fileContent: responseStr!)
//                var param = self.proceedXMLText(strOut)
                let record = Util.xmlText2Record(responseStr!)
                completion(recordLocal: record)
        }

    }

    static func sendSimulateRequest(record:Record, valDate: String, completion: (recordLocal:Record)->Void)
    {
        let xmlTextContent = getSimulateXmlRequest(record, valDateStr: valDate)
        let custom: (URLRequestConvertible, [String: AnyObject]?) -> (NSURLRequest, NSError?) = {
            (URLRequest, parameters) in
            let mutableURLRequest = URLRequest.URLRequest.mutableCopy() as! NSMutableURLRequest
            mutableURLRequest.setValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            let data = (xmlTextContent as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            mutableURLRequest.HTTPBody = data
            return (mutableURLRequest, nil)
        }
        
        let url = StaticDefaults.urlSimulate
        
        Alamofire.request(.POST, url, parameters: Dictionary(), encoding: .Custom(custom)).responseString
            { (request, response, responseStr, error) in
                println(request)
                println(response)
                println(responseStr)
                println(error)
                Util.writeToDocumentsFile("SimulateRequest.xml", fileContent: xmlTextContent)
                Util.writeToDocumentsFile("SimulateResponse.xml", fileContent: responseStr!)

                //                var param = self.proceedXMLText(strOut)
                let record = Util.xmlText2Record(responseStr!)
                completion(recordLocal: record)
        }
        
    }

    
    static func sendSaveRecordRequest(record:Record, valDate: String, userName: String, completion: (res :String)->Void)
    {
        let xmlTextContent = getSaveSessionXmlRequest(record, valDateStr: valDate, userID: userName)
        let custom: (URLRequestConvertible, [String: AnyObject]?) -> (NSURLRequest, NSError?) = {
            (URLRequest, parameters) in
            let mutableURLRequest = URLRequest.URLRequest.mutableCopy() as! NSMutableURLRequest
            mutableURLRequest.setValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            let data = (xmlTextContent as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            mutableURLRequest.HTTPBody = data
            return (mutableURLRequest, nil)
        }
        
        let url = StaticDefaults.urlSaveRecord
        
        Alamofire.request(.POST, url, parameters: Dictionary(), encoding: .Custom(custom)).responseString
            { (request, response, responseStr, error) in
                println(request)
                println(response)
                println(responseStr)
                println(error)
                
                Util.writeToDocumentsFile("SaveSessionRequest.xml", fileContent: xmlTextContent)
                Util.writeToDocumentsFile("SaveSessionResponse.xml", fileContent: responseStr!)
                completion(res: responseStr!)
        }
        
    }
    
    
    static func xmlText2Param(xmlText:String) -> [String:String]{
        var param = [String:String]()
        var xml = SWXMLHash.parse(xmlText)
//        if let resultText = xml[Defaults.responseXmlLevel1][Defaults.responseXmlLevel2][Defaults.responseXmlLevel3].element?.text
        if let resultText = xml["qwbWebService"]["results"]["result"].element?.text
        {
            println(resultText)
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
        var lines = split(text){$0=="\n"}
        for line in lines
        {
            var words = split(line){$0=="\t"}
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

        var record = Record()
        
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
        var userInfo = UserInfo()
        userInfo.birthDate = param[RecordFieldsEN.birthDate]!
        userInfo.maturityDate = param[RecordFieldsEN.maturityDate]!
        userInfo.communication = param[RecordFieldsEN.communication]!
        userInfo.address = param[RecordFieldsEN.address]!
        
        return userInfo
    }
    
    static func param2resultsT0(param: [String: String])-> ResultsBase{
        var resultsT0 = ResultsBase()
        resultsT0.fundAsset = str2double(param[RecordFieldsEN.fundAssetT0]!)
        resultsT0.guaranteeAsset = str2double(param[RecordFieldsEN.guaranteeAssetT0]!)
        resultsT0.totalAsset = resultsT0.fundAsset + resultsT0.guaranteeAsset
        resultsT0.guaranteedPayout = str2double(param[RecordFieldsEN.guaranteedPayoutT0]!)
        resultsT0.projectedPayout = str2double(param[RecordFieldsEN.projectedPayoutT0]!)
        
        return resultsT0
    }
    
    static func param2resultsNewInv(param: [String: String])-> ResultsBase{
        var resultsNewInv = ResultsBase()
        resultsNewInv.fundAsset = str2double(param[RecordFieldsEN.fundAssetNewSP]!)
        resultsNewInv.guaranteeAsset = str2double(param[RecordFieldsEN.guaranteeAssetNewSP]!)
        resultsNewInv.totalAsset = resultsNewInv.fundAsset + resultsNewInv.guaranteeAsset
        resultsNewInv.guaranteedPayout = str2double(param[RecordFieldsEN.guaranteedPayoutNewSP]!)
        resultsNewInv.projectedPayout = str2double(param[RecordFieldsEN.projectedPayoutNewSP]!)
        
        return resultsNewInv
    }
    
    static func param2resultsT1(param: [String: String])-> ResultsBase{
        var resultsT1 = ResultsBase()
        resultsT1.fundAsset = str2double(param[RecordFieldsEN.fundAssetT1]!)
        resultsT1.guaranteeAsset = str2double(param[RecordFieldsEN.guaranteeAssetT1]!)
        resultsT1.totalAsset = resultsT1.fundAsset + resultsT1.guaranteeAsset
        resultsT1.guaranteedPayout = str2double(param[RecordFieldsEN.guaranteedPayoutT1]!)
        resultsT1.projectedPayout = str2double(param[RecordFieldsEN.projectedPayoutT1]!)
        
        return resultsT1
    }
    
    static func param2triggerInfo(param: [String: String])-> TriggerInfo{
        var triggerInfo = TriggerInfo()
        triggerInfo.newInvSPEUR = str2double(param[RecordFieldsEN.newInvSPEUR]!)
        triggerInfo.newInvGLEUR = str2double(param[RecordFieldsEN.newInvGLEUR]!)
//        triggerInfo.triggerType = param[RecordFieldsEN.]!
//        triggerInfo.triggerLevel = str2double(param["triggerLevel"]!)
        
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