//
//  SearchTableViewController.swift
//  UsedCar
//
//  Created by Yi Hsu on 2016/9/27.
//  Copyright © 2016年 Yi Hsu. All rights reserved.
//

import UIKit
import Firebase
import Haneke

class SearchTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var searchTableView: UITableView!
    
    
    var firebaseSearchResultKey : [String] = []
    var firebaseSearchResultValue : [SearchDataViewController.FirebaseSearchResultData] = []
    var firebaseSearchResultImageURLDictionary : [String : NSURL] = [ : ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1), target: self, selector: #selector(checkData), userInfo: nil, repeats: false)
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return firebaseSearchResultKey.count
        
    }
    
    func tableView(tableView: UITableView,
                   heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 143
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = searchTableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath) as! SearchTableViewCell
        
        cell.searchCellBrandLabel.text = firebaseSearchResultValue[indexPath.row].brand
        cell.searchCellColorLabel.text = firebaseSearchResultValue[indexPath.row].color
        cell.searchCellLocationLabel.text = firebaseSearchResultValue[indexPath.row].location
        cell.searchCellPriceLabel.text = String(firebaseSearchResultValue[indexPath.row].price)
        cell.searchCellMileageLabel.text = String(firebaseSearchResultValue[indexPath.row].mileage)
        
        
        cell.searchCellImageView.layer.cornerRadius = 20
        cell.searchCellImageView.alpha = 0.8
        
        
        let item = firebaseSearchResultKey[indexPath.row]
        
        if firebaseSearchResultImageURLDictionary[item] != nil {
            
            cell.searchCellImageView.hnk_setImageFromURL(firebaseSearchResultImageURLDictionary[item]!)
            
        }
        
        
        
        cell.searchCellDetailButton.layer.borderColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1).CGColor
        
        cell.searchCellDetailButton.layer.borderWidth = 1
        
        cell.searchCellDetailButton.layer.cornerRadius = 6
        
        cell.searchCellDetailButton.addTarget(self, action: #selector(viewDetail), forControlEvents: .TouchUpInside)
        
        cell.searchCellDetailButton.tag = indexPath.row
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        singleSearchKey = firebaseSearchResultKey[indexPath.row]
        
        if firebaseSearchResultImageURLDictionary[singleSearchKey] != nil {
            
            singleSearchImageURL = firebaseSearchResultImageURLDictionary[singleSearchKey]!
        }
        
        singleSearchResult = [firebaseSearchResultValue[indexPath.row]]
        
        performSegueWithIdentifier("CellDetailSegue", sender: [])
        
        searchTableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    /**************************************************/
    /******************SEGUE THINGS********************/
    /**************************************************/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backToPrevious = UIBarButtonItem()
        backToPrevious.title = "Back"
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationItem.backBarButtonItem = backToPrevious
        
        
        if segue.identifier == "CellDetailSegue" {
            let destViewController : SearchDetailViewController = segue.destinationViewController as! SearchDetailViewController
            
            destViewController.singleSearchImageURL = singleSearchImageURL
            
            destViewController.singleSearchKey = singleSearchKey
            
            destViewController.singleSearchResult = singleSearchResult
            
            destViewController.title = "Detail Information"
            
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


        performSegueWithIdentifier("CellDetailSegue", sender: sender)
        
    }
    
    
    /**************************************************/
    /***************LATE CHECKING THINGS***************/
    /**************************************************/
    
    func checkData() {
        
        if firebaseSearchResultKey.count == 0 {
            
            let alertController = UIAlertController(title: "Warning", message: "No search result matched!", preferredStyle: UIAlertControllerStyle.Alert)
            let goBackAction = UIAlertAction(title: "Go back", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
                
                self.performSegueWithIdentifier("UnwindToSearchPageFromSearchTable", sender: self)
                
            }
            alertController.addAction(goBackAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    deinit {
        print("Search Table Page : 記憶體釋放")
    }
}
