//
//  NetworkManager.swift
//  challengeAccepted
//
//  Created by Mac on 12/28/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import Alamofire
import Reachability
import SystemConfiguration

//typealias CompletionBlock = (AnyObject?, AnyObject?) -> Void
typealias CompletionBlock = (ServerError?, AnyObject?) -> Void

public enum ResponseValue<T> {
    case error(ServerError)
    case value(T)
}

public enum ServerError {
    case generic
    case server
    case timeOut
    case connection
}

class NetworkManager {
    static let sharedInstance = NetworkManager()
    
    var configuration = BuildConfigurations()
    
    class func isConnectedToNetwork() -> Bool {
        let reachability = try! Reachability()
        
        if (reachability.whenUnreachable != nil){
            return false
        }else{
            return true
        }
    }
    
    let manager: Alamofire.SessionManager = {
            
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = TimeInterval(60.0)
            configuration.timeoutIntervalForResource = TimeInterval(60.0)
            configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
            
            return Alamofire.SessionManager(
                configuration: configuration
            )
        }()
    
    public func callUrlWithCompletion(urlService:String!, url : String!, params : [String: AnyObject]?, completion : @escaping CompletionBlock, method: HTTPMethod) {
        
        if !NetworkManager.isConnectedToNetwork() {
            completion(.connection, nil)
        }
        
        let urlString = urlService.appending(url)
        print("REQUEST URL 📩📩📩📩📩📩 -->  \(urlString)")
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "trakt-api-version": "2",
            "trakt-api-key" : BuildConfigurations.sharedInstance.apiKey
        ]
        
        print("REQUEST HEADERS  📩📩📩📩📩📩 --> ",headers)
        
        manager.request(urlString, method: method, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
            switch (response.result) {
            case .success:
                completion(self.evaluateStatusCode(statusCode: response.response?.statusCode), response.data as AnyObject)
                break
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    completion(.timeOut, response.data as AnyObject)
                } else {
                    completion(.generic, response.data as AnyObject)
                }
                break
            }
        })
    }
    
    public func evaluateStatusCode(statusCode: Int?) -> ServerError? {
        guard let code = statusCode
            else { return .generic }
        
        switch code {
        case 200, 201, 202:
            return nil
        case 400, 401, 402, 403:
            return .server
        case 500, 501, 502:
            return .server
        default:
            return .generic
        }
    }
    
    public func cancelRequest() {
        
        manager.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach {
                print("Se cancelara el request 🚫🚫🚫 = ", $0.originalRequest?.url?.absoluteString ?? "")
                $0.cancel()
            }
            
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
}
