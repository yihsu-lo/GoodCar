//
//  MySellingItemsEditViewController.swift
//  UsedCar
//
//  Created by Yi Hsu on 2016/10/3.
//  Copyright © 2016年 Yi Hsu. All rights reserved.
//

import UIKit
import Firebase
import Haneke

class MySellingItemsEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var editPickImageBackgroundView: UIView!
    
    @IBOutlet weak var editPickImageView: UIImageView!
    
    @IBOutlet weak var editBrandTextField: UITextField!
    
    @IBOutlet weak var editModelTextField: UITextField!
    
    @IBOutlet weak var editColorTextField: UITextField!
    
    @IBOutlet weak var editMileageTextField: UITextField!
    
    @IBOutlet weak var editPriceTextField: UITextField!
    
    @IBOutlet weak var editYearPickerView: UIPickerView!
    
    @IBOutlet weak var editLocationPickerView: UIPickerView!
    
    @IBOutlet weak var editUpdateButton: UIButton!
    
    @IBOutlet weak var editDeleteButton: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var singleSearchKey : String = ""
    var singleSearchResult : [SearchDataViewController.FirebaseSearchResultData] = []
    var singleSearchImageURL : NSURL = NSURL()
    
    
    var editYearPickerDataSourceInt : [Int] = []
    var editYearPickerDataSourceString : [String] = ["--Select--"]
    
    var editLocationPickerDataSource: [String] = ["--Select--", "TAIPEI", "TAOYUAN", "TAICHUNG", "TAINAN", "KAOHSIUNG", "YILAN", "HSINCHU", "MIAOLI", "CHANGHUA", "NANTOU", "YUNLIN", "CHIAYI", "PINGTUNG", "TAITUNG", "HUALIEN", "KEELUNG"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editImagePicker.delegate = self
        editBrandTextField.delegate = self
        editModelTextField.delegate = self
        editColorTextField.delegate = self
        editMileageTextField.delegate = self
        editPriceTextField.delegate = self
        editYearPickerView.dataSource = self
        editYearPickerView.delegate = self
        editLocationPickerView.dataSource = self
        editLocationPickerView.delegate = self
        
        
        editBrandTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        editModelTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        editColorTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        editMileageTextField.keyboardType = .NumberPad
        editPriceTextField.keyboardType = .NumberPad
        
        editBrandTextField.keyboardAppearance = .Dark
        editModelTextField.keyboardAppearance = .Dark
        editColorTextField.keyboardAppearance = .Dark
        editMileageTextField.keyboardAppearance = .Dark
        editPriceTextField.keyboardAppearance = .Dark
        
        
        editBrandTextField.text = singleSearchResult[0].brand
        editModelTextField.text = singleSearchResult[0].model
        editColorTextField.text = singleSearchResult[0].color
        editMileageTextField.text = String(singleSearchResult[0].mileage)
        editPriceTextField.text = String(singleSearchResult[0].price)
        
        editPickImageView.hnk_setImageFromURL(singleSearchImageURL)
        
        
        editYearPickerDataSourceString[0] = singleSearchResult[0].year
        editLocationPickerDataSource[0] = singleSearchResult[0].location
        
        
        editUpdateButton.backgroundColor = UIColor(red: 30/255, green: 130/255, blue: 150/255, alpha: 1)
        editUpdateButton.layer.cornerRadius = 18
        editUpdateButton.tintColor = UIColor.whiteColor()
        
        editDeleteButton.backgroundColor = UIColor(red: 255/255, green: 80/255, blue: 70/255, alpha: 1)
        editDeleteButton.layer.cornerRadius = 18
        editDeleteButton.tintColor = UIColor.whiteColor()
        
        
        for editYearPickerDataSourceItem in 1996...2016 {
            editYearPickerDataSourceInt.append(editYearPickerDataSourceItem)
        }
        
        for editYearPickerDataItem in 0...(editYearPickerDataSourceInt.count - 1) {
            
            editYearPickerDataSourceString.append(String(editYearPickerDataSourceInt[editYearPickerDataItem]))
        }
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(loadImage))
        editPickImageView.addGestureRecognizer(tap)
        editPickImageView.userInteractionEnabled = true
        
        
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
    
    /**************************************************/
    /*****************PICK IMAGE THINGS****************/
    /**************************************************/
    
    var editImagePicker = UIImagePickerController()
    
    func loadImage() {
        editImagePicker.allowsEditing = true
        editImagePicker.sourceType = .PhotoLibrary
        presentViewController(editImagePicker, animated: true, completion: nil)
    }
    
    
    var pickedImageParameter = UIImage()
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        if let croppedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            let imageData = UIImageJPEGRepresentation(croppedImage, 0.05)
            
            pickedImageParameter = UIImage(data: imageData!)!
            
            editPickImageView.image = pickedImageParameter
            
            editPickImageView.clipsToBounds = true
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /**************************************************/
    /*****************TEXTFIELD THINGS*****************/
    /**************************************************/
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        editBrandTextField.resignFirstResponder()
        editModelTextField.resignFirstResponder()
        editColorTextField.resignFirstResponder()
        
        return true
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        self.animateTextField(textField, up: true)
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        self.animateTextField(textField, up: false)
    }
    
    func animateTextField(textField: UITextField, up: Bool) {
        
        let movementDistance:CGFloat = -140
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        
        if up {
            movement = movementDistance
        } else {
            movement = -movementDistance
        }
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        UIView.commitAnimations()
    }
    
    
    
    
    /**************************************************/
    /*******LIMIT STRING LENGTH & NUMBER INPUT*********/
    /**************************************************/
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField == editBrandTextField || textField == editModelTextField || textField == editColorTextField {
            
            textField.text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string.uppercaseString)
            
            return false
            
        } else if textField == editMileageTextField || textField == editPriceTextField {
            
            let aSet = NSCharacterSet(charactersInString:"0123456789").invertedSet
            let compSepByCharInSet = string.componentsSeparatedByCharactersInSet(aSet)
            let numberFiltered = compSepByCharInSet.joinWithSeparator("")
            
            return string == numberFiltered
            
        } else {
            
            return false
        }
    }
    
    /**************************************************/
    /***************PICKERVIEW THINGS******************/
    /**************************************************/
    
    
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if pickerView == editYearPickerView {
            return 1
        } else if pickerView == editLocationPickerView {
            return 1
        } else {
            return 0
        }
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == editYearPickerView {
            return editYearPickerDataSourceString.count
        } else if pickerView == editLocationPickerView {
            return editLocationPickerDataSource.count
        } else {
            return 0
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == editYearPickerView {
            return String(editYearPickerDataSourceString[row])
        } else if pickerView == editLocationPickerView {
            return editLocationPickerDataSource[row]
        } else {
            return "no data"
        }
    }
    
    
    var editYearDataString : String = ""
    var editLocationData : String = ""
    
    
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        
        if pickerView == editYearPickerView {
            
            pickerLabel.textColor = UIColor.whiteColor()
            pickerLabel.text = String(editYearPickerDataSourceString[row])
            pickerLabel.font = UIFont(name: "Helvetica Neue", size: 13.0) // In this use your custom font
            pickerLabel.textAlignment = NSTextAlignment.Center
            
            editYearDataString = pickerLabel.text!
            
            return pickerLabel
            
        } else if pickerView == editLocationPickerView {
            pickerLabel.textColor = UIColor.whiteColor()
            pickerLabel.text = editLocationPickerDataSource[row]
            pickerLabel.font = UIFont(name: "Helvetica Neue", size: 13.0) // In this use your custom font
            pickerLabel.textAlignment = NSTextAlignment.Center
            
            editLocationData = pickerLabel.text!
            
            return pickerLabel
            
        } else {
            
            return pickerLabel
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if pickerView == editYearPickerView {
            return 25.0
        } else if pickerView == editLocationPickerView {
            return 25.0
        } else {
            return 0.0
        }
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if pickerView == editYearPickerView {
            return 77.0
        } else if pickerView == editLocationPickerView {
            return 77.0
        } else {
            return 0.0
        }
    }
    
    /**************************************************/
    /*****UPDATE DATA THINGS---DATABASE & STORAGE******/
    /**************************************************/
    
    
    
    /**************************************************/
    /*****************UPDATE DATABASE******************/
    /**************************************************/
    
    
    let rootRef = FIRDatabase.database().referenceWithPath("data")
    var updatedData : [String : AnyObject] = [ : ]
    
    
    @IBAction func editUpdateButtonAction(sender: UIButton) {
        
        spinner.startAnimating()
        
        /**************************************************/
        /*****************RETRIEVE DATABASE****************/
        /**************************************************/
        
        if editBrandTextField.text != "" && editModelTextField.text != "" && editColorTextField.text != "" && editMileageTextField.text != "" && editPriceTextField.text != "" {
            
            let editDate = NSDate()
            let formatter = NSDateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
            let defaultTimeZoneString = formatter.stringFromDate(editDate)
            
            
            updatedData = [
                "brand" : editBrandTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: ""),
                "model" : editModelTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: ""),
                "color" : editColorTextField.text!,
                "mileage" : Int(editMileageTextField.text!)!,
                "price" : Int(editPriceTextField.text!)!,
                "year" : editYearDataString,
                "location" : editLocationData,
                "time" : defaultTimeZoneString,
                "searchInfo" : "\(editBrandTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: ""))_\(editColorTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: ""))"
            ]
            
            rootRef.child(singleSearchKey).updateChildValues(updatedData)
            
            
            updateStorageImage()
            
        } else {
            
            let alertController = UIAlertController(title: "Warning", message: "All cells are mandatory!", preferredStyle: UIAlertControllerStyle.Alert)
            let goBackAction = UIAlertAction(title: "Go back", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
                
                self.spinner.stopAnimating()
            }
            
            alertController.addAction(goBackAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    /**************************************************/
    /*******UPDATE IMAGE AND GO TO PROFILE PAGE********/
    /**************************************************/
    
    
    let storageRef = FIRStorage.storage().referenceForURL("gs://usedcar-8e0f0.appspot.com")
    
    
    func updateStorageImage() {
        
        let metadata = FIRStorageMetadata()
        
        metadata.contentType = "image/jpeg"
        
        
        guard let imageData = UIImagePNGRepresentation(pickedImageParameter) else {
            
            print("image not change, then go back!")
        
            /**************************************************/
            /**************BACK TO PROFILE PAGE****************/
            /**************************************************/
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.spinner.stopAnimating()
                
                let alertController = UIAlertController(title: "Success", message: "Good Car Updated!", preferredStyle: UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                    self.performSegueWithIdentifier("UnwindToProfileFromEditUpdatePage", sender: self)
                }
                
                alertController.addAction(okAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
            return
        }
        
        /**************************************************/
        /*******************DELETE IMAGE*******************/
        /**************************************************/
        
        storageRef.child(singleSearchKey).deleteWithCompletion { (error) -> Void in
            
            if (error != nil) {
                
                print("Deleting image error: \(error)")
                
            } else {
                
                print("Delete image success, then update image")
                
                /**************************************************/
                /********************SAVE IMAGE********************/
                /**************************************************/
                
                self.storageRef.child(self.singleSearchKey).putData(imageData, metadata: metadata) { (metadata, error) in
                    if let error = error {
                        
                        let alertController = UIAlertController(title: "Warning", message: "Connection error. Please try again!", preferredStyle: .Alert)
                        
                        let goBackAction = UIAlertAction(title: "Go back", style: .Destructive) {
                            (result : UIAlertAction) -> Void in
                        }
                        
                        alertController.addAction(goBackAction)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                        print("Error uploading: \(error)")
                        
                        return
                        
                    } else {
                        
                        print("Update data success")
                        
                        /**************************************************/
                        /**************BACK TO PROFILE PAGE****************/
                        /**************************************************/
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            self.spinner.stopAnimating()
                            
                            let alertController = UIAlertController(title: "Success", message: "Good Car Updated!", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                                self.performSegueWithIdentifier("UnwindToProfileFromEditUpdatePage", sender: self)
                            }
                            
                            alertController.addAction(okAction)
                            
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                        
                    }
                }
            }
        }
    }
    
    /**************************************************/
    /************DELETE DATABASE & STORAGE*************/
    /**************************************************/
    
    @IBAction func editDeleteButtonAction(sender: UIButton) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            let alertController = UIAlertController(title: "Warning", message: "Are you sure you want to DELETE the Good Car?", preferredStyle: UIAlertControllerStyle.Alert)
            
            //SURE
            let confirmAction = UIAlertAction(title: "Yes I am sure!", style: .Destructive) { (result : UIAlertAction) -> Void in
                
                self.spinner.startAnimating()
                
                self.storageRef.child(self.singleSearchKey).deleteWithCompletion { (error) -> Void in
                    
                    if (error != nil) {
                        
                        print("Deleting image error: \(error)")
                        
                    } else {
                        
                        self.spinner.stopAnimating()
                        
                        self.rootRef.child(self.singleSearchKey).removeValue()
                        
                        print("delete data success")
                        
                        self.performSegueWithIdentifier("UnwindToProfileFromEditUpdatePage", sender: self)
                    }
                }
            }
            
            //NOT SURE
            let goBackAction = UIAlertAction(title: "No I am not sure...", style: .Default) { (result : UIAlertAction) -> Void in
                
            }
            alertController.addAction(confirmAction)
            alertController.addAction(goBackAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    deinit {
        print("Selling Edit Page : 記憶體釋放")
    }
    
    
}
