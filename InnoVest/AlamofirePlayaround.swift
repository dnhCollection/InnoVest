//
//  AlamofirePlayaround.swift
//  InnoVest
//
//  Created by chendong.xiaohong on 2015-09-27.
//  Copyright (c) 2015 FinSol. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class AlamorfirePlayaround{
    
    
    static func playAlamofire(textBox:UITextField)-> [String:String]{
        var strOut = "orignal"
        var url0 = "http://mrmquandtws01.cloudapp.net:5000/QwbWebService/Ergo/"
        var urlTestPost = url0+"TestPost/"
        var url = url0+"LoadRecord/"
        
        var xmlTextContent = "<?xml version=\"1.0\" standalone=\"yes\"?>        <inputParameters><parameter name=\"userID\" type=\"typedValue\">S\tFinSol_User</parameter></inputParameters>"
        let param = ["xmlText":xmlTextContent]
        
//        var manager = Manager.sharedInstance
//        //Passing all the headers you want!
//        manager.session.configuration.HTTPAdditionalHeaders = [
//            "Content-Type": "text/xml"
//        ]
        
        let custom: (URLRequestConvertible, [String: AnyObject]?) -> (NSURLRequest, NSError?) = {
            (URLRequest, parameters) in
            let mutableURLRequest = URLRequest.URLRequest.mutableCopy() as! NSMutableURLRequest
            mutableURLRequest.setValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            let data = (xmlTextContent as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            mutableURLRequest.HTTPBody = data
            return (mutableURLRequest, nil)
        }

        
        Alamofire.request(.POST, url, parameters: Dictionary(), encoding: .Custom(custom)).responseString
            { (request, response, string, error) in
                println(request)
                println(response)
                println(string)
                println(error)
                strOut = string!
                textBox.text = strOut
                Util.writeToDocumentsFile("UserRecord.xml", fileContent: strOut)
                var param = self.proceedXMLText(strOut)
            }

        
        return param
    }
    private static func proceedXMLText(xmlText:String) -> [String:String]{
        var param = [String:String]()
        var xml = SWXMLHash.parse(xmlText)
        if let resultText = xml["qwbWebService"]["results"]["result"].element?.text
        {
            println(resultText)
            param = text2Param(resultText)
        }
        return param
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
}