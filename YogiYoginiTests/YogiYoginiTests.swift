//
//  YogiYoginiTests.swift
//  YogiYoginiTests
//
//  Created by A. Anthony Castillo on 2/29/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//

import XCTest
import MapKit
@testable import YogiYogini

class YogiYoginiTests: XCTestCase
{
    override func setUp()
    {
        super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown()
    {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExploreAPI()
    {
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let coords = CLLocationCoordinate2DMake(37.840364268076, -122.25142211)
        let receivedVenueExpectation = expectationWithDescription("Explored Venues")
        FoursquareRequestController().exploreVenues(coords.latitude, lon: coords.longitude, query:"Yoga", completion:
        { (results, error) in
            if (error == nil) {
                let requestId = results!["meta"]!!["requestId"]
                print("Request #\(requestId) received.")
                receivedVenueExpectation.fulfill()
            }
        })
        waitForExpectationsWithTimeout(5) { (error) -> Void in
            print("Explore API did not fulfill without error.")
        }
    }
    
    func testSearchAPI()
    {
        let coords = CLLocationCoordinate2DMake(37.840364268076, -122.25142211)
        let receivedVenueExpectation = expectationWithDescription("Explored Venues")
        FoursquareRequestController().searchYogaVenues(coords.latitude, lon: coords.longitude, name:"Namaste", completion:
            { (results, error) in
                if (error == nil) {
                    let requestId = results!["meta"]!!["requestId"]
                    print("Request #\(requestId) received.")
                    receivedVenueExpectation.fulfill()
                }
            })
        waitForExpectationsWithTimeout(5) { (error) -> Void in
            print("Search API did not fulfill without error.")
        }
    }
    
    func testDurationFormatter()
    {
        let testSubMinute = 46 // 00:00
        let testMinute = 73 // 01:00
        let testHour = 4440 // 1:14
        let formattedSubMinute = ClassViewController().formattedDuration(testSubMinute)
        let formattedMinute = ClassViewController().formattedDuration(testMinute)
        let formattedHour = ClassViewController().formattedDuration(testHour)
        XCTAssertEqual(formattedSubMinute, "00:00", "Sub minute formatting incorrect: \(formattedSubMinute)")
        XCTAssertEqual(formattedMinute, "00 01", "One minute formatting incorrect: \(formattedMinute)")
        XCTAssertEqual(formattedHour, "01:14", "One hour formatting incorrect: \(formattedHour)")
    }
    
    func testPerformanceExample()
    {
    // This is an example of a performance test case.
        self.measureBlock
        {
        // Put the code you want to measure the time of here.
        }
    }
}
