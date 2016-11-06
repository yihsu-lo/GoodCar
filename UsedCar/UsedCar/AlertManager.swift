//
//  AlertManager.swift
//  UsedCar
//
//  Created by yihsu on 2016/11/1.
//  Copyright © 2016年 Yi Hsu. All rights reserved.
//

import UIKit

class AlertManager {
    
    func alertConnectionError() -> UIAlertController {
        
        let alertController = UIAlertController(title: "Warning", message: "Internet Connection error! Please try again!", preferredStyle: UIAlertControllerStyle.Alert)
        let goBackAction = UIAlertAction(title: "Go back", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
        }
        alertController.addAction(goBackAction)
        
        return alertController
    }
    
    
    func alertUserInfoError() -> UIAlertController {
        
        let alertController = UIAlertController(title: "Warning", message: "User Information is not available! Please try again!", preferredStyle: UIAlertControllerStyle.Alert)
        let goBackAction = UIAlertAction(title: "Go back", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
        }
        
        alertController.addAction(goBackAction)
        
        return alertController
    }
    
    
    func alertCellInputError() -> UIAlertController {
        
        let alertController = UIAlertController(title: "Warning", message: "All cells are mandatory!", preferredStyle: UIAlertControllerStyle.Alert)
        let goBackAction = UIAlertAction(title: "Go back", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
        }
        
        alertController.addAction(goBackAction)
        
        return alertController
    }
    
    
    func alertSearchNotMatched() -> UIAlertController {
        
        let alertController = UIAlertController(title: "Warning", message: "No search result matched!", preferredStyle: UIAlertControllerStyle.Alert)
        let goBackAction = UIAlertAction(title: "Go back", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
            
        }
        alertController.addAction(goBackAction)
        
        return alertController
    }
    
    
    func alertMessageInputError() -> UIAlertController {
        
        let alertController = UIAlertController(title: "Warning", message: "Message should be input!", preferredStyle: UIAlertControllerStyle.Alert)
        let goBackAction = UIAlertAction(title: "Go back", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
        }
        alertController.addAction(goBackAction)

        return alertController
    }
    
    func alertFBLoginError() -> UIAlertController {
        
        let alertController = UIAlertController(title: "Warning", message: "Please login with Facebook to use the function!", preferredStyle: UIAlertControllerStyle.Alert)
        let goBackAction = UIAlertAction(title: "Login", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
        }
        alertController.addAction(goBackAction)
        
        return alertController
    }
    
    
    
}
