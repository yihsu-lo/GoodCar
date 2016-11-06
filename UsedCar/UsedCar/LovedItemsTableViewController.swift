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

        lovedItemsTableView.hidden = true
        
        lovedItemsTableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(2), target: self, selector: #selector(checkData), userInfo: nil, repeats: false)
    
    }
    
    
    var firebaseLikesAutoID : [String] = []
    var firebaseSearchInfo : [SearchDataViewController.FirebaseSearchResultData] = []
    var firebaseSearchResultImageURLDictionary : [String : NSURL] = [ : ]
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if firebaseLikesAutoID.count != 0 {
            
            lovedItemsTableView.hidden = false
        }
        
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
        cell.lovedItemsCellImageView.clipsToBounds = true
        
        let item = firebaseLikesAutoID[indexPath.row]
        
        if firebaseSearchResultImageURLDictionary[item] != nil {
            
            cell.lovedItemsCellImageView.hnk_setImageFromURL(firebaseSearchResultImageURLDictionary[item]!)
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let cellIdentifier = "LovedItemsCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,forIndexPath: indexPath) as! LovedItemsTableViewCell
        
        cell.lovedItemsCellImageView.image = UIImage(named: "black")
        
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
    
    /**************************************************/
    /******************SEGUE THINGS********************/
    /**************************************************/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backToPrevious = UIBarButtonItem()
        backToPrevious.title = ""
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationItem.backBarButtonItem = backToPrevious
        
        if segue.identifier == "LovedItemsDetailSegue" {
            let destViewController : SearchDetailViewController = segue.destinationViewController as! SearchDetailViewController
            
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
    

}
