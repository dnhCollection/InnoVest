//: Playground - noun: a place where people can play

import UIKit
import Alamofire


var str = "Hello, playground"

//Alamofire.request(.GET, "http://httpbin.org/get")



Alamofire.request(.GET, "http://httpbin.org/get", parameters: ["foo": "bar"])
    .responseString { (_, _, string, _) in
        println(string)
}

