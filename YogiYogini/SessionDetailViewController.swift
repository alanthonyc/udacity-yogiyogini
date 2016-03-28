//
//  SessionDetailViewController.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 3/22/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//

import UIKit

let kSESSION_DETAIL_VIEW_CONTROLLER_ID = "SessionDetailViewController"

protocol SessionDetailViewDelegateProtocol
{
    func closeSessionDetailView()
}

class SessionDetailViewController: UIViewController
{
    // MARK: - Outlets

    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressDetailsLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var studentCountLabel: UILabel!
    @IBOutlet weak var endDateBaseView: UIView!
    @IBOutlet weak var endDateMonthLabel: UILabel!
    @IBOutlet weak var endDateDayLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var studentTableView: UITableView!
    
    // MARK: - Properties
    
    var delegate: SessionDetailViewDelegateProtocol!
    var attendingStudentsViewController: AttendingStudentsViewController?
    var session: Session!

    // MARK: - Housekeeping
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.endDateBaseView.alpha = 0.0
        
        self.attendingStudentsViewController = AttendingStudentsViewController()
        self.attendingStudentsViewController?.tableView = self.studentTableView
        self.attendingStudentsViewController?.tableView?.delegate = self.attendingStudentsViewController
        self.attendingStudentsViewController?.tableView?.dataSource = self.attendingStudentsViewController
        let students = self.session!.students!.allObjects
        self.attendingStudentsViewController?.students = NSArray(array: students) as? [Student]
        self.attendingStudentsViewController?.tableView?.reloadData()
        self.studentCountLabel!.text = "\(students.count)"
        let temp = String(format:"%.0f", session.temperature as! Double)
        self.temperatureLabel!.text = "\(temp)º f"
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.configureSessionLabels()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    
    @IBAction func cancelButtonTapped()
    {
        self.close()
    }
    
    @IBAction func infoButtonTapped()
    {
        self.openMapsApp()
    }
    
    // MARK: View Controller
    
    func configureSessionLabels()
    {
        let dayOfWeekFormatter = NSDateFormatter()
        dayOfWeekFormatter.dateFormat = "EEEE"
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .NoStyle
        dateFormatter.dateStyle = .LongStyle
        let day = dayOfWeekFormatter.stringFromDate(self.session!.startDate!)
        var startDateString = day + " – "
        startDateString.appendContentsOf(dateFormatter.stringFromDate(self.session!.startDate!))
        self.startDateLabel!.text = startDateString
        self.venueNameLabel!.text = self.session!.venue!.name
        self.addressLabel!.text = self.session!.venue!.address
        let duration = Seconds(value: (self.session!.endDate?.timeIntervalSinceDate(self.session!.startDate!))!)
        let (h, m, _) = duration.components()
        self.durationLabel!.text = "\(h.paddedString):\(m.paddedString)"
        let timeFormatter = NSDateFormatter()
        timeFormatter.timeStyle = .ShortStyle
        timeFormatter.dateStyle = .NoStyle
        self.startTimeLabel!.text = timeFormatter.stringFromDate(self.session!.startDate!)
        self.endTimeLabel!.text = timeFormatter.stringFromDate(self.session!.endDate!)
        
        // TODO: replace defaults
        var addressDetailString =  self.session!.venue!.city!
        if self.session!.venue!.state! != ""
        {
            addressDetailString.appendContentsOf(", \(self.session!.venue!.state!)")
        }
        if self.session!.venue!.country! != ""
        {
            addressDetailString.appendContentsOf(", \(self.session!.venue!.country!)")
        }
        self.addressDetailsLabel!.text = addressDetailString
    }
    
    func close()
    {
        self.delegate.closeSessionDetailView()
    }
    
    func openMapsApp()
    {
        let coords = "\(self.session!.venue!.latitude!),\(self.session!.venue!.longitude!)"
        var query = self.session!.venue!.name!
        query.appendContentsOf(", ")
        query.appendContentsOf(self.session!.venue!.address!)
        query.appendContentsOf(", ")
        query.appendContentsOf(self.session!.venue!.city!)
        query.appendContentsOf(", ")
        query.appendContentsOf(self.session!.venue!.country!)
        query = query.stringByReplacingOccurrencesOfString("&", withString: "and")
        query = query.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
        print("querying: \(query)")
        var urlString = "http://maps.apple.com/?q=\(query)&sll=\(coords)&z=14"
        urlString.appendContentsOf(query)
        UIApplication.sharedApplication().openURL(NSURL(string: urlString)!)
    }
}