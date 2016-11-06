//
//  MyTabBarController.swift
//  UsedCar
//
//  Created by Yi Hsu on 2016/9/22.
//  Copyright © 2016年 Yi Hsu. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    
    @IBOutlet weak var myTabBar: UITabBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTabBar.backgroundColor = UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1)
        myTabBar.tintColor = UIColor.whiteColor()
        myTabBar.barTintColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
    }
}
