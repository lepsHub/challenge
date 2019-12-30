//
//  BuildConfigurations.swift
//  challengeAccepted
//
//  Created by Mac on 12/28/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation

class BuildConfigurations{
    static let sharedInstance = BuildConfigurations()
    
    var urlservice: String {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            var myDict: Dictionary<String,AnyObject>
            myDict = NSDictionary(contentsOfFile: path) as! Dictionary<String, AnyObject>
            let urlService = myDict["Server Url"] as! String
            return urlService
        }
         return "https://api.trakt.tv"
    }
    
    var apiKey: String {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            var myDict: Dictionary<String,AnyObject>
            myDict = NSDictionary(contentsOfFile: path) as! Dictionary<String, AnyObject>
            let urlService = myDict["Client Id"] as! String
            return urlService
        }
         return "ed2a09bb1b860b5a80236a78b91475ad68b5f90884de8b9385daf2ee14d24df6"
    }

    
}
