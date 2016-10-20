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
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1.5), target: self, selector: #selector(checkData), userInfo: nil, repeats: false)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
        
        
        let item = firebaseSearchResultKey[indexPath.row]
        
        if firebaseSearchResultImageURLDictionary[item] != nil {
            
            cell.mySellingItemsCellImageView.hnk_setImageFromURL(firebaseSearchResultImageURLDictionary[item]!)
            
        }
        
        cell.mySellingItemsCellDetailButton.layer.borderColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1).CGColor
        cell.mySellingItemsCellDetailButton.layer.borderWidth = 1
        cell.mySellingItemsCellDetailButton.layer.cornerRadius = 6
        cell.mySellingItemsCellDetailButton.addTarget(self, action: #selector(viewDetail), forControlEvents: .TouchUpInside)
        cell.mySellingItemsCellDetailButton.tag = indexPath.row
        
        return cell
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
    
    let rootRef = FIRDatabase.database().referenceWithPath("data")
    let storageRef = FIRStorage.storage().referenceForURL("gs://usedcar-8e0f0.appspot.com")
    
    
    func tableView(tablewView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        singleSearchKey = firebaseSearchResultKey[indexPath.row]
        
        singleSearchImageURL = firebaseSearchResultImageURLDictionary[singleSearchKey]!
        
        singleSearchResult = [firebaseSearchResultValue[indexPath.row]]
        
        
        if editingStyle == .Delete {
            
            let alertController = UIAlertController(title: "Warning", message: "Are you sure you want to DELETE the Good Car?", preferredStyle: UIAlertControllerStyle.Alert)
            
            //SURE
            let confirmAction = UIAlertAction(title: "Yes I am sure!", style: .Destructive) { (result : UIAlertAction) -> Void in
                
                self.storageRef.child(self.singleSearchKey).deleteWithCompletion {
                    (error) -> Void in
                    
                    if (error != nil) {
                        
                        print("Deleting image error: \(error)")
                        
                    } else {
                        
                        self.rootRef.child(self.singleSearchKey).removeValue()
                        
                        print("delete data success")
                        
                        
                        self.firebaseSearchResultKey.removeAtIndex(indexPath.row)
                        
                        self.firebaseSearchResultValue.removeAtIndex(indexPath.row)
                        self.firebaseSearchResultImageURLDictionary.removeValueForKey(self.singleSearchKey)
                        
                        self.mySellingItemsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                        
                        self.mySellingItemsTableView.reloadData()
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
    
    func viewDetail(sender: UIButton!) {
        
        singleSearchKey = firebaseSearchResultKey[sender.tag]
        
        if firebaseSearchResultImageURLDictionary[singleSearchKey] != nil {
            
            singleSearchImageURL = firebaseSearchResultImageURLDictionary[singleSearchKey]!
        }
        
        singleSearchResult = [firebaseSearchResultValue[Int(sender.tag)]]
        
        performSegueWithIdentifier("MySellingItemsDetailSegue", sender: sender)
    }
    
    
    /**************************************************/
    /******************SEGUE THINGS********************/
    /**************************************************/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backToPrevious = UIBarButtonItem()
        backToPrevious.title = "Back"
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
    
    
    
    deinit {
        
        print("Selling Table Page : 記憶體釋放")
    }
    
    
}
