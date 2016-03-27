//
//  StudentDetailViewController.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 3/26/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//

import UIKit

protocol StudentDetailViewProtocol
{
    func close()
}

class StudentDetailViewController: UIViewController
{
    // MARK: - Outlets
    
    @IBOutlet weak var studentNameTextField: UITextField!
    @IBOutlet weak var studentTypeControl: UISegmentedControl!
    
    // MARK: - Properties
    
    var delegate: StudentDetailViewProtocol?
    
    // MARK: - Housekeeping
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTapped(sender: UIButton)
    {
        
    }
    
    @IBAction func saveButtonTapped(sender: UIButton)
    {
        
    }
}
