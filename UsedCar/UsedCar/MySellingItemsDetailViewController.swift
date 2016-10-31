//
//  MySellingItemsDetailViewController.swift
//  UsedCar
//
//  Created by Yi Hsu on 2016/10/3.
//  Copyright © 2016年 Yi Hsu. All rights reserved.
//

import UIKit
import Haneke

class MySellingItemsDetailViewController: UIViewController {

    
    @IBOutlet weak var mySellingDetailImageView: UIImageView!
    
    @IBOutlet weak var mySellingBrandValueLabel: UILabel!
    
    @IBOutlet weak var mySellingYearValueLabel: UILabel!

    @IBOutlet weak var mySellingModelValueLabel: UILabel!
    
    @IBOutlet weak var mySellingColorValueLabel: UILabel!
    
    @IBOutlet weak var mySellingMileageValueLabel: UILabel!
    
    @IBOutlet weak var mySellingLocationValueLabel: UILabel!
    
    @IBOutlet weak var mySellingPriceValueLabel: UILabel!
    
    @IBOutlet weak var mySellingTimeValueLabel: UILabel!
    
    @IBOutlet weak var mySellingEditButton: UIButton!
    
    
    
    
    var singleSearchKey : String = ""
    var singleSearchResult : [SearchDataViewController.FirebaseSearchResultData] = []
    var singleSearchImageURL : NSURL = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mySellingBrandValueLabel.layer.cornerRadius = 10
        mySellingYearValueLabel.layer.cornerRadius = 10
        mySellingModelValueLabel.layer.cornerRadius = 10
        mySellingColorValueLabel.layer.cornerRadius = 10
        mySellingMileageValueLabel.layer.cornerRadius = 10
        mySellingLocationValueLabel.layer.cornerRadius = 10
        mySellingPriceValueLabel.layer.cornerRadius = 10
        mySellingTimeValueLabel.layer.cornerRadius = 10
        
        mySellingBrandValueLabel.clipsToBounds = true
        mySellingYearValueLabel.clipsToBounds = true
        mySellingModelValueLabel.clipsToBounds = true
        mySellingColorValueLabel.clipsToBounds = true
        mySellingMileageValueLabel.clipsToBounds = true
        mySellingLocationValueLabel.clipsToBounds = true
        mySellingPriceValueLabel.clipsToBounds = true
        mySellingTimeValueLabel.clipsToBounds = true
        
        mySellingBrandValueLabel.text = singleSearchResult[0].brand
        mySellingYearValueLabel.text = singleSearchResult[0].year
        mySellingModelValueLabel.text = singleSearchResult[0].model
        mySellingColorValueLabel.text = singleSearchResult[0].color
        mySellingMileageValueLabel.text = String(singleSearchResult[0].mileage)
        mySellingLocationValueLabel.text = singleSearchResult[0].location
        mySellingPriceValueLabel.text = String(singleSearchResult[0].price)
        mySellingTimeValueLabel.text = NSString(string: singleSearchResult[0].time).substringToIndex(16)

        let color1 = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        let color2 = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.locations = [0.0, 1.0]
        gradient.colors = [color1.CGColor, color2.CGColor]
        
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
        mySellingDetailImageView.hnk_setImageFromURL(singleSearchImageURL)
        
        mySellingEditButton.backgroundColor = UIColor(red: 30/255, green: 130/255, blue: 150/255, alpha: 1)
        mySellingEditButton.layer.cornerRadius = 18
        mySellingEditButton.tintColor = UIColor.whiteColor()
        mySellingEditButton.addTarget(self, action: #selector(editPost), forControlEvents: .TouchUpInside)
    }
    
    
    func editPost() {

        performSegueWithIdentifier("MySellingEditSegue", sender: [])
    }
    
    @IBAction func messageButtonAction(sender: UIButton) {
    
        performSegueWithIdentifier("SellingItemsMessageSegue", sender: self)
    
    }
    
    
    /**************************************************/
    /******************SEGUE THINGS********************/
    /**************************************************/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backToPrevious = UIBarButtonItem()
        backToPrevious.title = ""
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationItem.backBarButtonItem = backToPrevious
        
        
        if segue.identifier == "MySellingEditSegue" {
            
            let destViewController : MySellingItemsEditViewController = segue.destinationViewController as! MySellingItemsEditViewController
            
            destViewController.singleSearchImageURL = singleSearchImageURL
            
            destViewController.singleSearchKey = singleSearchKey
            
            destViewController.singleSearchResult = singleSearchResult
            
            destViewController.title = "Update My Good Car"
            
        }
        
        if segue.identifier == "SellingItemsMessageSegue" {
            
            let destViewController : ContactOwnerViewController = segue.destinationViewController as! ContactOwnerViewController
            
            destViewController.singleSearchKey = singleSearchKey
            destViewController.singleSearchResult = singleSearchResult
            
            destViewController.title = "My Message"
            
            
        }
        
        
    }

}
