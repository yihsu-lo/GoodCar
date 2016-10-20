//
//  SearchDataViewController.swift
//  UsedCar
//
//  Created by Yi Hsu on 2016/9/23.
//  Copyright © 2016年 Yi Hsu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAnalytics

class SearchDataViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var brandTextField: UITextField!
    
    @IBOutlet weak var colorTextField: UITextField!
    
    @IBOutlet weak var priceRangeSlider: UISlider!
    
    @IBOutlet weak var mileageRangeSlider: UISlider!
    
    @IBOutlet weak var priceNumberLabel: UILabel!
    
    @IBOutlet weak var mileageNumberLabel: UILabel!
    
    
    @IBAction func priceSliderValueChanged(sender: UISlider) {
        
        let currentValue = Float(sender.value / 10000)
        
        priceRangeValue = Int(sender.value)
        
        priceNumberLabel.text = "NTD 0 ~ \(currentValue)W"
    }
    
    
    @IBAction func mileageSliderValueChanged(sender: UISlider) {
        
        let currentValue = Float(sender.value / 10000)
        
        mileageRangeValue = Int(sender.value)
        
        mileageNumberLabel.text = "0 ~ \(currentValue)W KM"
        
    }
    
    
    var priceRangeValue : Int = 0
    var mileageRangeValue : Int = 0
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        firebaseSearchInfo = []
        firebaseSearchResultKey = []
        firebaseSearchResultImageURLDictionary = [ : ]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        brandTextField.delegate = self
        colorTextField.delegate = self
        
        brandTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        colorTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        
        brandTextField.keyboardAppearance = .Dark
        colorTextField.keyboardAppearance = .Dark
        
        priceNumberLabel.clipsToBounds = true
        priceNumberLabel.layer.cornerRadius = 13
        mileageNumberLabel.clipsToBounds = true
        mileageNumberLabel.layer.cornerRadius = 13
        
        searchButton.backgroundColor = UIColor(red: 30/255, green: 130/255, blue: 150/255, alpha: 1)
        
        searchButton.layer.cornerRadius = 18
        searchButton.tintColor = UIColor.whiteColor()
        
        priceRangeSlider.minimumTrackTintColor = UIColor(red: 255/255, green: 116/255, blue: 70/255, alpha: 1)
        priceRangeSlider.minimumValue = 0
        priceRangeSlider.maximumValue = 3000000
        priceRangeSlider.setThumbImage(UIImage(named: "alloy-wheel"), forState: .Normal)
        
        mileageRangeSlider.minimumTrackTintColor = UIColor(red: 255/255, green: 116/255, blue: 70/255, alpha: 1)
        mileageRangeSlider.minimumValue = 0
        mileageRangeSlider.maximumValue = 200000
        mileageRangeSlider.setThumbImage(UIImage(named: "alloy-wheel"), forState: .Normal)
        
        let color1 = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        let color2 = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.locations = [0.0, 1.0]
        gradient.colors = [color1.CGColor, color2.CGColor]
        
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
        
        /**************************************************/
        /********DISMISS TEXTFIELD WHEN TAPPING VIEW*******/
        /**************************************************/
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    
    func didTapView(){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        brandTextField.resignFirstResponder()
        colorTextField.resignFirstResponder()
        
        return true
    }
    
    
    /**************************************************/
    /***************LIMIT UPPERCASESTRING**************/
    /**************************************************/
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        textField.text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string.uppercaseString)
        
        return false
        
    }
    
    struct FirebaseSearchResultData {
        
        var brand : String
        var color : String
        var firebaseUserID : String
        var location : String
        var model : String
        var price : Int
        var mileage : Int
        var year : String
        var time : String
        var userLink : String
        var userName : String
        var facebookUserID : String
        
        init(brand : String, color : String, firebaseUserID : String, location : String, model : String, price : Int, mileage : Int, year : String, time : String, userLink : String, userName : String, facebookUserID : String) {
            
            self.brand = brand
            self.color = color
            self.firebaseUserID = firebaseUserID
            self.location = location
            self.model = model
            self.price = price
            self.mileage = mileage
            self.year = year
            self.time = time
            self.userLink = userLink
            self.userName = userName
            self.facebookUserID = facebookUserID
        }
        
    }
    
    
    /**************************************************/
    /****RETRIEVE DATA THINGS---DATABASE & STORAGE*****/
    /**************************************************/
    
    
    let ref = FIRDatabase.database().referenceWithPath("data")
    
    var firebaseSearchInfo : [FirebaseSearchResultData] = []
    
    var searchTableViewController : SearchTableViewController = SearchTableViewController()
    
    var firebaseSearchResultKey : [String] = []
    
    var firebaseSearchResultImageURLDictionary : [String : NSURL] = [ : ]
    
    
    private var infoHandler: FIRDatabaseHandle!
    
    
    @IBAction func searchButtonAction(sender: UIButton) {
        
        
        if brandTextField.text != "" && colorTextField.text != "" && mileageRangeValue != 0 && priceRangeValue != 0 {
            
            /**************************************************/
            /**************RETRIEVE DATABASE DATA**************/
            /**************************************************/
            
            
            infoHandler = ref.queryOrderedByChild("searchInfo").queryEqualToValue("\(brandTextField.text!)_\(colorTextField.text!)").observeEventType(.ChildAdded, withBlock: { snapshot in
                
                if snapshot.exists() {
                    
                    for item in [snapshot.value] {
                        
                        let price = item!["price"] as! Int
                        let mileage = item!["mileage"] as! Int
                        
                        
                        if price < self.priceRangeValue && mileage < self.mileageRangeValue {
                            
                            guard
                                let brandData = item!["brand"] as? String,
                                let colorData = item!["color"] as? String,
                                let firebaseUserIDData = item!["firebaseUserID"] as? String,
                                let locationData = item!["location"] as? String,
                                let modelData = item!["model"] as? String,
                                let priceData = item!["price"] as? Int,
                                let mileageData = item!["mileage"] as? Int,
                                let yearData = item!["year"] as? String,
                                let timeData = item!["time"] as? String,
                                let userLinkData = item!["userLink"] as? String,
                                let userNameData = item!["userName"] as? String,
                                let facebookUseIDData = item!["facebookUserID"] as? String else {
                                    
                                    fatalError()
                            }
                            
                            self.firebaseSearchResultKey.append(snapshot.key)
                            
                            self.firebaseSearchInfo.append(FirebaseSearchResultData(brand: brandData, color: colorData, firebaseUserID: firebaseUserIDData, location: locationData, model: modelData, price: priceData, mileage: mileageData, year: yearData, time: timeData, userLink: userLinkData, userName: userNameData, facebookUserID: facebookUseIDData))
                            
                        }
                        
                    }
                    
                    self.retrieveStorageData()
                    
                    self.searchTableViewController.firebaseSearchResultValue = self.firebaseSearchInfo
                    
                    self.searchTableViewController.firebaseSearchResultKey = self.firebaseSearchResultKey
                }
                
            })
            
            
        } else {
            
            cellsAreMandatoryAlert()
        }
        
        performSegueWithIdentifier("SearchDataTableSegue", sender: self)
    }
    
    
    
    /**************************************************/
    /****************RETRIEVE STORAGE DATA*************/
    /**************************************************/
    
    func retrieveStorageData() {
        
        for item in firebaseSearchResultKey {
            
            let storage = FIRStorage.storage()
            
            let storageRef = storage.referenceForURL("gs://usedcar-8e0f0.appspot.com/")
            
            let imageRef = storageRef.child(item)
            
            
            imageRef.downloadURLWithCompletion { (URL, error) -> Void in
                
                if (error != nil) {
                    
                    print("retrieve storage image error in search page: \(error)")
                    
                } else {
                    
                    
                    self.firebaseSearchResultImageURLDictionary[item] = URL!
                    
                    if self.firebaseSearchResultKey.count == self.firebaseSearchResultImageURLDictionary.count && self.firebaseSearchResultKey.count != 0 {
                        
                        self.searchTableViewController.firebaseSearchResultImageURLDictionary = self.firebaseSearchResultImageURLDictionary
                        
                        self.searchTableViewController.searchTableView.reloadData()

                        
                        /**************************************************/
                        /****************FIREBASE ANALYTICS****************/
                        /**************************************************/
                        
                        FIRAnalytics.logEventWithName(kFIREventSelectContent, parameters: [
                            kFIRParameterContentType : FirebaseManager.shared.firebaseUserID,
                            kFIRParameterItemID : "user search : \(self.brandTextField.text!)"
                            ])
                    }
                }
            }
        }
    }
    
    
    /**************************************************/
    /********************ALERT THING*******************/
    /**************************************************/
    
    func searchNotMatchedAlert() {
        
        let alertController = UIAlertController(title: "Warning", message: "No search result matched!", preferredStyle: UIAlertControllerStyle.Alert)
        let goBackAction = UIAlertAction(title: "Go back", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
            
        }
        alertController.addAction(goBackAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func cellsAreMandatoryAlert() {
        
        let alertController = UIAlertController(title: "Warning", message: "All cells are mandatory!", preferredStyle: UIAlertControllerStyle.Alert)
        
        let goBackAction = UIAlertAction(title: "Go back", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
        }
        
        alertController.addAction(goBackAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    /**************************************************/
    /******************SEGUE THINGS********************/
    /**************************************************/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SearchDataTableSegue" {
            let destViewController: SearchTableViewController = segue.destinationViewController as! SearchTableViewController
            
            let backToPrevious = UIBarButtonItem()
            backToPrevious.title = "Back"
            navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            navigationItem.backBarButtonItem = backToPrevious
            destViewController.title = "Search Results"
            
            destViewController.firebaseSearchResultKey = firebaseSearchResultKey
            
            destViewController.firebaseSearchResultValue = firebaseSearchInfo
            
            destViewController.firebaseSearchResultImageURLDictionary = firebaseSearchResultImageURLDictionary
            
            searchTableViewController = destViewController
        }
    }
    
    
    /**************************************************/
    /**************UNWIND SEGUE THINGS*****************/
    /**************************************************/
    
    @IBAction func unwindToSearchPageFromSearchTable(segue: UIStoryboardSegue) {
        
    }
    
    deinit {
        
        if infoHandler != nil {
            
            self.ref.child("data").removeObserverWithHandle(infoHandler)
        }
    }
    
}
