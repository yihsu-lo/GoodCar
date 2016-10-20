//
//  UploadDataViewController.swift
//  UsedCar
//
//  Created by Yi Hsu on 2016/9/23.
//  Copyright © 2016年 Yi Hsu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAnalytics

class UploadDataViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var pickImageView: UIImageView!
    
    @IBOutlet weak var pickImageBackgroundView: UIView!
    
    @IBOutlet weak var uploadPhotoIcon: UIImageView!
    
    @IBOutlet weak var uploadPhotoLabel: UILabel!
    
    @IBOutlet weak var brandTextField: UITextField!
    
    @IBOutlet weak var modelTextField: UITextField!
    
    @IBOutlet weak var colorTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var mileageTextField: UITextField!
    
    @IBOutlet weak var yearPickerView: UIPickerView!
    
    @IBOutlet weak var locationPickerView: UIPickerView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    var yearPickerDataSourceInt : [Int] = []
    var yearPickerDataSourceString : [String] = ["--Select--"]
    
    var locationPickerDataSource: [String] = ["--Select--", "TAIPEI", "TAOYUAN", "TAICHUNG", "TAINAN", "KAOHSIUNG", "YILAN", "HSINCHU", "MIAOLI", "CHANGHUA", "NANTOU", "YUNLIN", "CHIAYI", "PINGTUNG", "TAITUNG", "HUALIEN", "KEELUNG"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        brandTextField.delegate = self
        modelTextField.delegate = self
        colorTextField.delegate = self
        mileageTextField.delegate = self
        priceTextField.delegate = self
        
        yearPickerView.dataSource = self
        yearPickerView.delegate = self
        
        locationPickerView.dataSource = self
        locationPickerView.delegate = self
        
        brandTextField.placeholder = "TOYOTA"
        modelTextField.placeholder = "YARIS"
        colorTextField.placeholder = "WHITE"
        mileageTextField.placeholder = "30000"
        priceTextField.placeholder = "350000"
        
        
        brandTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        modelTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        colorTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        mileageTextField.keyboardType = .NumberPad
        priceTextField.keyboardType = .NumberPad
        
        brandTextField.keyboardAppearance = .Dark
        modelTextField.keyboardAppearance = .Dark
        colorTextField.keyboardAppearance = .Dark
        mileageTextField.keyboardAppearance = .Dark
        priceTextField.keyboardAppearance = .Dark
        
        saveButton.backgroundColor = UIColor(red: 30/255, green: 130/255, blue: 150/255, alpha: 1)
        
        saveButton.layer.cornerRadius = 18
        saveButton.tintColor = UIColor.whiteColor()
        
        
        for yearPickerDataSourceItem in 1996...2016 {
            yearPickerDataSourceInt.append(yearPickerDataSourceItem)
        }
        
        for yearPickerDataItem in 0...(yearPickerDataSourceInt.count - 1) {
            
            yearPickerDataSourceString.append(String(yearPickerDataSourceInt[yearPickerDataItem]))
        }
        
        
        let imageBackgroundColor1 = UIColor(red: 255/255, green: 58/255, blue: 70/255, alpha: 1)
        
        let imageBackgroundColor2 = UIColor(red: 255/255, green: 116/255, blue: 70/255, alpha: 1)
        
        let imageBackgroundGradient = CAGradientLayer()
        
        imageBackgroundGradient.frame.size = pickImageBackgroundView.frame.size
        
        
        imageBackgroundGradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        imageBackgroundGradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        imageBackgroundGradient.locations = [0.0, 1.0]
        
        imageBackgroundGradient.colors = [imageBackgroundColor1.CGColor, imageBackgroundColor2.CGColor]
        
        self.pickImageBackgroundView.layer.insertSublayer(imageBackgroundGradient, atIndex: 0)
        
        uploadPhotoIcon.userInteractionEnabled = false
        uploadPhotoLabel.userInteractionEnabled = false
        
        uploadPhotoLabel.hidden = false
        uploadPhotoIcon.hidden = false
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(loadImage))
        pickImageView.addGestureRecognizer(tap)
        pickImageView.userInteractionEnabled = true
        
        
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
    
    var imagePicker = UIImagePickerController()
    
    func loadImage() {
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    var pickedImageParameter = UIImage()
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        if let croppedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            let imageData = UIImageJPEGRepresentation(croppedImage, 0.05)
            
            pickedImageParameter = UIImage(data: imageData!)!
            
            pickImageView.image = pickedImageParameter
            
            pickImageView.clipsToBounds = true
            
            uploadPhotoLabel.hidden = true
            uploadPhotoIcon.hidden = true
            
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
        
        brandTextField.resignFirstResponder()
        modelTextField.resignFirstResponder()
        colorTextField.resignFirstResponder()
        mileageTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if brandTextField.isFirstResponder() == true {
            brandTextField.placeholder = nil
        } else {
            brandTextField.placeholder = "TOYOTA"
        }
        if modelTextField.isFirstResponder() == true {
            modelTextField.placeholder = nil
        } else {
            modelTextField.placeholder = "YARIS"
        }
        if colorTextField.isFirstResponder() == true {
            colorTextField.placeholder = nil
        } else {
            colorTextField.placeholder = "WHITE"
        }
        if mileageTextField.isFirstResponder() == true {
            mileageTextField.placeholder = nil
        } else {
            mileageTextField.keyboardType = .NumberPad
            mileageTextField.placeholder = "30000"
        }
        if priceTextField.isFirstResponder() == true {
            priceTextField.placeholder = nil
        } else {
            priceTextField.keyboardType = .NumberPad
            priceTextField.placeholder = "350000"
        }
        
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
    /*******LIMIT UPPERCASESTRING & NUMBER INPUT*******/
    /**************************************************/
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField == brandTextField || textField == modelTextField || textField == colorTextField {
            
            textField.text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string.uppercaseString)
            
            return false
            
        } else if textField == mileageTextField || textField == priceTextField {
            
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
        if pickerView == yearPickerView {
            return 1
        } else if pickerView == locationPickerView {
            return 1
        } else {
            return 0
        }
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == yearPickerView {
            return yearPickerDataSourceString.count
        } else if pickerView == locationPickerView {
            return locationPickerDataSource.count
        } else {
            return 0
        }
    }
    
    
    
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == yearPickerView {
            return String(yearPickerDataSourceString[row])
        } else if pickerView == locationPickerView {
            return locationPickerDataSource[row]
        } else {
            return "no data"
        }
        
    }
    
    var yearDataString : String = ""
    var locationData : String = ""
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        
        if pickerView == yearPickerView {
            
            pickerLabel.textColor = UIColor.whiteColor()
            pickerLabel.text = String(yearPickerDataSourceString[row])
            pickerLabel.font = UIFont(name: "Helvetica Neue", size: 13.0) // In this use your custom font
            pickerLabel.textAlignment = NSTextAlignment.Center
            
            yearDataString = pickerLabel.text!
            
            return pickerLabel
            
        } else if pickerView == locationPickerView {
            pickerLabel.textColor = UIColor.whiteColor()
            pickerLabel.text = locationPickerDataSource[row]
            pickerLabel.font = UIFont(name: "Helvetica Neue", size: 13.0) // In this use your custom font
            pickerLabel.textAlignment = NSTextAlignment.Center
            
            locationData = pickerLabel.text!
            
            return pickerLabel
            
        } else {
            
            return pickerLabel
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if pickerView == yearPickerView {
            return 25.0
        } else if pickerView == locationPickerView {
            return 25.0
        } else {
            return 0.0
        }
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if pickerView == yearPickerView {
            return 77.0
        } else if pickerView == locationPickerView {
            return 77.0
        } else {
            return 0.0
        }
    }
    
    
    /**************************************************/
    /******SAVE DATA THINGS---DATABASE & STORAGE*******/
    /**************************************************/
    
    var autoIDToStorage : String = ""
    
    
    
    /**************************************************/
    /*******************SAVE DATABASE******************/
    /**************************************************/
    
    let rootRef = FIRDatabase.database().referenceWithPath("data")
    
    var uploadData : [String : AnyObject] = [ : ]
    
    
    @IBAction func saveButtonAction(sender: UIButton) {
        
        
        spinner.startAnimating()
        
        let autoID = rootRef.child("data").childByAutoId().key
        
        autoIDToStorage = autoID
        
        if brandTextField.text != "" && modelTextField.text != "" && colorTextField.text != "" && mileageTextField.text != "" && priceTextField.text != "" && yearDataString != "--Select--" && locationData != "--Select--" && pickImageView.image == pickedImageParameter {
            
            
            let date = NSDate()
            let formatter = NSDateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
            let defaultTimeZoneString = formatter.stringFromDate(date)
            
            
            
            uploadData = [
                "brand" : brandTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: ""),
                "model" : modelTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: ""),
                "color" : colorTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: ""),
                "mileage" : Int(mileageTextField.text!)!,
                "price" : Int(priceTextField.text!)!,
                "year" : yearDataString,
                "location" : locationData,
                "time" : defaultTimeZoneString,
                "userName" : FirebaseManager.shared.firebaseName,
                "userLink" : FirebaseManager.shared.facebookUserLink,
                "firebaseUserID" : FirebaseManager.shared.firebaseUserID,
                "facebookUserID" : FirebaseManager.shared.facebookUserID,
                "searchInfo" : "\(brandTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: ""))_\(colorTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: ""))"
            ]
            
            rootRef.child(autoID).setValue(uploadData)
            
            saveStorageImage()
            
            
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
    /**********SAVE IMAGE AND GO TO MAIN PAGE**********/
    /**************************************************/
    
    
    let storageRef = FIRStorage.storage().referenceForURL("gs://usedcar-8e0f0.appspot.com")
    
    func saveStorageImage() {
        
        let metadata = FIRStorageMetadata()
        
        metadata.contentType = "image/jpeg"
        
        guard let imageData = UIImagePNGRepresentation(pickedImageParameter) else { return }
        
        
        storageRef.child("\(autoIDToStorage)").putData(imageData, metadata: metadata) { (metadata, error) in
            
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
                
                print("Upload data success")
                
                
                /**************************************************/
                /****************FIREBASE ANALYTICS****************/
                /**************************************************/
                
                FIRAnalytics.logEventWithName(kFIREventSelectContent, parameters: [
                    kFIRParameterContentType : FirebaseManager.shared.firebaseUserID,
                    kFIRParameterItemID : "user upload : \(self.autoIDToStorage)"
                    ])
                
                /**************************************************/
                /***************BACK TO MAIN PAGE******************/
                /**************************************************/
                
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.spinner.stopAnimating()
                    
                    let alertController = UIAlertController(title: "Success", message: "Good Car Saved!", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                        
                        self.performSegueWithIdentifier("UnwindToMainFromUploadPageSegue", sender: self)
                    }
                    
                    alertController.addAction(okAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    deinit {
        print("Upload Page : 記憶體釋放")
    }
    
}
