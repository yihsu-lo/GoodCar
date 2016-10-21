//
//  LovedItemsDetailViewController.swift
//  UsedCar
//
//  Created by Yi Hsu on 2016/10/7.
//  Copyright © 2016年 Yi Hsu. All rights reserved.
//

import UIKit
import Firebase
import Haneke


class LovedItemsDetailViewController: UIViewController {
    
    @IBOutlet weak var lovedDetailImageView: UIImageView!
    
    @IBOutlet weak var lovedDetailBrandValueLabel: UILabel!
    
    @IBOutlet weak var lovedDetailYearValueLabel: UILabel!
    
    @IBOutlet weak var lovedDetailModelValueLabel: UILabel!
    
    @IBOutlet weak var lovedDetailColorValueLabel: UILabel!
    
    @IBOutlet weak var lovedDetailMileageValueLabel: UILabel!
    
    @IBOutlet weak var lovedDetailLocationValueLabel: UILabel!
    
    @IBOutlet weak var lovedDetailPriceValueLabel: UILabel!
    
    @IBOutlet weak var lovedDetailTimeValueLabel: UILabel!
    
    @IBOutlet weak var heartRedImageView: UIImageView!
    
    @IBOutlet weak var heartWhiteImageView: UIImageView!
    
    @IBOutlet weak var lovedDetailContactOwnerButton: UIButton!

    
    var singleSearchKey : String = ""
    var singleSearchResult : [SearchDataViewController.FirebaseSearchResultData] = []
    var singleSearchImageURL : NSURL = NSURL()
    
    let likesRootRef = FIRDatabase.database().referenceWithPath("likes")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lovedDetailBrandValueLabel.layer.cornerRadius = 10
        lovedDetailYearValueLabel.layer.cornerRadius = 10
        lovedDetailModelValueLabel.layer.cornerRadius = 10
        lovedDetailColorValueLabel.layer.cornerRadius = 10
        lovedDetailMileageValueLabel.layer.cornerRadius = 10
        lovedDetailLocationValueLabel.layer.cornerRadius = 10
        lovedDetailPriceValueLabel.layer.cornerRadius = 10
        lovedDetailTimeValueLabel.layer.cornerRadius = 10
        
        lovedDetailBrandValueLabel.clipsToBounds = true
        lovedDetailYearValueLabel.clipsToBounds = true
        lovedDetailModelValueLabel.clipsToBounds = true
        lovedDetailColorValueLabel.clipsToBounds = true
        lovedDetailMileageValueLabel.clipsToBounds = true
        lovedDetailLocationValueLabel.clipsToBounds = true
        lovedDetailPriceValueLabel.clipsToBounds = true
        lovedDetailTimeValueLabel.clipsToBounds = true
        
        lovedDetailBrandValueLabel.text = singleSearchResult[0].brand
        lovedDetailYearValueLabel.text = singleSearchResult[0].year
        lovedDetailModelValueLabel.text = singleSearchResult[0].model
        lovedDetailColorValueLabel.text = singleSearchResult[0].color
        lovedDetailMileageValueLabel.text = String(singleSearchResult[0].mileage)
        lovedDetailLocationValueLabel.text = singleSearchResult[0].location
        lovedDetailPriceValueLabel.text = String(singleSearchResult[0].price)
        lovedDetailTimeValueLabel.text = NSString(string: singleSearchResult[0].time).substringToIndex(16)
        
        
        lovedDetailContactOwnerButton.backgroundColor = UIColor(red: 30/255, green: 130/255, blue: 150/255, alpha: 1)
        
        lovedDetailContactOwnerButton.layer.cornerRadius = 18
        lovedDetailContactOwnerButton.tintColor = UIColor.whiteColor()
        
        
        let color1 = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        let color2 = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.locations = [0.0, 1.0]
        gradient.colors = [color1.CGColor, color2.CGColor]
        
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
        lovedDetailImageView.hnk_setImageFromURL(singleSearchImageURL)
        
        
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
                    
                    self.heartRedImageView.hidden = false
                    self.heartWhiteImageView.hidden = true
                    
                    
                } else {
                    
                    self.heartRedImageView.hidden = true
                    self.heartWhiteImageView.hidden = false
                }
            })
        }
        
    }
    
    var firebaseLikeID : String = ""
    
    
    /**************************************************/
    /**************SAVE LIKES TO DATABASE**************/
    /**************************************************/
    
    let rootRef = FIRDatabase.database().referenceWithPath("likes")
    
    func likeToDatabase() {
        
        let autoID = rootRef.child("likes").childByAutoId().key
        rootRef.child(autoID).child("firebaseUserID").setValue(FirebaseManager.shared.firebaseUserID)
        rootRef.child(autoID).child("dataID").setValue(singleSearchKey)
        rootRef.child(autoID).child("searchInfo").setValue("\(FirebaseManager.shared.firebaseUserID)_\(singleSearchKey)")
        
        print("user press likes the car!")
        
        
        firebaseLikeID = autoID
        
        heartRedImageView.hidden = false
        heartWhiteImageView.hidden = true
        
        notifyUserLike()
        
        /**************************************************/
        /*************SEND UPDATES NOTIFICATION************/
        /**************************************************/
        NSNotificationCenter.defaultCenter().postNotificationName("LovedItemsNotficationIdentifier", object: nil)
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
            
            
            
            /**************************************************/
            /*************SEND UPDATES NOTIFICATION************/
            /**************************************************/
            
            NSNotificationCenter.defaultCenter().postNotificationName("LovedItemsNotficationIdentifier", object: nil)
            
        }
    }
    
    
    /**************************************************/
    /***********NOTIFY THE LIKE AND DISMISS************/
    /**************************************************/
    
    
    var notifyLikeAlertController : UIAlertController!
    
    func notifyUserLike() {
        
        notifyLikeAlertController = UIAlertController(title: "", message: "You like the car!", preferredStyle: UIAlertControllerStyle.Alert)
        
        presentViewController(notifyLikeAlertController, animated: true, completion: nil)
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1), target: self, selector: #selector(dismissLikeAlert), userInfo: nil, repeats: false)
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
        
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1), target: self, selector: #selector(dismissDislikeAlert), userInfo: nil, repeats: false)
    }
    
    func dismissDislikeAlert() {
        
        notifyDislikeAlertController.dismissViewControllerAnimated(true, completion: nil)
    }
    


    @IBAction func lovedDetailContactOwnerButtonAction(sender: UIButton) {
    
         performSegueWithIdentifier("LoveDetailToContactOwnerSegue", sender: self)
 
    }
    
    
    /**************************************************/
    /******************SEGUE THINGS********************/
    /**************************************************/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backToPrevious = UIBarButtonItem()
        backToPrevious.title = "Back"
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationItem.backBarButtonItem = backToPrevious
        
        if segue.identifier == "LoveDetailToContactOwnerSegue" {
            let destViewController : ContactOwnerViewController = segue.destinationViewController as! ContactOwnerViewController
            
            destViewController.singleSearchKey = singleSearchKey
            destViewController.singleSearchResult = singleSearchResult
            
            destViewController.title = "Contact Owner"
        }
    }
    
}
