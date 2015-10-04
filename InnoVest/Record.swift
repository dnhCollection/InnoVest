//
//  Record.swift
//  InsuranceInvestSingleView
//
//  Created by chendong.xiaohong on 2015-08-31.
//  Copyright (c) 2015 dd. All rights reserved.
//

import Foundation

class Record{
    
    static let defaultUnderlying = "WorldStocks"
    static let defaultTriggerType = "Vertragsguthaben gestiegen um:"
    
    var resultsT0 : ResultsBase
    var resultsNewInv : ResultsBase
    var resultsT1 : ResultsBase
    var userInfo : UserInfo
    var triggerInfo : TriggerInfo
    
    init(userInfo: UserInfo, resultsT0: ResultsBase, resultsNewInv: ResultsBase, resultsT1: ResultsBase, triggerInfo:TriggerInfo){
        self.resultsT0 = resultsT0
        self.resultsNewInv = resultsNewInv
        self.resultsT1 = resultsT1
        self.userInfo = userInfo
        self.triggerInfo = triggerInfo
    }
    
    init(){
        userInfo = UserInfo()
        resultsT0 = ResultsBase()
        resultsNewInv = ResultsBase()
        resultsT1 = ResultsBase()
        triggerInfo = TriggerInfo()
    }
}


class ResultsBase{
    var fundAsset = 0.0
    var guaranteeAsset=0.0
    var totalAsset = 0.0
    var guaranteedPayout=0.0
    var projectedPayout=0.0
    
    init(newInvSPEUR:Double, newInvGLEUR: Double){
        totalAsset = newInvSPEUR
        guaranteedPayout = newInvGLEUR
    }
    
    init(){
    }
}

class UserInfo{
    var birthDate = "1970-01-01"
    var maturityDate = "2040-01-01"
    var communication = "SMS"
    var address = "01780000000"
    var gender = "female"
}

class TriggerInfo{
    var newInvSPEUR = 0.0
    var newInvGLEUR = 0.0
    var triggerType = "xxx"
    var triggerLevel = 0.0
}