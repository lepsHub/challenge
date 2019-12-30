//
//  TraktResultResponse.swift
//  challengeAccepted
//
//  Created by Mac on 12/29/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation

public struct TraktResultResponse: Decodable {
    
    public let movie: TraktMovieResponse
    
    private enum CodingKeys: String, CodingKey {
        case movie = "movie"
    }
}
