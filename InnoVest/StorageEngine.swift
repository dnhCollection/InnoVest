//
//  StorageEngine.swift
//  InsuranceInvestSingleView
//
//  Created by chendong.xiaohong on 2015-09-04.
//  Copyright (c) 2015 dd. All rights reserved.
//

import Foundation

class StorageEngine {

    let isWebService = false
    var record = Record()
    var timeStemp = "2015-09-01"
    
    func loadRecord() -> Record{
        
        return record
    }

    func loadRecord(userName: String)->Record{
        
        if isWebService{
            record = getRecordWeb(userName)
        }else{
            record = getRecordLocal(userName)
        }
        return record
    }

    
    func loadRecordWeb(userName: String, valDate: NSDate, completion:(recordLocal:Record)->Void){
        let valDateStr = Util.date2str(valDate)
        Util.sendLoadRecordRequest(userName, valDateStr: valDateStr, completion: completion)
    }
    
    func registerNewAccountWeb(record: Record, userName: String, completion:(res:String)->Void){
        let valDateStr = Util.date2str() // today-now
        Util.sendRegisterNewAccountRequest(record, valDateStr:valDateStr, userName: userName, completion: completion)
    }
    
    func storeRecordWeb(record: Record, valDate:NSDate, userName: String, completion:(res:String)->Void){
        let valDateStr = Util.date2str(valDate)
        Util.sendSaveRecordRequest(record, valDateStr: valDateStr, userName: userName, completion: completion)
    }
    
    func storeRecord(recordIn: Record, valDate: NSDate, userName : String){
        storeRecordInSession(recordIn)
        func completion(res:String){
            print(res)
        }
        if isWebService{
            storeRecordWeb(recordIn, valDate: valDate, userName: userName, completion: completion)
        }
        else{
            storeRecordLocal(recordIn, userName: userName)
        }
    }
    
    func getRecordLocal(userName: String)->Record{
        let fileContent = Util.readFromDocumentsFile(userName)
        if fileContent != "read file NOK"{
            let record = file2record(fileContent)
            return record
        }else{
            let record = Record()
            storeRecord(record, valDate:NSDate(), userName: userName)
            return record
        }
    }
    
    func storeRecordInSession(recordIn: Record) {
        timeStemp = getTodayTimeStemp()
        record = recordIn
    }
    
    
    func storeRecordLocal(recordIn: Record, userName : String){
        timeStemp = getTodayTimeStemp()
        // save record to local file system
        
        let fn = userName + ".txt"
        let fileContent = record2file(recordIn)
        
        Util.writeToDocumentsFile(fn, fileContent: fileContent)
    }

    
    func getRecordWeb(userName: String)->Record{
        let record = Record()
        return record
    }

    
    func record2file(record: Record)-> String{
        var fileContent = "timeStemp"+","+getTodayTimeStemp()+","
        
        fileContent = fileContent + "birthDate," + record.userInfo.birthDate + ","
        fileContent = fileContent + "maturityDate," + record.userInfo.maturityDate + ","
        fileContent = fileContent + "gender," + record.userInfo.gender + ","
        fileContent = fileContent + "communication," + record.userInfo.communication + ","
        fileContent = fileContent + "address," + record.userInfo.address + ","
        
        fileContent = fileContent + "fundAssetT0," + record.resultsT0.fundAsset.description + ","
        fileContent = fileContent + "guaranteeAssetT0," + record.resultsT0.guaranteeAsset.description + ","
        fileContent = fileContent + "guaranteedPayoutT0," + record.resultsT0.guaranteedPayout.description + ","
        fileContent = fileContent + "projectedPayoutT0," + record.resultsT0.projectedPayout.description + ","
        
        fileContent = fileContent + "\n"
        
        return fileContent
        }

    func file2record(fileContent: String)-> Record{
        
        let record = Record()
        
        let components = fileContent.componentsSeparatedByString(",")
        
        for ind in 1...components.count{
            switch components[ind-1] {
                case "birthDate": record.userInfo.birthDate = components[ind]
                case "maturityDate": record.userInfo.maturityDate = components[ind]
                case "gender": record.userInfo.gender = components[ind]
                case "communication": record.userInfo.communication = components[ind]
                case "address": record.userInfo.address = components[ind]
                
                case "fundAssetT0": record.resultsT0.fundAsset = Util.str2double(components[ind])
                case "guaranteeAssetT0": record.resultsT0.guaranteeAsset = Util.str2double(components[ind])
                case "guaranteedPayoutT0": record.resultsT0.guaranteedPayout = Util.str2double(components[ind])
                case "projectedPayoutT0": record.resultsT0.projectedPayout = Util.str2double(components[ind])
            
            default : print("content")
            }
            
            
        }
        record.resultsT0.totalAsset = record.resultsT0.fundAsset + record.resultsT0.guaranteeAsset
        return record
    }
    
    func getTodayTimeStemp()->String{
        let unique = NSDate.timeIntervalSinceReferenceDate()
        
        return unique.description
    }
    
    
    

}
