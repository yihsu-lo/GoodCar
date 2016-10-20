//
//  ViewController.swift
//  UsedCar
//
//  Created by Yi Hsu on 2016/9/22.
//  Copyright © 2016年 Yi Hsu. All rights reserved.
//

import UIKit
import Crashlytics

class ViewController: UIViewController {
    
    @IBOutlet weak var mustangImageView: UIImageView!
    
    @IBOutlet weak var saleCarBackgroundView: UIView!
    
    @IBOutlet weak var findCarBackgroundView: UIView!
    
    @IBOutlet weak var goodCarNaviItem: UINavigationItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mustangImageView.alpha = 0.5
        
        findCarBackgroundView.layer.cornerRadius = findCarBackgroundView.frame.size.width / 2
        findCarBackgroundView.layer.borderColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1).CGColor
        findCarBackgroundView.layer.borderWidth = 1.0
        findCarBackgroundView.layer.shadowColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1).CGColor
        findCarBackgroundView.layer.shadowRadius = 4
        findCarBackgroundView.layer.shadowOffset = CGSizeMake(0, 2)
        findCarBackgroundView.layer.shadowOpacity = 0.25
        
        saleCarBackgroundView.layer.cornerRadius = saleCarBackgroundView.frame.size.width / 2
        saleCarBackgroundView.layer.borderColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1).CGColor
        saleCarBackgroundView.layer.borderWidth = 1.0
        saleCarBackgroundView.layer.shadowColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1).CGColor
        saleCarBackgroundView.layer.shadowRadius = 4
        saleCarBackgroundView.layer.shadowOffset = CGSizeMake(0, 2)
        saleCarBackgroundView.layer.shadowOpacity = 0.25
        
        
        let color1 = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        let color2 = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.locations = [0.0, 1.0]
        gradient.colors = [color1.CGColor, color2.CGColor]
        
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
        
        let tapUpload = UITapGestureRecognizer(target: self, action: #selector(toUploadDataPage))
        saleCarBackgroundView.addGestureRecognizer(tapUpload)
        saleCarBackgroundView.userInteractionEnabled = true
        
        let tapSearch = UITapGestureRecognizer(target: self, action: #selector(toSearchDataPage))
        findCarBackgroundView.addGestureRecognizer(tapSearch)
        findCarBackgroundView.userInteractionEnabled = true
        
    }

    
        override func viewDidAppear(animated: Bool) {
            super.viewDidAppear(true)
    
            if Reachability.isConnectedToNetwork() != true {
            
            let alertController = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.Alert)
            let goBackAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(goBackAction)
    
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    /**************************************************/
    /******************SEGUE THINGS********************/
    /**************************************************/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "UploadDataSegue" {
            let destViewController: UploadDataViewController = segue.destinationViewController as! UploadDataViewController
            
            let backToPrevious = UIBarButtonItem()
            backToPrevious.title = "Back"
            navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            navigationItem.backBarButtonItem = backToPrevious
            
            destViewController.title = "Upload My Good Car"
            
        }
        
        
        if segue.identifier == "SearchDataSegue" {
            let destViewController: SearchDataViewController = segue.destinationViewController as! SearchDataViewController
            
            let backToPrevious = UIBarButtonItem()
            backToPrevious.title = "Back"
            navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            navigationItem.backBarButtonItem = backToPrevious

            destViewController.title = "Find My Good Car"

        }
    }
    
    
    func toUploadDataPage() {
        
        performSegueWithIdentifier("UploadDataSegue", sender: [])
    }
    
    func toSearchDataPage() {
        
        performSegueWithIdentifier("SearchDataSegue", sender: [])
    }
    
    
    /**************************************************/
    /**************UNWIND SEGUE THINGS*****************/
    /**************************************************/
    
    @IBAction func unwindToMainFromUploadPage(segue: UIStoryboardSegue) {
        
    }
    
    deinit {
        print("Main : 記憶體釋放")
    }
}

