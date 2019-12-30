//
//  FanartResponse.swift
//  challengeAccepted
//
//  Created by Mac on 12/30/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation

public struct FanartResponse: Decodable {
    
    public let moviethumb: [moviethumb]?
    
    private enum CodingKeys: String, CodingKey {
        
        case moviethumb = "moviethumb"
    }
}
public struct moviethumb: Decodable{
    
    public let url: String?
    
    private enum CodingKeys: String, CodingKey {
        
        case url = "url"
    }
}
