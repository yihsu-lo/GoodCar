//
//  MessageViewController.swift
//  UsedCar
//
//  Created by yihsu on 2016/10/24.
//  Copyright © 2016年 Yi Hsu. All rights reserved.
//

import UIKit
import Firebase

class MessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var messageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.dataSource = self
        messageTableView.delegate = self
        
        messageTableView.hidden = true
        
        messageTableView.tableFooterView = UIView(frame:  .zero)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1.5), target: self, selector: #selector(checkData), userInfo: nil, repeats: false)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        messageFirebaseID = []
        
        messageFirebaseSearchInfo = []
        
        carFirebaseSearchInfo = []
        
        messageFirebaseSearchResultImageURLDictionary = [ : ]
        
        allCarID = []
        
        uniqueCarID = []
        
        messagesText = []
        
        messagesTime = []
        
        if messageTableView != nil {
            
            messageTableView.reloadData()
        }
        
        retrieveMessageDatabase()
    }
    
    /**************************************************/
    /**********RETRIEVE MESSAGE FROM DATABASE**********/
    /**************************************************/
    
    let messageRootRef = FIRDatabase.database().referenceWithPath("message")
    
    var messageFirebaseID : [String] = []
    
    var messageFirebaseSearchInfo : [ContactOwnerViewController.FirebaseMessageData] = []
    
    var carFirebaseSearchInfo : [SearchDataViewController.FirebaseSearchResultData] = []
    
    var messageFirebaseSearchResultImageURLDictionary : [String : NSURL] = [ : ]
    
    
    var allCarID : [String] = []
    var uniqueCarID : [String] = []
    var messagesText : [String] = []
    var messagesTime : [String] = []
    
    func unique<S: SequenceType, E: Hashable where E==S.Generator.Element>(source: S) -> [E] {
        var seen: [E:Bool] = [:]
        return source.filter { seen.updateValue(true, forKey: $0) == nil }
    }
    
    
    func retrieveMessageDatabase() {
        
        if FirebaseManager.shared.firebaseUserID != "" {
            
            messageRootRef.queryOrderedByChild("messagerFirebaseID").queryEqualToValue(FirebaseManager.shared.firebaseUserID).observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                if snapshot.exists() {
                    
                    for item in [snapshot.value] {
                        
                        guard let itemDictionary = item as? NSDictionary else {
                            return
                            //                            fatalError()
                        }
                        
                        guard let firebaseItemValue = itemDictionary.allValues as? [NSDictionary] else {
                            return
                            //                            fatalError()
                        }
                        
                        
                        for item in firebaseItemValue {
                            
                            guard
                                let carID = item["carID"] as? String else {
                                    return
                                    //                    fatalError()
                            }
                            
                            self.allCarID.append(carID)
                            
                        }
                    }
                    self.uniqueCarID = self.unique(self.allCarID)
                    self.retrieveMessageDatabaseUnique()
                }
            })
            
        } else {
            let alertController = UIAlertController(title: "Warning", message: "User information is not available! Please try again!", preferredStyle: UIAlertControllerStyle.Alert)
            let goBackAction = UIAlertAction(title: "Go back", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
                
                self.tabBarController?.selectedIndex = 0
                
            }
            
            alertController.addAction(goBackAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    let dataRootRef = FIRDatabase.database().referenceWithPath("data")
    let lastRootRef = FIRDatabase.database().referenceWithPath("latestMessage")
    
    func retrieveMessageDatabaseUnique() {
        
        for item in uniqueCarID {
            
            lastRootRef.queryOrderedByKey().queryEqualToValue(item).observeSingleEventOfType(.Value, withBlock: { snapshot in
                if snapshot.exists() {
                    
                    for item in [snapshot.value] {
                        
                        guard let itemDictionary = item as? NSDictionary else {
                            
                            return
                            //                            fatalError()
                        }
                        guard let firebaseItemValue = itemDictionary.allValues as? [NSDictionary] else {
                            
                            return
                            //                            fatalError()
                        }
                        
                        for item in firebaseItemValue {
                            
                            guard
                                let updatedTextData = item["updatedText"] as? String,
                                let updatedTimeData = item["updatedTime"] as? String else {
                                    
                                    return
                                    //                                    fatalError()
                            }
                            
                            self.messagesText.append(updatedTextData)
                            self.messagesTime.append(updatedTimeData)
                        }
                        
                    }
                    
                }
            })
            
            dataRootRef.queryOrderedByKey().queryEqualToValue(item).observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                if snapshot.exists() {
                    
                    for item in [snapshot.value] {
                        
                        guard let itemDictionary = item as? NSDictionary else {
                            
                            return
                            //                            fatalError()
                        }
                        
                        guard let firebaseItemValue = itemDictionary.allValues as? [NSDictionary] else {
                            
                            return
                            //                                fatalError()
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
                                    
                                    return
                                    //                                    fatalError()
                            }
                            
                            self.carFirebaseSearchInfo.append(SearchDataViewController.FirebaseSearchResultData(brand: brandData, color: colorData, firebaseUserID: firebaseUserIDData, location: locationData, model: modelData, price: priceData, mileage: mileageData, year: yearData, time: timeData, userLink: userLinkData, userName: userNameData, facebookUserID: facebookUserIDData))
                            
                            self.retrieveMessageStorageUnique()
                            
                        }
                    }
                }
            })
        }
    }
    
    
    func retrieveMessageStorageUnique() {
        
        for item in uniqueCarID {
            
            let storage = FIRStorage.storage()
            
            let storageRef = storage.referenceForURL("gs://goodcar-47440.appspot.com/")
            let imageRef = storageRef.child(item)
            
            imageRef.downloadURLWithCompletion { (URL, error) -> Void in
                
                if (error != nil) {
                    print("retrieve storage image error: \(error)")
                    return
                } else {
                    
                    self.messageFirebaseSearchResultImageURLDictionary[item] = URL!
                    
                    if self.messageTableView != nil {
                        
                        self.messageTableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if uniqueCarID.count != 0 {
            
            messageTableView.hidden = false
        }
        return uniqueCarID.count
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 143
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = messageTableView.dequeueReusableCellWithIdentifier("MessageTableCell", forIndexPath: indexPath) as! MessageTableViewCell
        
        cell.messageTableBrandLabel.text = carFirebaseSearchInfo[indexPath.row].brand
        cell.messageTablePriceLabel.text = String(carFirebaseSearchInfo[indexPath.row].price)
        cell.messageTableMileageLabel.text = String(carFirebaseSearchInfo[indexPath.row].mileage)
        
        cell.messageTableMessageLabel.text = messagesText[indexPath.row]
        cell.messageTableTimeLabel.text = NSString(string: messagesTime[indexPath.row]).substringToIndex(16)
        
        cell.messageTableImageView.layer.cornerRadius = 20
        cell.messageTableImageView.alpha = 0.8
        
        let item = uniqueCarID[indexPath.row]
        
        //        cell.messageTableMessageLabel.text = messagesText[item]
        
        if messageFirebaseSearchResultImageURLDictionary[item] != nil {
            cell.messageTableImageView.hnk_setImageFromURL(messageFirebaseSearchResultImageURLDictionary[item]!)
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let cellIdentifier = "MessageTableCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,forIndexPath: indexPath) as! MessageTableViewCell
        
        cell.messageTableImageView.image = UIImage(contentsOfFile: "black")
        
    }
    
    
    var singleMessageKey : String = ""
    var singleMessageResult : [SearchDataViewController.FirebaseSearchResultData] = []
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if uniqueCarID != [] {
            
            singleMessageKey = uniqueCarID[indexPath.row]
            
            singleMessageResult = [carFirebaseSearchInfo[indexPath.row]]
            
            performSegueWithIdentifier("MessageContactOwnerSegue", sender: [])
        }
        
        messageTableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    
    /**************************************************/
    /***************LATE CHECKING THINGS***************/
    /**************************************************/
    
    func checkData() {
        
        if uniqueCarID.count == 0 {
            
            tabBarController?.selectedIndex = 0
        }
    }
    
    /**************************************************/
    /******************SEGUE THINGS********************/
    /**************************************************/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backToPrevious = UIBarButtonItem()
        backToPrevious.title = ""
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationItem.backBarButtonItem = backToPrevious
        
        if segue.identifier == "MessageContactOwnerSegue" {
            let destViewController : ContactOwnerViewController = segue.destinationViewController as! ContactOwnerViewController
            
            destViewController.singleSearchKey = singleMessageKey
            destViewController.singleSearchResult = singleMessageResult
            
            destViewController.title = "Message"
        }
    }
    
    
}
