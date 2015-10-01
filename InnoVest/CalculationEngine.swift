//
//  CalculationEngine.swift
//  InsuranceInvestSingleView
//
//  Created by chendong.xiaohong on 2015-08-31.
//  Copyright (c) 2015 dd. All rights reserved.
//

import Foundation

class CalculationEngine {
    
    var isWebService : Bool
    var age = 60.0
    var timeToMaturity = 15.0
    
    let volatility = 0.12
    let rOIS = 0.01
    let commission = 0.024
    var rProjection = 0.05
    
    init(isWebService:Bool){
        self.isWebService = isWebService
    }
    
    init(){
        isWebService = false // calling local engine for debug modus
    }
    
    func updateT0(recordOld: Record) -> Record{
        var param = Util.record2param(recordOld)
        
        var paramOut : [String: String]
        if isWebService {
            paramOut = updateT0Web(param)
        }else{
            paramOut = updateT0Local(param)
        }
        
        var recordOldT0Updated = Util.param2record(paramOut)
        return recordOldT0Updated
    }
    
    func updateT0Local(param : [String: String]) -> [String:String]{
        var recordOldT0Updated = Util.param2record(param)
        // update T0
        recordOldT0Updated.resultsT0 = coreCalc(Util.param2resultsT0(param))
        return Util.record2param(recordOldT0Updated)
    }

    func updateT0Web(param : [String: String]) -> [String:String]{
        var recordOldT0Updated = Record()
        // update T0 via web service
        return Util.record2param(recordOldT0Updated)
    }
    
    func simulate(recordOld: Record) -> Record{
        
        var recordT0Local = triggerInfo2record(recordOld)
        var param = Util.record2param(recordT0Local)
        
        var paramOut : [String: String]
        if isWebService {
            paramOut = simulateWeb(param)
        }else{
            paramOut = simulateLocal(param)
        }
        
        var recordT1 = Util.param2record(paramOut)
        return recordT1
    }
    
    func simulateLocal(param:[String:String])->[String:String]{

        var recordOld = Util.param2record(param)
        // T0
        recordOld.resultsT0 = coreCalc(Util.param2resultsT0(param))
        
        // NewInv
        recordOld.resultsNewInv = coreCalc(Util.param2resultsNewInv(param))
        
        // T1
        recordOld.resultsT1 = coreCalc(Util.param2resultsT1(param))
        
        return Util.record2param(recordOld)
    }

    func simulateWeb(param:[String:String])->[String:String]{
        
        /*
        here is the code part generating/send the xml for RESTfull http request, and recieve/proceed response
        */
        return param
    }
    
    func coreCalc(resultsBaseIn:ResultsBase)->ResultsBase{
        
        var resultsBaseOut = ResultsBase()
        
        var totalAssetNetto = resultsBaseIn.totalAsset
        var guaranteeLevel = resultsBaseIn.guaranteedPayout
        var split = assetSplitter(totalAssetNetto, guaranteeLevel: guaranteeLevel)
        var projectedPayout = projector(split.fundValue)
        
        resultsBaseOut.fundAsset = split.fundValue
        resultsBaseOut.guaranteeAsset = split.guaranteeValue
        resultsBaseOut.totalAsset = split.fundValue + split.guaranteeValue
        resultsBaseOut.guaranteedPayout = guaranteeLevel
        resultsBaseOut.projectedPayout = projectedPayout
        return resultsBaseOut
    }
    
    func assetSplitter(assetValue: Double, guaranteeLevel: Double)->(fundValue:Double, guaranteeValue: Double){
//        var rOISRand = getRandomAround(rOIS)
        
        let eps = 0.1
        let iterMax = 1000
        
        var guaranteeValueGuess = 0.2*guaranteeLevel
        for ind in 1...iterMax{

            var fundValue = assetValue - guaranteeValueGuess
            
            var guaranteeValue = blsCallPrice(assetValue, strikeValue: guaranteeLevel, timeTomMaturity: timeToMaturity, rate: rOIS, vola: volatility)
            var diff = abs(guaranteeValue - guaranteeValueGuess)
            if (diff < eps){
                return (fundValue,guaranteeValue)
            }else // update guess
            {
                guaranteeValueGuess = (guaranteeValueGuess + guaranteeValue)/2
            }
        }
        
        return (-555,-555)
        
    }
    
    func projector(fundValue:Double)-> Double{
        var temp = rProjection*timeToMaturity
        var projectedPayout = fundValue * exp(temp)
        return projectedPayout
    }
    
