//
//  Request.swift
//  challengeAccepted
//
//  Created by Mac on 12/29/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import Alamofire

extension NetworkManager {
    
    public func moviesService (page:Int,limit:Int,completion: @escaping (ResponseValue<[TraktMovieResponse]>) -> Void ) {
        
        let serviceBaseUrl = configuration.urlservice
        
        let basicQuery = APIQuery.getPopularMovies + APIQuery.and
        let pageQuery = ExtraParameter.PAGE.rawValue + String(page) + APIQuery.and
        let limitQuery =  ExtraParameter.LIMIT.rawValue + String(limit)
        
        let finalQuery = basicQuery + pageQuery + limitQuery
        
        callUrlWithCompletion(urlService: serviceBaseUrl, url: finalQuery, params: nil, completion: { (serverError, response) in
            
            if serverError != nil {
                completion(.error(serverError!))
            } else {
                do {
                    let serviceResponse = try JSONDecoder().decode([TraktMovieResponse].self, from: response as! Data)
                    completion(.value(serviceResponse))
                } catch let jsonErr {
                    print("Error decoding Json", jsonErr)
                    completion(.error(.generic))
                }
            }
        }, method: .get)
    }
}
