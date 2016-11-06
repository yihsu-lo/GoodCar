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
        
        searchTableView.hidden = true
        
        searchTableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(2), target: self, selector: #selector(checkData), userInfo: nil, repeats: false)
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if firebaseSearchResultKey.count != 0 {
            
            searchTableView.hidden = false
        }
        
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
        cell.searchCellImageView.clipsToBounds = true
        
        let item = firebaseSearchResultKey[indexPath.row]
        
        if firebaseSearchResultImageURLDictionary[item] != nil {
            
            cell.searchCellImageView.hnk_setImageFromURL(firebaseSearchResultImageURLDictionary[item]!)
        }
        

        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let cellIdentifier = "SearchCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,forIndexPath: indexPath) as! SearchTableViewCell
        
        cell.searchCellImageView.image = UIImage(named: "transport-7")
        
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
        backToPrevious.title = ""
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
    
}
