//
//  AlertManager.swift
//  challengeAccepted
//
//  Created by Mac on 12/29/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import UIKit

public typealias AlertCompletionBlock = () -> Void

class AlertsManager {
    
    static let sharedInstance = AlertsManager()
    
    public func ShowBasicAlertView(view: UIViewController,title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        view.present(alertController, animated: true, completion: nil)
    }
    
    public func ShowAlertViewWithCallBack(view: UIViewController,title:String, message:String, buttonnTitle:String,completion: @escaping AlertCompletionBlock){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let aceptAction = UIAlertAction(title: buttonnTitle, style: .default ) { (action:UIAlertAction!) in
            completion()
        }
        alertController.addAction(aceptAction)
        
        view.present(alertController, animated: true, completion:nil)
    }
    
    public func ShowAlertViewWithDecision(view: UIViewController,title:String, message:String, firstButtonnTitle:String, secondButtonnTitle:String, firstCompletion: @escaping AlertCompletionBlock, secondCompletion: @escaping AlertCompletionBlock){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let firstAction = UIAlertAction(title: firstButtonnTitle, style: .default) { (action:UIAlertAction!) in
            
            firstCompletion()
            
        }
        alertController.addAction(firstAction)
        
        let secondAction = UIAlertAction(title: secondButtonnTitle, style: .default) { (action:UIAlertAction!) in
            secondCompletion()
        }
        
        alertController.addAction(secondAction)
        view.present(alertController, animated: true, completion:nil)
    }
}

extension UIAlertController {
    
    public class func showServerErrorAlert(serverError: ServerError, view: UIViewController, title: String? = nil, firstButtonnTitle: String? = nil, secondButtonnTitle: String? = nil, firstCompletion: AlertCompletionBlock? = nil, secondCompletion: AlertCompletionBlock? = nil) {
        
        let alertTitle = (title == nil) ? "Challenge Accepted" : title
        
        var alertMessage = ""
        
        switch serverError {
        case .connection:
            alertMessage = "Please connect to internet and try again."
        case .generic:
            alertMessage = "There was a problem please try again."
        case .server:
            alertMessage = "There was a server problem, please try again later."
        case .timeOut:
            alertMessage = "There was a internet connection problem, please check your internet and try again later."
        }
        
        if firstButtonnTitle == nil {
            AlertsManager.sharedInstance.ShowBasicAlertView(view: view, title: alertTitle!, message: alertMessage)
        } else {
            if secondButtonnTitle == nil {
                AlertsManager.sharedInstance.ShowAlertViewWithCallBack(view: view, title: alertTitle!, message: alertMessage, buttonnTitle: firstButtonnTitle!, completion: {
                    guard let completion = firstCompletion
                        else {return}
                    completion()
                })
            } else {
                AlertsManager.sharedInstance.ShowAlertViewWithDecision(view: view, title: alertTitle!, message: alertMessage, firstButtonnTitle: firstButtonnTitle!, secondButtonnTitle: secondButtonnTitle!, firstCompletion: {
                    guard let completion = firstCompletion
                        else {return}
                    completion()
                }, secondCompletion: {
                    guard let completion = secondCompletion
                        else {return}
                    completion()
                })
            }
        }
    }
}
