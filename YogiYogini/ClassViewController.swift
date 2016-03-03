//
//  ClassViewController.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 2/29/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//

import UIKit
import MapKit

class ClassViewController: UIViewController
{
    @IBOutlet weak var countBaseView: UIView!
    @IBOutlet weak var checkinButtonBaseView: UIView!
    @IBOutlet weak var locationBaseView: UIView!
    
    // MARK: - Housekeeping
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.countBaseView.layer.cornerRadius = 12
        self.checkinButtonBaseView.layer.cornerRadius = 16
        self.locationBaseView.alpha = 0
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @IBAction func checkinButtonTapped()
    {
        self.locationBaseView.alpha = 0.8
    }
}

