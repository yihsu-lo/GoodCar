//
//  ProfileViewController.swift
//  UsedCar
//
//  Created by Yi Hsu on 2016/9/27.
//  Copyright © 2016年 Yi Hsu. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import SafariServices
import Firebase
import Haneke



class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    
    @IBOutlet weak var imageBackgroundView: UIView!
    
    @IBOutlet weak var profileSellingItemsButton: UIButton!
    
    @IBOutlet weak var profileLovedItemsButton: UIButton!
    
    
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if Reachability.isConnectedToNetwork() != true {
            
            let alertController = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.Alert)
            let goBackAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(goBackAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
        
        
        
        mySellingFirebaseSearchInfo = []
        
        mySellingFirebaseSearchResultKey = []
        
        mySellingFirebaseSearchResultImageURLDictionary = [ : ]
        
        likesFirebaseSearchInfo = []
        
        likesFirebaseLikesAutoID = []
        
        likesFirebaseSearchResultImageURLDictionary = [ : ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color1 = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        let color2 = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.locations = [0.0, 1.0]
        gradient.colors = [color1.CGColor, color2.CGColor]
        
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
        imageBackgroundView.layer.cornerRadius = imageBackgroundView.frame.size.width / 2
        imageBackgroundView.layer.borderColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1).CGColor
        imageBackgroundView.layer.borderWidth = 1.0
        imageBackgroundView.layer.shadowColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1).CGColor
        
        imageBackgroundView.layer.shadowRadius = 10
        imageBackgroundView.layer.shadowOffset = CGSizeMake(0, 2)
        imageBackgroundView.layer.shadowOpacity = 0.5
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        
        imageBackgroundView.addSubview(profileImageView)
        
        profileSellingItemsButton.backgroundColor = UIColor(red: 30/255, green: 130/255, blue: 150/255, alpha: 1)
        profileSellingItemsButton.layer.cornerRadius = 20
        profileSellingItemsButton.tintColor = UIColor.whiteColor()
        
        
        profileLovedItemsButton.backgroundColor = UIColor(red: 10/255, green: 99/255, blue: 117/255, alpha: 1)
        
        profileLovedItemsButton.layer.cornerRadius = 20
        profileLovedItemsButton.tintColor = UIColor.whiteColor()
        
        
        profileNameLabel.clipsToBounds = true
        
        profileNameLabel.backgroundColor = UIColor(red: 72/255, green: 159/255, blue: 176/255, alpha: 1)
        profileNameLabel.layer.cornerRadius = 20
        profileNameLabel.tintColor = UIColor.whiteColor()
        
        
        if let userProfilePicURL = defaults.objectForKey("picture") as? String {
            let url = NSURL(string: userProfilePicURL)
            
            profileImageView.hnk_setImageFromURL(url!)
        }
        
        
        if let userNameText = defaults.objectForKey("name") as? String {
            profileNameLabel.text = userNameText
        } else {
            profileNameLabel.text = "User name unknown"
        }
        
        let tapNameLabel = UITapGestureRecognizer(target: self, action: #selector(showFacebookPage))
        profileNameLabel.addGestureRecognizer(tapNameLabel)
        profileNameLabel.userInteractionEnabled = true
        
        
        
        /**************************************************/
        /******MONITOR UPDATES IN LOVED ITEMS DETAIL*******/
        /**************************************************/
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(receieveUpdatedLovedItemsNotfication), name: "LovedItemsNotficationIdentifier", object: nil)
        
    }
    
    
    /**************************************************/
    /******MONITOR UPDATES IN LOVED ITEMS DETAIL*******/
    /**************************************************/
    
    func receieveUpdatedLovedItemsNotfication(notification: NSNotification) {
        
        likesFirebaseLikesAutoID = []
        
        likesFirebaseSearchInfo = []
        
        likesFirebaseSearchResultImageURLDictionary = [ : ]
        
        retrieveLikesDataID()
    }
    
    
    
    /**************************************************/
    /****RETRIEVE DATA THINGS---DATABASE & STORAGE*****/
    /**************************************************/
    
    
    var mySellingFirebaseSearchInfo : [SearchDataViewController.FirebaseSearchResultData] = []
    
    var mySellingTableViewController : MySellingItemsTableViewController = MySellingItemsTableViewController()
    
    var mySellingFirebaseSearchResultKey : [String] = []
    
    var mySellingFirebaseSearchResultImageURLDictionary : [String : NSURL] = [ : ]
    
    let mySellingrootRef = FIRDatabase.database().referenceWithPath("data")
    
    
    
    @IBAction func profileSellingItemsButton(sender: UIButton) {
        
        mySellingRetrieveDatabaseData()
        
    }
    
    /**************************************************/
    /*****************RETRIEVE DATABASE****************/
    /**************************************************/
    
    func mySellingRetrieveDatabaseData() {
        
        if FirebaseManager.shared.firebaseUserID != "" {
            
            mySellingrootRef.queryOrderedByChild("firebaseUserID").queryEqualToValue(FirebaseManager.shared.firebaseUserID).observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                if snapshot.exists() {
                    
                    self.performSegueWithIdentifier("MySellingItemsTableSegue", sender: self)
                    
                    for item in [snapshot.value] {
                        
                        guard let itemDictionary = item as? NSDictionary else {
                            fatalError()
                        }
                        
                        guard let firebaseItemKey = itemDictionary.allKeys as? [String] else {
                            fatalError()
                        }
                        
                        self.mySellingFirebaseSearchResultKey = firebaseItemKey
                        
                        guard let firebaseItemValue = itemDictionary.allValues as? [NSDictionary] else {
                            fatalError()
                        }
                        
                        for item in firebaseItemValue {
                            
                            guard let brandData = item["brand"] as? String,
                                let colorData = item["color"] as? String,
                                let firebaseUserIDData = item["firebaseUserID"] as? String,
                                let locationData = item["location"] as? String,
                                let modelData = item["model"] as? String,
                                let priceData = item["price"] as? Int,
                                let mileageData = item["mileage"] as? Int,
                                let yearData = item["year"] as? String,
                                let timeData = item["time"] as? String,
                                let userLinkData = item["userLink"] as? String,
                                let userNameData = item["userName"] as? String,
                                let facebookUserIDData = item["facebookUserID"] as? String else {
                                    
                                    fatalError()
                            }
                            
                            self.mySellingFirebaseSearchInfo.append(SearchDataViewController.FirebaseSearchResultData(brand: brandData, color: colorData, firebaseUserID: firebaseUserIDData, location: locationData, model: modelData, price: priceData, mileage: mileageData, year: yearData, time: timeData, userLink: userLinkData, userName: userNameData, facebookUserID: facebookUserIDData))
                        }
                        
                    }
                    
                    self.mySellingRetrieveStorageData()
                    
                    self.mySellingTableViewController.firebaseSearchResultValue = self.mySellingFirebaseSearchInfo
                    
                    self.mySellingTableViewController.firebaseSearchResultKey = self.mySellingFirebaseSearchResultKey
                    
                } else {
                    
                    let alertController = UIAlertController(title: "Warning", message: "No selling item available!", preferredStyle: UIAlertControllerStyle.Alert)
                    let goBackAction = UIAlertAction(title: "Go back", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
                    }
                    alertController.addAction(goBackAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
            })
            
        } else {
            
            let alertController = UIAlertController(title: "Warning", message: "User information is not available!", preferredStyle: UIAlertControllerStyle.Alert)
            let goBackAction = UIAlertAction(title: "Go back", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
                
            }
            
            alertController.addAction(goBackAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    /**************************************************/
    /****************RETRIEVE STORAGE DATA*************/
    /**************************************************/
    
    func mySellingRetrieveStorageData() {
        
        for item in mySellingFirebaseSearchResultKey {
            
            let storage = FIRStorage.storage()
            
            let storageRef = storage.referenceForURL("gs://usedcar-8e0f0.appspot.com/")
            
            let imageRef = storageRef.child(item)
            
            imageRef.downloadURLWithCompletion { (URL, error) -> Void in
                
                if (error != nil) {
                    
                    print("retrieve storage image error in profile page: \(error)")
                    
                    return
                    
                } else {
                    
                    self.mySellingFirebaseSearchResultImageURLDictionary[item] = URL!
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        
                        if self.mySellingTableViewController.mySellingItemsTableView != nil {
                            
                            self.mySellingTableViewController.mySellingItemsTableView.reloadData()
                            
                        }
                    }
                }
                
                self.mySellingTableViewController.firebaseSearchResultImageURLDictionary = self.mySellingFirebaseSearchResultImageURLDictionary
            }
            
        }
    }
    
    /**************************************************/
    /****************SHOW FACEBOOK PAGE****************/
    /**************************************************/
    
    
    func showFacebookPage() {
        
        guard let userLinkString = defaults.objectForKey("link") as? String else { return }
        
        guard let userLinkURL: NSURL = NSURL(string: userLinkString) else { return }
        
        //confirm iOS version
        if (NSString(string: UIDevice.currentDevice().systemVersion).doubleValue >= 9) {
            
            let safariVC = SFSafariViewController(URL: userLinkURL)
            
            presentViewController(safariVC, animated: true, completion: nil)
            
        } else {
            UIApplication.sharedApplication().openURL(userLinkURL)
        }
    }
    
    
    
    /**************************************************/
    /****RETRIEVE DATA THINGS---DATABASE & STORAGE*****/
    /**************************************************/
    
    
    /**************************************************/
    /*******RETRIEVE LIKES DATA ID FROM DATABASE*******/
    /**************************************************/
    
    let likesRootRef = FIRDatabase.database().referenceWithPath("likes")
    
    var likesFirebaseLikesAutoID : [String] = []
    
    var lovedItemsTableViewController : LovedItemsTableViewController = LovedItemsTableViewController()
    
    @IBAction func profileLovedItemsButton(sender: UIButton) {
        
        retrieveLikesDataID()
        
        performSegueWithIdentifier("LovedItemsTableSegue", sender: self)
        
    }
    
    func retrieveLikesDataID() {
        
        if FirebaseManager.shared.firebaseUserID != "" {
            likesRootRef.queryOrderedByChild("firebaseUserID").queryEqualToValue(FirebaseManager.shared.firebaseUserID).observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                
                if snapshot.exists() {
                    
                    for item in [snapshot.value] {
                        
                        guard let itemDictionary = item as? NSDictionary else {
                            fatalError()
                        }
                        
                        guard let likesItemDictionary = itemDictionary.allValues as? [NSDictionary] else {
                            fatalError()
                        }
                        
                        for item in likesItemDictionary {
                            self.likesFirebaseLikesAutoID.append(String(item["dataID"]!))
                        }
                    }
                    
                    self.likesRetrieveDatabaseData()
                    
                } else {
                    
                    self.likesFirebaseLikesAutoID = []
                    
                    self.lovedItemsTableViewController.firebaseLikesAutoID = self.likesFirebaseLikesAutoID
                    
                    self.lovedItemsTableViewController.lovedItemsTableView.reloadData()
                    
                }
            })
            
        } else {
            
            let alertController = UIAlertController(title: "Warning", message: "User information is not available!", preferredStyle: UIAlertControllerStyle.Alert)
            let goBackAction = UIAlertAction(title: "Go back", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
                
            }
            
            alertController.addAction(goBackAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    /**************************************************/
    /***********RETRIEVE LIKES DATABASE DATA***********/
    /**************************************************/
    
    
    var likesFirebaseSearchInfo : [SearchDataViewController.FirebaseSearchResultData] = []
    
    var likesFirebaseSearchResultImageURLDictionary : [String : NSURL] = [ : ]
    
    let dataRootRef = FIRDatabase.database().referenceWithPath("data")
    
    
    func likesRetrieveDatabaseData() {
        
        for index in 0..<likesFirebaseLikesAutoID.count {
            
            let singleID = likesFirebaseLikesAutoID[index]
            
            dataRootRef.queryOrderedByKey().queryEqualToValue(singleID).observeSingleEventOfType(.ChildAdded, withBlock: { snapshot in
                
                guard let firebaseItemValue = snapshot.value as? NSDictionary else {
                    
                    fatalError()
                }
                
                guard let brandData = firebaseItemValue["brand"] as? String,
                    let colorData = firebaseItemValue["color"] as? String,
                    let firebaseUserIDData = firebaseItemValue["firebaseUserID"] as? String,
                    let locationData = firebaseItemValue["location"] as? String,
                    let modelData = firebaseItemValue["model"] as? String,
                    let priceData = firebaseItemValue["price"] as? Int,
                    let mileageData = firebaseItemValue["mileage"] as? Int,
                    let yearData = firebaseItemValue["year"] as? String,
                    let timeData = firebaseItemValue["time"] as? String,
                    let userLinkData = firebaseItemValue["userLink"] as? String,
                    let userNameData = firebaseItemValue["userName"] as? String,
                    let facebookUserIDData = firebaseItemValue["facebookUserID"] as? String else {
                        
                        fatalError()
                }
                
                self.likesFirebaseSearchInfo.append(SearchDataViewController.FirebaseSearchResultData(brand: brandData, color: colorData, firebaseUserID: firebaseUserIDData, location: locationData, model: modelData, price: priceData, mileage: mileageData, year: yearData, time: timeData, userLink: userLinkData, userName: userNameData, facebookUserID: facebookUserIDData))
                
                
                if index >= (self.likesFirebaseLikesAutoID.count - 1) {
                    
                    self.likesRetrieveStorageData()
                    
                    self.lovedItemsTableViewController.firebaseSearchInfo = self.likesFirebaseSearchInfo
                    self.lovedItemsTableViewController.firebaseLikesAutoID = self.likesFirebaseLikesAutoID
                }
            })
        }
    }
    
    /**************************************************/
    /************RETRIEVE LIKES STORAGE DATA***********/
    /**************************************************/
    
    
    func likesRetrieveStorageData() {
        
        for item in likesFirebaseLikesAutoID {
            
            let storage = FIRStorage.storage()
            
            let storageRef = storage.referenceForURL("gs://usedcar-8e0f0.appspot.com/")
            
            let imageRef = storageRef.child(item)
            
            imageRef.downloadURLWithCompletion { (URL, error) -> Void in
                
                if (error != nil) {
                    
                    print("retrieve storafy image error in profile page: \(error)")
                    
                    return
                    
                } else {
                    
                    self.likesFirebaseSearchResultImageURLDictionary[item] = URL!
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        if self.lovedItemsTableViewController.lovedItemsTableView != nil {
                            
                            self.lovedItemsTableViewController.lovedItemsTableView.reloadData()
                        }
                    }
                }
                
                self.lovedItemsTableViewController.firebaseSearchResultImageURLDictionary = self.likesFirebaseSearchResultImageURLDictionary
            }
        }
        
    }
    
    /**************************************************/
    /******************SEGUE THINGS********************/
    /**************************************************/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "MySellingItemsTableSegue" {
            let destViewController: MySellingItemsTableViewController = segue.destinationViewController as! MySellingItemsTableViewController
            
            let backToPrevious = UIBarButtonItem()
            backToPrevious.title = "Back"
            navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            navigationItem.backBarButtonItem = backToPrevious
            destViewController.title = "My Selling Cars"
            
            destViewController.firebaseSearchResultKey = mySellingFirebaseSearchResultKey
            
            destViewController.firebaseSearchResultValue = mySellingFirebaseSearchInfo
            
            destViewController.firebaseSearchResultImageURLDictionary = mySellingFirebaseSearchResultImageURLDictionary
            
            mySellingTableViewController = destViewController
        }
        
        
        if segue.identifier == "LovedItemsTableSegue" {
            let destViewController: LovedItemsTableViewController = segue.destinationViewController as! LovedItemsTableViewController
            
            let backToPrevious = UIBarButtonItem()
            backToPrevious.title = "Back"
            navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            navigationItem.backBarButtonItem = backToPrevious
            destViewController.title = "Loved Cars"
            
            destViewController.firebaseLikesAutoID = likesFirebaseLikesAutoID
            destViewController.firebaseSearchInfo = likesFirebaseSearchInfo
            destViewController.firebaseSearchResultImageURLDictionary = likesFirebaseSearchResultImageURLDictionary
            
            lovedItemsTableViewController = destViewController
        }
    }
    
    
    /**************************************************/
    /**************UNWIND SEGUE THINGS*****************/
    /**************************************************/
    
    @IBAction func unwindToProfileFromEditUpdatePage(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindToProfileFromSellingTable(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindToProfileFromLovedItemsPage(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindToProfileFromLovedItemsTable(segue: UIStoryboardSegue) {
        
    }
  
}