    func triggerInfo2resultsNewInv(triggerInfo:TriggerInfo)->ResultsBase{
        
        var spNetto = triggerInfo.newInvSPEUR*(1-commission)
        var gl = triggerInfo.newInvGLEUR
        var resultsNewInv = ResultsBase()
        resultsNewInv.totalAsset = spNetto
        resultsNewInv.guaranteedPayout = gl
        return resultsNewInv
    }
    
    func triggerInfo2record(record: Record) -> Record{
        var recordOut = record
        recordOut.resultsNewInv = triggerInfo2resultsNewInv(record.triggerInfo)
        recordOut.resultsT1.totalAsset = record.resultsT0.totalAsset + record.resultsNewInv.totalAsset
        recordOut.resultsT1.guaranteedPayout = record.resultsT0.guaranteedPayout + record.resultsNewInv.guaranteedPayout
        
        
        
        return recordOut
    }
    
    private func blsCallPrice(spotValue:Double, strikeValue:Double, timeTomMaturity:Double, rate:Double,vola:Double)-> Double{
        
        if strikeValue <= 0{
            return 0.0
        }else
        {
            var d1:Double
            var d2:Double
            
            var invMoneyness = spotValue / strikeValue
            d1 = (log(invMoneyness) + (rate + vola*vola/2) * timeTomMaturity) / (vola * sqrt(timeTomMaturity))
            d2 = d1 - vola * sqrt(timeToMaturity)
            
            var callPrice = spotValue * cnd(d1) - strikeValue * exp(-rate * timeToMaturity)*cnd(d2)
            var pPrice = strikeValue * exp(-rate * timeToMaturity)*cnd(-d2) - spotValue * cnd(-d1)
            
            return pPrice
            
        }
    }
    
    private func cnd(x:Double) -> Double{
        var l : Double
        var k : Double
        var w : Double
        var a1 = 0.31938153
        var a2 = -0.356563782
        var a3 = 1.781477937
        var a4 = -1.821255978
        var a5 = 1.330274429
        let PI = 3.1415926
        l = abs(x)
        k = 1.0/(1.0+0.2316419 * l)
        
        
        var temp = a1 * k + a2 * (k*k) + a3 * pow(k,3.0) + a4 * pow(k,4) + a5 * pow(k,5.0)
        w = 1.0 - 1.0 / sqrt(2.0*M_PI) * exp(-l*l / 2) * temp
        
        if (x<0.0){
            w = 1.0-w
        }
        return w
    }
    
    private func getRandomAround(rateIn:Double)->Double{
        var seed = UInt32(NSDate().timeIntervalSince1970)
        //        srand(seed)
        var rGaussian = randomGaussian()
        var rOut = max(0, rateIn + rGaussian * (rateIn * 0.01)) // 1 percent relative vola
        
        return rOut
    }

    // "Generating Gaussian Random Numbers"
    private func randomGaussian() -> Double {
        return sqrt( -2.0 * log(randomDouble()) ) * cos( 2.0 * M_PI * randomDouble() )
    }
    
    // returns a random Double in the half-open interval 0..<1
    private func randomDouble() -> Double {
        return Double(random()) / Double(Int32.max)
    }
    
    // returns a random Int32 in the half-open interval 0..<(2**32)
    private func random() -> UInt32 {
        return arc4random()
    }
    

    
    
//    char CallPutFlag, double S, double X, double T, double r, double v)
//    {
//    double d1, d2;
//    
//    d1=(Math.log(S/X)+(r+v*v/2)*T)/(v*Math.sqrt(T));
//    d2=d1-v*Math.sqrt(T);
//    
//    if (CallPutFlag=='c')
//    {
//    return S*CND(d1)-X*Math.exp(-r*T)*CND(d2);
//    }
//    else
//    {
//    return X*Math.exp(-r*T)*CND(-d2)-S*CND(-d1);
//    }
//}
//
//// The cumulative normal distribution function
//public double CND(double X)
//{
//    double L, K, w ;
//    double a1 = 0.31938153, a2 = -0.356563782, a3 = 1.781477937, a4 = -1.821255978, a5 = 1.330274429;
//    
//    L = Math.abs(X);
//    K = 1.0 / (1.0 + 0.2316419 * L);
//    w = 1.0 - 1.0 / Math.sqrt(2.0 * Math.PI) * Math.exp(-L *L / 2) * (a1 * K + a2 * K *K + a3
//    * Math.pow(K,3) + a4 * Math.pow(K,4) + a5 * Math.pow(K,5));
//    
//    if (X < 0.0) 
//    {
//        w= 1.0 - w;
//    }
//    return w;
//}


    
}