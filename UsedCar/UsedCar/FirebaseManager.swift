//
//  FirebaseManager.swift
//  UsedCar
//
//  Created by Yi Hsu on 2016/9/26.
//  Copyright © 2016年 Yi Hsu. All rights reserved.
//

import Foundation

class FirebaseManager {
    
    var firebaseName : String
    var firebaseMail : String
    var firebasePhotoURL : String
    var firebaseUserID : String
    var facebookUserID : String
    var facebookUserLink : String
    var facebookPhotoURL : String
    var token : String
    
    static let shared = FirebaseManager()
    
    private init() {
        self.firebaseName = ""
        self.firebaseMail = ""
        self.firebasePhotoURL = ""
        self.firebaseUserID = ""
        self.facebookUserID = ""
        self.facebookUserLink = ""
        self.facebookPhotoURL = ""
        self.token = ""
    }
}
