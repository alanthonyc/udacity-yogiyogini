//
//  LongPressButton.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 3/28/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//

import UIKit

protocol LongPressButtonProtocol
{
    func handleLongPress(sender: LongPressButton?)
}

class LongPressButton: UIButton
{
    var delegate: LongPressButtonProtocol?
    let longPressRecognizer = UILongPressGestureRecognizer()
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.addGestureRecognizer(self.longPressRecognizer)
        self.longPressRecognizer.minimumPressDuration = 1.0
        self.longPressRecognizer.addTarget(self, action: #selector(LongPressButton.longPressHandler))
    }
    
    func longPressHandler(sender: LongPressButton?)
    {
        if delegate != nil
        {
            self.delegate?.handleLongPress(sender)
        }
    }
}