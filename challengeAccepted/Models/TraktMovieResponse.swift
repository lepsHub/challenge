//
//  TraktMoviesResponse.swift
//  challengeAccepted
//
//  Created by Mac on 12/29/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation

public struct TraktMovieResponse: Decodable {
    
    public let title: String?
    
    public let year: Int?
    
    public let overview: String?
    
    public let ids:Identifiers
    
    private enum CodingKeys: String, CodingKey {
        
        case title = "title"
        
        case year = "year"
        
        case overview = "overview"
        
        case ids = "ids"
    }
}

public struct Identifiers:Decodable{
    
    public let tmdb: Int?
    
    private enum CodingKeys: String, CodingKey {
        
        case tmdb = "tmdb"
    }
}
