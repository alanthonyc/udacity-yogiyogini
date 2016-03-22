//
//  SessionTableViewCell.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 3/20/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//

import UIKit

class SessionTableViewCell: UITableViewCell
{
    // MARK: - Outlets
    
    @IBOutlet weak var studioNameLabel: UILabel!
    @IBOutlet weak var secondaryInfoLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
