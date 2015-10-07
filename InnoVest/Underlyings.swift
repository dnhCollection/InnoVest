//
//  Underlyings.swift
//  Inno Saving Invest
//
//  Created by chendong.xiaohong on 2015-09-11.
//  Copyright (c) 2015 FinSol. All rights reserved.
//

import Foundation

enum Underlyings: String, CustomStringConvertible{
    
    case germanStocks = "German Stocks Mix"
    case euroStocks = "European Stocks Mix"
    case worldStocks = "World Stocks Mix"
    
    case defaults = "not defined yet"
    
    var description: String {
    return self.rawValue
    }
}