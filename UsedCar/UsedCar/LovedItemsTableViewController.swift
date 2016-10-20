//
//  LovedItemsTableViewController.swift
//  UsedCar
//
//  Created by Yi Hsu on 2016/10/7.
//  Copyright © 2016年 Yi Hsu. All rights reserved.
//

import UIKit
import Firebase
import Haneke

class LovedItemsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var lovedItemsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lovedItemsTableView.dataSource = self
        lovedItemsTableView.delegate = self
        
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1.5), target: self, selector: #selector(checkData), userInfo: nil, repeats: false)
        
    }
    
    
    
    var firebaseLikesAutoID : [String] = []
    var firebaseSearchInfo : [SearchDataViewController.FirebaseSearchResultData] = []
    var firebaseSearchResultImageURLDictionary : [String : NSURL] = [ : ]
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return firebaseLikesAutoID.count
    }
    
    func tableView(tableView: UITableView,
                   heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 143
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = lovedItemsTableView.dequeueReusableCellWithIdentifier("LovedItemsCell", forIndexPath: indexPath) as! LovedItemsTableViewCell
        
        cell.lovedItemsCellBrandLabel.text = firebaseSearchInfo[indexPath.row].brand
        cell.lovedItemsCellColorLabel.text = firebaseSearchInfo[indexPath.row].color
        cell.lovedItemsCellLocationLabel.text = firebaseSearchInfo[indexPath.row].location
        cell.lovedItemsCellPriceLabel.text = String(firebaseSearchInfo[indexPath.row].price)
        cell.lovedItemsCellMileageLabel.text = String(firebaseSearchInfo[indexPath.row].mileage)
        
        cell.lovedItemsCellImageView.layer.cornerRadius = 20
        cell.lovedItemsCellImageView.alpha = 0.8
        
        let item = firebaseLikesAutoID[indexPath.row]
        
        if firebaseSearchResultImageURLDictionary[item] != nil {
            
            cell.lovedItemsCellImageView.hnk_setImageFromURL(firebaseSearchResultImageURLDictionary[item]!)
        }
        
        cell.lovedItemsCellDetailButton.layer.borderColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1).CGColor
        
        cell.lovedItemsCellDetailButton.layer.borderWidth = 1
        cell.lovedItemsCellDetailButton.layer.cornerRadius = 6
        cell.lovedItemsCellDetailButton.addTarget(self, action: #selector(viewDetail), forControlEvents: .TouchUpInside)
        cell.lovedItemsCellDetailButton.tag = indexPath.row
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if firebaseLikesAutoID != [] {
            
            singleSearchKey = firebaseLikesAutoID[indexPath.row]
            
            singleSearchResult = [firebaseSearchInfo[indexPath.row]]
            
        }
        
        if firebaseSearchResultImageURLDictionary[singleSearchKey] != nil {
            
            singleSearchImageURL = firebaseSearchResultImageURLDictionary[singleSearchKey]!
            
            performSegueWithIdentifier("LovedItemsDetailSegue", sender: [])
        }

        lovedItemsTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    var singleSearchResult : [SearchDataViewController.FirebaseSearchResultData] = []
    
    var singleSearchKey : String = ""
    var singleSearchImageURL : NSURL = NSURL()
    
    func viewDetail(sender: UIButton) {
        
        singleSearchKey = firebaseLikesAutoID[sender.tag]
        
        singleSearchResult = [firebaseSearchInfo[Int(sender.tag)]]
        
        if firebaseSearchResultImageURLDictionary[singleSearchKey] != nil {
            
            singleSearchImageURL = firebaseSearchResultImageURLDictionary[singleSearchKey]!
         
            performSegueWithIdentifier("LovedItemsDetailSegue", sender: sender)
            
        }
        
    }
    
    
    /**************************************************/
    /******************SEGUE THINGS********************/
    /**************************************************/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backToPrevious = UIBarButtonItem()
        backToPrevious.title = "Back"
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationItem.backBarButtonItem = backToPrevious
        
        if segue.identifier == "LovedItemsDetailSegue" {
            let destViewController : LovedItemsDetailViewController = segue.destinationViewController as! LovedItemsDetailViewController
            
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
        
        if firebaseLikesAutoID.count == 0 {
            
            let alertController = UIAlertController(title: "Warning", message: "No loved item available!", preferredStyle: UIAlertControllerStyle.Alert)
            let goBackAction = UIAlertAction(title: "Go back", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
                
                self.performSegueWithIdentifier("UnwindToProfileFromLovedItemsTable", sender: self)
                
            }
            alertController.addAction(goBackAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    deinit {
        
        print("Loved Items Table Page : 記憶體釋放")
    }
    
}
