//
//  MySellingItemsTableViewController.swift
//  UsedCar
//
//  Created by Yi Hsu on 2016/10/3.
//  Copyright © 2016年 Yi Hsu. All rights reserved.
//

import UIKit
import Haneke
import Firebase

class MySellingItemsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mySellingItemsTableView: UITableView!
    
    
    var firebaseSearchResultKey : [String] = []
    var firebaseSearchResultValue : [SearchDataViewController.FirebaseSearchResultData] = []
    var firebaseSearchResultImageURLDictionary : [String : NSURL] = [ : ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mySellingItemsTableView.dataSource = self
        mySellingItemsTableView.delegate = self
        
        mySellingItemsTableView.hidden = true
        
        mySellingItemsTableView.tableFooterView = UIView(frame: .zero)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(2), target: self, selector: #selector(checkData), userInfo: nil, repeats: false)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if firebaseSearchResultKey.count != 0 {
            
            mySellingItemsTableView.hidden = false
            
        }
        
        return firebaseSearchResultKey.count
    }
    
    func tableView(tableView: UITableView,
                   heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 143
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = mySellingItemsTableView.dequeueReusableCellWithIdentifier("MySellingItemsCell", forIndexPath: indexPath) as! MySellingItemsTableViewCell
        
        cell.mySellingItemsCellBrandLabel.text = firebaseSearchResultValue[indexPath.row].brand
        cell.mySellingItemsCellColorLabel.text = firebaseSearchResultValue[indexPath.row].color
        cell.mySellingItemsCellLocationLabel.text = firebaseSearchResultValue[indexPath.row].location
        cell.mySellingItemsCellPriceLabel.text = String(firebaseSearchResultValue[indexPath.row].price)
        cell.mySellingItemsCellMileageLabel.text = String(firebaseSearchResultValue[indexPath.row].mileage)
        
        cell.mySellingItemsCellImageView.layer.cornerRadius = 20
        cell.mySellingItemsCellImageView.alpha = 0.8
        cell.mySellingItemsCellImageView.clipsToBounds = true
        
        let item = firebaseSearchResultKey[indexPath.row]
        
        
        if firebaseSearchResultImageURLDictionary[item] != nil {
            
            cell.mySellingItemsCellImageView.hnk_setImageFromURL(self.firebaseSearchResultImageURLDictionary[item]!)
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let cellIdentifier = "MySellingItemsCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,forIndexPath: indexPath) as! MySellingItemsTableViewCell
        
        cell.mySellingItemsCellImageView.image = UIImage(named: "black")
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        singleSearchKey = firebaseSearchResultKey[indexPath.row]
        
        if firebaseSearchResultImageURLDictionary[singleSearchKey] != nil {
            
            singleSearchImageURL = firebaseSearchResultImageURLDictionary[singleSearchKey]!
        }
        
        singleSearchResult = [firebaseSearchResultValue[indexPath.row]]
        
        performSegueWithIdentifier("MySellingItemsDetailSegue", sender: [])
        
        mySellingItemsTableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    /**************************************************/
    /***************DELETE ROW ACTION******************/
    /**************************************************/
    
    let dataRootRef = FIRDatabase.database().referenceWithPath("data")
    let storageRef = FIRStorage.storage().referenceForURL("gs://goodcar-47440.appspot.com/")
    
    
    var allMessageID : [String] = []
    var allLikesID : [String] = []
    var allTokenID : [String] = []
    
    let messageRootRef = FIRDatabase.database().referenceWithPath("message")
    let likesRootRef = FIRDatabase.database().referenceWithPath("likes")
    let tokenRootRef = FIRDatabase.database().referenceWithPath("userToken")
    
    let lastRootRef = FIRDatabase.database().referenceWithPath("latestMessage")
    
    func tableView(tablewView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        singleSearchKey = firebaseSearchResultKey[indexPath.row]
        
        singleSearchImageURL = firebaseSearchResultImageURLDictionary[singleSearchKey]!
        
        singleSearchResult = [firebaseSearchResultValue[indexPath.row]]
        
        
        /**************************************************/
        /*************GET MESSAGE & LIKES ID***************/
        /**************************************************/
        
        messageHandler = messageRootRef.queryOrderedByChild("carID").queryEqualToValue(singleSearchKey).observeEventType(.Value, withBlock: { snapshot in
            
            if snapshot.exists() {
                
                for item in [snapshot.value] {
                    guard let itemDictionary = item as? NSDictionary else {
                        
                        return
                        //                        fatalError()
                    }
                    guard let firebaseItemKey = itemDictionary.allKeys as? [String] else {
                        
                        return
                        //                        fatalError()
                    }
                    self.allMessageID = firebaseItemKey
                    
                }
            }
            
        })
        
        likesHandler = likesRootRef.queryOrderedByChild("dataID").queryEqualToValue(singleSearchKey).observeEventType(.Value, withBlock: { snapshot in
            
            if snapshot.exists() {
                
                for item in [snapshot.value] {
                    guard let itemDictionary = item as? NSDictionary else {
                        
                        return
                        //                        fatalError()
                    }
                    guard let firebaseItemKey = itemDictionary.allKeys as? [String] else {
                        
                        return
                        //                      fatalError()
                    }
                    self.allLikesID = firebaseItemKey
                }
            }
        })
        
        tokenHandler = tokenRootRef.queryOrderedByChild("carID").queryEqualToValue(singleSearchKey).observeEventType(.Value, withBlock: { snapshot in
            
            if snapshot.exists() {
                
                for item in [snapshot.value] {
                    guard let itemDictionary = item as? NSDictionary else {
                        
                        return
                        //                        fatalError()
                    }
                    guard let firebaseItemKey = itemDictionary.allKeys as? [String] else {
                        
                        return
                        //                      fatalError()
                    }
                    self.allTokenID = firebaseItemKey
                }
            }
            
        })
        
        
        if editingStyle == .Delete {
            
            let alertController = UIAlertController(title: "Warning", message: "Are you sure you want to DELETE the Good Car?", preferredStyle: UIAlertControllerStyle.Alert)
            
            //SURE
            let confirmAction = UIAlertAction(title: "Yes I am sure!", style: .Destructive) { (result : UIAlertAction) -> Void in
                
                self.storageRef.child(self.singleSearchKey).deleteWithCompletion {
                    (error) -> Void in
                    
                    if (error != nil) {
                        
                        print("Deleting image error: \(error)")
                        
                    } else {
                        
                        self.dataRootRef.child(self.singleSearchKey).removeValue()
                        self.lastRootRef.child(self.singleSearchKey).removeValue()
                        
                        for singleMessageID in self.allMessageID {
                            
                            self.messageRootRef.child(singleMessageID).removeValue()
                        }
                        
                        for singleLikesID in self.allLikesID {
                            
                            self.likesRootRef.child(singleLikesID).removeValue()
                        }
                        
                        for singleTokenID in self.allTokenID {
                            
                            self.tokenRootRef.child(singleTokenID).removeValue()
                        }
                        
                        print("delete data success")
                        
                        self.firebaseSearchResultKey.removeAtIndex(indexPath.row)
                        
                        self.firebaseSearchResultValue.removeAtIndex(indexPath.row)
                        
                        self.firebaseSearchResultImageURLDictionary.removeValueForKey(self.singleSearchKey)
                        
                        self.mySellingItemsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                        
                        if self.mySellingItemsTableView != nil {
                            
                            self.mySellingItemsTableView.reloadData()
                        }
                    }
                    
                }
            }
            
            //NOT SURE
            let goBackAction = UIAlertAction(title: "No I am not sure...", style: .Default) { (result : UIAlertAction) -> Void in
                
            }
            
            alertController.addAction(confirmAction)
            alertController.addAction(goBackAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            
        } else if editingStyle == .Insert {
            
            
        }
    }
    
    var singleSearchResult : [SearchDataViewController.FirebaseSearchResultData] = []
    
    var singleSearchKey : String = ""
    var singleSearchImageURL : NSURL = NSURL()
    
    
    /**************************************************/
    /******************SEGUE THINGS********************/
    /**************************************************/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backToPrevious = UIBarButtonItem()
        backToPrevious.title = ""
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationItem.backBarButtonItem = backToPrevious
        
        
        if segue.identifier == "MySellingItemsDetailSegue" {
            let destViewController : MySellingItemsDetailViewController = segue.destinationViewController as! MySellingItemsDetailViewController
            
            destViewController.singleSearchKey = singleSearchKey
            
            destViewController.singleSearchResult = singleSearchResult
            
            destViewController.singleSearchImageURL = singleSearchImageURL
            
            destViewController.title = "Detail Information"
            
        }
        
    }
    
    
    /**************************************************/
    /***************LATE CHECKING THINGS***************/
    /**************************************************/
    
    func checkData() {
        
        if firebaseSearchResultKey.count == 0 {
            
            let alertController = UIAlertController(title: "Warning", message: "No loved item available!", preferredStyle: UIAlertControllerStyle.Alert)
            let goBackAction = UIAlertAction(title: "Go back", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
                
                self.performSegueWithIdentifier("UnwindToProfileFromLovedItemsTable", sender: self)
                
            }
            alertController.addAction(goBackAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    private var messageHandler : FIRDatabaseHandle!
    
    private var likesHandler : FIRDatabaseHandle!
    
    private var tokenHandler : FIRDatabaseHandle!
    
    deinit {
        
        if messageHandler != nil {
            
            self.messageRootRef.child("message").removeObserverWithHandle(messageHandler)
        }
        
        if likesHandler != nil {
            self.likesRootRef.child("likes").removeObserverWithHandle(likesHandler)
        }
        
        if tokenHandler != nil {
            self.tokenRootRef.child("userToken").removeObserverWithHandle(tokenHandler)
        }
    }
    
}
