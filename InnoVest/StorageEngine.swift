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

    
    func loadRecordWeb(userName: String, completion:(recordLocal:Record)->Void){
        Util.sendLoadRecordRequest(userName, completion: completion)
    }
    
    func storeRecordWeb(record: Record, userName: String, completion:(res:String)->Void){
        let valDate = Util.date2str(NSDate())
        Util.sendSaveRecordRequest(record, valDate: valDate, userName: userName, completion: completion)
    }
    
    func storeRecord(recordIn: Record, userName : String){
        storeRecordInSession(recordIn)
        func completion(res:String){
            println(res)
        }
        if isWebService{
            storeRecordWeb(recordIn, userName: userName, completion: completion)
        }
        else{
            storeRecordLocal(recordIn, userName: userName)
        }
    }
    
    func getRecordLocal(userName: String)->Record{
        var fileContent = readFromDocumentsFile(userName)
        if fileContent != "read file NOK"{
            var record = file2record(fileContent)
            return record
        }else{
            var record = Record()
            storeRecord(record, userName: userName)
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
        
        var fn = userName + ".txt"
        var fileContent = record2file(recordIn)
        
        Util.writeToDocumentsFile(fn, fileContent: fileContent)
    }

    
    func getRecordWeb(userName: String)->Record{
        var record = Record()
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
        
        var record = Record()
        
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
            
            default : println("content")
            }
            
            
        }
        record.resultsT0.totalAsset = record.resultsT0.fundAsset + record.resultsT0.guaranteeAsset
        return record
    }
    
    func getTodayTimeStemp()->String{
        let unique = NSDate.timeIntervalSinceReferenceDate()
        
        return unique.description
    }
    
    
    
    func readFromDocumentsFile(fileName:String) -> String
    {
        
        var fileContent = "read file NOK"
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        {
            let dir = dirs[0] //documents directory
            let path = dir.stringByAppendingPathComponent(fileName+".txt");

            println(dir)
            println(path)
            if let input = NSFileHandle(forReadingAtPath: path)
            {
                let scanner = StreamScanner(source: input, delimiters: NSCharacterSet(charactersInString: ":\n"))
                fileContent = scanner.read()!
            }
        }
        return fileContent
    }
}
