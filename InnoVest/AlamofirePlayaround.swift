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
        
        let custom: (URLRequestConvertible, [String: AnyObject]?) -> (NSMutableURLRequest, NSError?) = {
            (URLRequest, parameters) in
            let mutableURLRequest = URLRequest.URLRequest.mutableCopy() as! NSMutableURLRequest
            mutableURLRequest.setValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            let data = (xmlTextContent as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            mutableURLRequest.HTTPBody = data
            return (mutableURLRequest, nil)
        }

        
        Alamofire.request(.POST, url, parameters: Dictionary(), encoding: .Custom(custom)).responseString
            { response in
                print(response.request)
                print(response.response)
                print(response.result.value)
                print(response.result.error)
                strOut = response.result.value!
                textBox.text = strOut
                Util.writeToDocumentsFile("UserRecord.xml", fileContent: strOut)
                var param = self.proceedXMLText(strOut)
                var param2 = Util.xmlText2Param(strOut)
                var record = Util.xmlText2Record(strOut)
            }

        
        return param
    }
    private static func proceedXMLText(xmlText:String) -> [String:String]{
        var param = [String:String]()
        let xml = SWXMLHash.parse(xmlText)
        if let resultText = xml["qwbWebService"]["results"]["result"].element?.text
        {
            print(resultText)
            param = text2Param(resultText)
        }
        return param
    }
    private static func text2Param(text:String)->[String:String]
    {
        var param = [String:String]()
        let lines = text.characters.split{$0=="\n"}.map { String($0) }
        for line in lines
        {
            var words = line.characters.split{$0=="\t"}.map { String($0) }
            param[words[0]]=words[1]
        }
        
        return param
    }
}