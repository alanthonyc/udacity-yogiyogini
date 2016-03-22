//
//  RootViewController.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 3/13/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColorFromRGB(0xfa006f)
        self.selectedIndex = 1
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor
    {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
