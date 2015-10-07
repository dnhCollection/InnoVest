//
//  Defaults.swift
//  InnoVest
//
//  Created by chendong.xiaohong on 2015-10-01.
//  Copyright (c) 2015 FinSol. All rights reserved.
//

import Foundation

class StaticDefaults{
    
    static let url0 = "http://mrmquandtws01.cloudapp.net:5000/QwbWebService/Ergo/"
    
    static let urlTestPost = url0+"TestPost/"
    
    static let urlLoadRecord = url0 + "LoadRecord/"
    
    static let urlSimulate = url0 + "ProductIllustrator/"
    
    static let urlSaveRecord = url0+"SaveSession/"
    
    static let urlRegisterNewAccount = url0 + "InitialPolicyInfo/"
    
    static let responseXmlLevel1 = "qwbWebService"
    
    static let responseXmlLevel2 = "results"
    
    static let responseXmlLevel3 = "result"
    
    static let playaroundAccountName = "playaround"
    
}

struct RecordFieldsEN{
    static let userInfoTitle = "Contract Information"
    static let birthDate = "Birth Date"
    static let maturityDate = "Maturity Date"
    static let underlying = "Fund Investment"
    static let communication = "Media"
    static let address = "Address / Tel."
    
    static let resultsT0Title = "Today's Investment Summary"
    static let fundAssetT0 = "Fund Asset T0"
    static let guaranteeAssetT0 = "Safety Asset T0"
    static let totalAssetT0 = "Total Asset T0"
    static let guaranteedPayoutT0 = "Guaranteed Payout T0"
    static let projectedPayoutT0 = "Projected Payout T0"
    
    static let resultsNewSPTitle = "Increase in Account after Top-Up"
    static let fundAssetNewSP = "Fund Asset NewSP"
    static let guaranteeAssetNewSP = "Safety Asset NewSP"
    static let totalAssetNewSP = "Total Asset NewSP"
    static let guaranteedPayoutNewSP = "Guaranteed Payout NewSP"
    static let projectedPayoutNewSP = "Projected Payout NewSP"
 
    static let resultsT1Title = "Investment Summary after Top-Up"
    static let fundAssetT1 = "Fund Asset T1"
    static let guaranteeAssetT1 = "Safety Asset T1"
    static let totalAssetT1 = "Total Asset T1"
    static let guaranteedPayoutT1 = "Guaranteed Payout T1"
    static let projectedPayoutT1 = "Projected Payout T1"

    static let triggerSetupTitle = "Trigger/Alert Setup"
    static let newInvSPEUR = "Top-Up Payment"
    static let newInvGLEUR = "Guarantee Level"
//    static let newInvSPEUR = "Top-Up Payment"
//    static let newInvGLEUR = "Guarantee Level"

}

struct SaveRecordFieldsEn{

    static let userID = "userID"
    
    static let valuationDate = "valuationDate"
    
    static let birthDate = "birthDate"
    static let maturityDate = "maturityDate"
    static let underlying = "underlyingName"
    static let communication = "communicationMedia"
    static let address = "address"
    
    static let fundAssetT0 = "fundAssetT0"
    static let guaranteeAssetT0 = "guaranteeAssetT0"
    static let totalAssetT0 = "totalAssetT0"
    static let guaranteedPayoutT0 = "guaranteeLevelT0"
    static let projectedPayoutT0 = "performanceT0"
    
    static let newInvSPEUR = "newSP"
    static let newInvGLEUR = "guaranteeLevelNewSP"
    static let triggerType = "triggerType"
    static let triggerThreshold = "triggerThreshold"

}

struct XmlDefaults{
    static let xmlHead = "<?xml version=\"1.0\" standalone=\"yes\"?>"
    static let inputParametersHead = "<inputParameters>"
    static let inputParametersTail = "</inputParameters>"
    static let parameterHead = "<parameter name=\""
    static let parameterMid = "\" type=\"typedValue\">"
    static let parameterTail = "</parameter>"
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






//Trigger/Alert Setup	yes
//Top-Up Payment	0.0
//Safety Asset NewSP	0.0
//Vertragsguthaben gestiegen um:	0.0