//
//  FirebaseManager.swift
//  UsedCar
//
//  Created by Yi Hsu on 2016/9/26.
//  Copyright © 2016年 Yi Hsu. All rights reserved.
//

import Foundation
//import Firebase

//protocol FirebaseManagerDelegate: class {
//    func manager(manager: FirebaseManager, didGetData: AnyObject)
//    
//}

class FirebaseManager {
    
//    weak var delegate: FirebaseManagerDelegate?
    
    
    var firebaseName : String
    var firebaseMail : String
    var firebasePhotoURL : String
    var firebaseUserID : String
    var facebookUserID : String
    var facebookUserLink : String
    var facebookPhotoURL : String
    
    
    static let shared = FirebaseManager()
    
    private init() {
        self.firebaseName = ""
        self.firebaseMail = ""
        self.firebasePhotoURL = ""
        self.firebaseUserID = ""
        facebookUserID = ""
        self.facebookUserLink = ""
        self.facebookPhotoURL = ""
    }
}