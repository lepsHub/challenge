//
//  ImageUrlRequest.swift
//  challengeAccepted
//
//  Created by Mac on 12/30/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import Alamofire

extension NetworkManager {
    
    public func ImageService (id:String,completion: @escaping (ResponseValue<FanartResponse>) -> Void ) {
        
        let serviceBaseUrl = "http://webservice.fanart.tv/v3"
        
        let finalQuery = "/movies/\(id)?api_key=ed3b24baae7d896b74184023cff4f759"
        
        callUrlWithCompletion(urlService: serviceBaseUrl, url: finalQuery, params: nil, completion: { (serverError, response) in
            
            if serverError != nil {
                completion(.error(serverError!))
            } else {
                do {
                    let serviceResponse = try JSONDecoder().decode(FanartResponse.self, from: response as! Data)
                    completion(.value(serviceResponse))
                } catch let jsonErr {
                    print("Error decoding Json", jsonErr)
                    completion(.error(.generic))
                }
            }
        }, method: .get)
    }
}
