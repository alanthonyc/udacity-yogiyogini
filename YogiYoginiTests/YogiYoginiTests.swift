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
    
    func testExample()
    {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testExploreAPI()
    {
        let coords = CLLocationCoordinate2DMake(37.840364268076, -122.25142211)
        let receivedVenueExpectation = expectationWithDescription("Explored Venues")
        FoursquareRequestController().exploreVenues(coords.latitude, lon: coords.longitude, query:"Yoga", completion:
        { (result, error) in
            if (error == nil) {
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
            { (result, error) in
                if (error == nil) {
                    receivedVenueExpectation.fulfill()
                }
        })
        waitForExpectationsWithTimeout(5) { (error) -> Void in
            print("Search API did not fulfill without error.")
        }
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
