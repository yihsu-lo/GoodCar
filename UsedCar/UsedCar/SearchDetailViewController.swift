//
//  SearchDetailViewController.swift
//  UsedCar
//
//  Created by Yi Hsu on 2016/9/30.
//  Copyright © 2016年 Yi Hsu. All rights reserved.
//

import UIKit
import Haneke
import SafariServices
import Firebase
import FirebaseAnalytics


class SearchDetailViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    @IBOutlet weak var brandValueLabel: UILabel!
    
    @IBOutlet weak var yearValueLabel: UILabel!
    
    @IBOutlet weak var modelValueLabel: UILabel!
    
    @IBOutlet weak var colorValueLabel: UILabel!
    
    @IBOutlet weak var mileageValueLabel: UILabel!
    
    @IBOutlet weak var locationValueLabel: UILabel!
    
    @IBOutlet weak var priceValueLabel: UILabel!
    
    @IBOutlet weak var timeValueLabel: UILabel!
    
    @IBOutlet weak var contactOwnerButton: UIButton!
    
    @IBOutlet weak var heartWhiteImageView: UIImageView!
    
    @IBOutlet weak var heartRedImageView: UIImageView!
    
    
    
    var singleSearchKey : String = ""
    var singleSearchResult : [SearchDataViewController.FirebaseSearchResultData] = []
    var singleSearchImageURL : NSURL = NSURL()
    
    let likesRootRef = FIRDatabase.database().referenceWithPath("likes")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        brandValueLabel.layer.cornerRadius = 10
        yearValueLabel.layer.cornerRadius = 10
        modelValueLabel.layer.cornerRadius = 10
        colorValueLabel.layer.cornerRadius = 10
        mileageValueLabel.layer.cornerRadius = 10
        locationValueLabel.layer.cornerRadius = 10
        priceValueLabel.layer.cornerRadius = 10
        timeValueLabel.layer.cornerRadius = 10
        
        
        brandValueLabel.clipsToBounds = true
        yearValueLabel.clipsToBounds = true
        modelValueLabel.clipsToBounds = true
        colorValueLabel.clipsToBounds = true
        mileageValueLabel.clipsToBounds = true
        locationValueLabel.clipsToBounds = true
        priceValueLabel.clipsToBounds = true
        timeValueLabel.clipsToBounds = true
        
        
        brandValueLabel.text = singleSearchResult[0].brand
        yearValueLabel.text = singleSearchResult[0].year
        modelValueLabel.text = singleSearchResult[0].model
        colorValueLabel.text = singleSearchResult[0].color
        mileageValueLabel.text = String(singleSearchResult[0].mileage)
        locationValueLabel.text = singleSearchResult[0].location
        priceValueLabel.text = String(singleSearchResult[0].price)
        timeValueLabel.text = NSString(string: singleSearchResult[0].time).substringToIndex(16)
        
        
        let color1 = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        let color2 = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.locations = [0.0, 1.0]
        gradient.colors = [color1.CGColor, color2.CGColor]
        
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
        
        contactOwnerButton.backgroundColor = UIColor(red: 30/255, green: 130/255, blue: 150/255, alpha: 1)
        
        contactOwnerButton.layer.cornerRadius = 18
        contactOwnerButton.tintColor = UIColor.whiteColor()
        
        contactOwnerButton.addTarget(self, action: #selector(contactOwenerAction), forControlEvents: .TouchUpInside)
        
        detailImageView.hnk_setImageFromURL(singleSearchImageURL)
        
        
        /**************************************************/
        /**********CHECK IF USER ALREADY LIKED IT**********/
        /**************************************************/
        
        heartRedImageView.hidden = true
        heartWhiteImageView.hidden = true
        
        let tapLike = UITapGestureRecognizer(target: self, action: #selector(likeToDatabase))
        heartWhiteImageView.addGestureRecognizer(tapLike)
        heartWhiteImageView.userInteractionEnabled = true
        
        let tapDislike = UITapGestureRecognizer(target: self, action: #selector(dislikeToDatabase))
        
        heartRedImageView.addGestureRecognizer(tapDislike)
        heartRedImageView.userInteractionEnabled = true
        
        if FirebaseManager.shared.firebaseUserID != "" {
            
            likesRootRef.queryOrderedByChild("searchInfo").queryEqualToValue("\(FirebaseManager.shared.firebaseUserID)_\(singleSearchKey)").observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                
                if snapshot.exists() {
                    
                    guard let itemDictionary = snapshot.value as? NSDictionary else {
                        fatalError()
                    }
                    
                    guard let likesDataKey = itemDictionary.allKeys as? [String] else {
                        fatalError()
                    }
                    
                    for item in likesDataKey {
                        self.firebaseLikeID = item
                    }
                    
                    print("user liked the car!")
                    self.heartRedImageView.hidden = false
                    self.heartWhiteImageView.hidden = true
                    
                    
                } else {
                    print("user did not like the car!")
                    self.heartRedImageView.hidden = true
                    self.heartWhiteImageView.hidden = false
                }
            })
        }
        

        /**************************************************/
        /****************FIREBASE ANALYTICS****************/
        /**************************************************/
        
        FIRAnalytics.logEventWithName(kFIREventSelectContent, parameters: [
            kFIRParameterContentType : FirebaseManager.shared.firebaseUserID,
            kFIRParameterItemID : "user check detail : \(singleSearchKey)"
            ])
        
    }
    
    /**************************************************/
    /**************SAVE LIKES TO DATABASE**************/
    /**************************************************/
    
    let rootRef = FIRDatabase.database().referenceWithPath("likes")
    var likesInfo : [String : String] = [ : ]
    
    
    func likeToDatabase() {
        
        let autoID = rootRef.child("likes").childByAutoId().key

        
        likesInfo = [
            "firebaseUserID" : FirebaseManager.shared.firebaseUserID,
            "dataID" : singleSearchKey,
            "searchInfo" : "\(FirebaseManager.shared.firebaseUserID)_\(singleSearchKey)"]
        
        rootRef.child(autoID).setValue(likesInfo)
        
        print("user press likes the car!")
        
        
        firebaseLikeID = autoID
        
        heartRedImageView.hidden = false
        heartWhiteImageView.hidden = true
        
        notifyUserLike()
        
        
        /**************************************************/
        /****************FIREBASE ANALYTICS****************/
        /**************************************************/
        
        FIRAnalytics.logEventWithName(kFIREventSelectContent, parameters: [
            kFIRParameterContentType : FirebaseManager.shared.firebaseUserID,
            kFIRParameterItemID : "user likes : \(singleSearchKey)"
            ])
        
        
    }
    
    /**************************************************/
    /************SAVE DISLIKES TO DATABASE*************/
    /**************************************************/
    
    
    func dislikeToDatabase() {
        
        if firebaseLikeID != "" {
            
            rootRef.child(firebaseLikeID).removeValue()
            
            print("user press dislike the car!")
            
            heartRedImageView.hidden = true
            
            heartWhiteImageView.hidden = false
            
            notifyUserDisike()
        }
    }
    
    
    /**************************************************/
    /***********NOTIFY THE LIKE AND DISMISS************/
    /**************************************************/
    
    
    var notifyLikeAlertController : UIAlertController!
    
    func notifyUserLike() {
        
        notifyLikeAlertController = UIAlertController(title: "", message: "You like the car!", preferredStyle: UIAlertControllerStyle.Alert)
        
        presentViewController(notifyLikeAlertController, animated: true, completion: nil)
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.8), target: self, selector: #selector(dismissLikeAlert), userInfo: nil, repeats: false)
    }
    
    func dismissLikeAlert() {
        
        notifyLikeAlertController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /**************************************************/
    /*********NOTIFY THE DISLIKE AND DISMISS***********/
    /**************************************************/
    
    var notifyDislikeAlertController : UIAlertController!
    
    func notifyUserDisike() {
        
        notifyDislikeAlertController = UIAlertController(title: "", message: "You dislike the car!", preferredStyle: UIAlertControllerStyle.Alert)
        
        presentViewController(notifyDislikeAlertController, animated: true, completion: nil)
        
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.8), target: self, selector: #selector(dismissDislikeAlert), userInfo: nil, repeats: false)
    }
    
    func dismissDislikeAlert() {
        
        notifyDislikeAlertController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    /**************************************************/
    /***************CONTACT OWNER ACTION***************/
    /**************************************************/
    
    var firebaseLikeID : String = ""
    
    func contactOwenerAction() {
        
        performSegueWithIdentifier("ContactOwnerActionSegue", sender: [])
    }

    
    
    /**************************************************/
    /******************SEGUE THINGS********************/
    /**************************************************/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
                let backToPrevious = UIBarButtonItem()
                backToPrevious.title = "Back"
                navigationController?.navigationBar.tintColor = UIColor.whiteColor()
                navigationItem.backBarButtonItem = backToPrevious
        
        if segue.identifier == "ContactOwnerActionSegue" {
            let destViewController : ContactOwnerViewController = segue.destinationViewController as! ContactOwnerViewController
        
            destViewController.singleSearchKey = singleSearchKey
            destViewController.singleSearchResult = singleSearchResult
            
            destViewController.title = "Contact Owner"
        }
    }

}
