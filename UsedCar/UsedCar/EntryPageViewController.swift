//
//  EntryPageViewController.swift
//  UsedCar
//
//  Created by Yi Hsu on 2016/9/22.
//  Copyright © 2016年 Yi Hsu. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import Firebase


import Foundation
import SystemConfiguration


class EntryPageViewController: UIViewController {
    
    
    @IBOutlet weak var facebookLoginImageView: UIImageView!
    
    @IBOutlet weak var lamborghiniImageView: UIImageView!
        
    @IBOutlet weak var guestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lamborghiniImageView.alpha = 0.5
        
        let color1 = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        let color2 = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.locations = [0.0, 1.0]
        gradient.colors = [color1.CGColor, color2.CGColor]
        
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
        
        guestButton.backgroundColor = UIColor(red: 30/255, green: 130/255, blue: 150/255, alpha: 1)
        guestButton.layer.cornerRadius = 18
        guestButton.tintColor = UIColor.whiteColor()
        
        
        let tapFBLogin = UITapGestureRecognizer(target: self, action: #selector(loginAction))
        facebookLoginImageView.addGestureRecognizer(tapFBLogin)
        facebookLoginImageView.userInteractionEnabled = true
        
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                
                /**************************************************/
                /******************SAVE TO MANAGER*****************/
                /**************************************************/
                
                if user != nil {
                
                    FirebaseManager.shared.firebaseName = (user?.displayName)!
                    FirebaseManager.shared.firebaseMail = (user?.email)!
                    FirebaseManager.shared.firebasePhotoURL = String(user?.photoURL)
                    FirebaseManager.shared.firebaseUserID = (user?.uid)!
                }
            }
            
            /**************************************************/
            /***************USER DEFAULT THINGS****************/
            /**************************************************/
            
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, email, link, id"])
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                
                if ((error) != nil) {
                    print("Error: \(error)")
                } else {
                    
                    let userName : NSString = result.valueForKey("name") as? NSString ?? NSString(string: "not getting user's name")
                    
                    let userEmail : NSString = result.valueForKey("email") as? NSString ?? NSString(string: "not getting user's email")
                    
                    let userLink : NSString = result.valueForKey("link") as? NSString ?? NSString(string: "not getting user's link")
                    
                    let userID : NSString = result.valueForKey("id") as? NSString ?? NSString(string: "not getting user's id")
                    
                    let facebookProfilePic = "http://graph.facebook.com/\(userID)/picture?type=large"
                    
                    /**************************************************/
                    /******************SAVE TO MANAGER*****************/
                    /**************************************************/
                    
                    FirebaseManager.shared.facebookUserID = userID as String
                    FirebaseManager.shared.facebookUserLink = userLink as String
                    FirebaseManager.shared.facebookPhotoURL = facebookProfilePic
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject("\(userName)", forKey: "name")
                    defaults.setObject("\(userEmail)", forKey: "email")
                    defaults.setObject("\(userLink)", forKey: "link")
                    defaults.setObject("\(facebookProfilePic)", forKey: "picture")
                    
                }
            })
            
            //            let viewController = viewController() Wrong way! use storyBoard
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initViewController = storyBoard.instantiateViewControllerWithIdentifier("MyTabBarController") as! MyTabBarController
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.window?.rootViewController = initViewController
            
        }
    }
    
    
    var fbLoginSuccess = false
    
    func loginAction() {
        
        let facebookLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        facebookLoginManager.logInWithReadPermissions(["public_profile", "email"], fromViewController: self) { (result, error) -> Void in
            
            if (error != nil) {
                print("login error")
            } else if (error == nil) {
                let facebookLoginResult : FBSDKLoginManagerLoginResult = result
                
                if result.isCancelled {
                    print("user cancelled")
                } else {
                    result.grantedPermissions.contains("email")
                    print("user logged in to Facebook")
                    
                    
                    /**************************************************/
                    /*************FIREBASE FACEBOOK THINGS*************/
                    /**************************************************/
                    
                    let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                    
                    FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                        
                        if user != nil {
                            
                            FirebaseManager.shared.firebaseName = (user?.displayName)!
                            FirebaseManager.shared.firebaseMail = (user?.email)!
                            FirebaseManager.shared.firebasePhotoURL = String(user?.photoURL)
                            FirebaseManager.shared.firebaseUserID = (user?.uid)!
                        }
                    }
                    
                    
                    /**************************************************/
                    /***************USER DEFAULT THINGS****************/
                    /**************************************************/
                    
                    
                    let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, email, link, id"])
                    graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                        
                        if ((error) != nil) {
                            print("Error: \(error)")
                        } else {
                            
                            
                            /**************************************************/
                            /*************FIREBASE FACEBOOK THINGS*************/
                            /**************************************************/
                            
                            let userName : NSString = result.valueForKey("name") as? NSString ?? NSString(string: "not getting user's name")
                            let userEmail : NSString = result.valueForKey("email") as? NSString ?? NSString(string: "not getting user's email")
                            let userLink : NSString = result.valueForKey("link") as? NSString ?? NSString(string: "not getting user's link")

                            let userID : NSString = result.valueForKey("id") as? NSString ?? NSString(string: "not getting user's id")
                            let facebookProfilePic = "http://graph.facebook.com/\(userID)/picture?type=large"
                            
                            FirebaseManager.shared.facebookUserLink = userLink as String
                            FirebaseManager.shared.facebookUserID = userID as String
                            FirebaseManager.shared.facebookPhotoURL = facebookProfilePic

                            
                            let defaults = NSUserDefaults.standardUserDefaults()
                            defaults.setObject("\(userName)", forKey: "name")
                            defaults.setObject("\(userEmail)", forKey: "email")
                            defaults.setObject("\(userLink)", forKey: "link")
                            defaults.setObject("\(facebookProfilePic)", forKey: "picture")
                            
                        }
                    })
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let initViewController = storyBoard.instantiateViewControllerWithIdentifier("MyTabBarController") as! MyTabBarController
                    
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    appDelegate.window?.rootViewController = initViewController
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
    
    
    @IBAction func guestButtonAction(sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let initViewController = storyBoard.instantiateViewControllerWithIdentifier("MyTabBarController") as! MyTabBarController
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = initViewController
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
}
