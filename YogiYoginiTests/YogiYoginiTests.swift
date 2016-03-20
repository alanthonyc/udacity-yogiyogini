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
    
    func testTimeModuleSeconds()
    {
        let sevenSecs = Seconds(value: 7)
        print("Testing 07 Seconds...")
        XCTAssertEqual(sevenSecs.asDouble, 7.0, "(dbl): \(sevenSecs.asDouble)")
        XCTAssertEqual(sevenSecs.inSeconds, 7.0, "(scs): \(sevenSecs.inSeconds)")
        XCTAssertEqual(sevenSecs.inMinutes.asDouble, 0.0, "(min): \(sevenSecs.inMinutes.asDouble)")
        XCTAssertEqual(sevenSecs.inHours.asDouble, 0.0, "(hrs): \(sevenSecs.inHours.asDouble)")
        XCTAssertEqual(sevenSecs.string, "7", "(strg): \(sevenSecs)")
        XCTAssertEqual(sevenSecs.paddedString, "07", "(pstr): \(sevenSecs)")
        var (h, m, s) = sevenSecs.components()
        XCTAssertEqual(h.paddedString, "00", "(comp): \(h)")
        XCTAssertEqual(m.paddedString, "00", "(comp): \(m)")
        XCTAssertEqual(s.paddedString, "07", "(comp): \(s)")
        
        let fortyTwoSecs = Seconds(value: 42)
        print("Testing 42 Seconds...")
        XCTAssertEqual(fortyTwoSecs.asDouble, 42.0, "(dbl): \(fortyTwoSecs.asDouble)")
        XCTAssertEqual(fortyTwoSecs.inSeconds, 42.0, "(scs): \(fortyTwoSecs.inSeconds)")
        XCTAssertEqual(fortyTwoSecs.inMinutes.asDouble, 0.0, "(min): \(fortyTwoSecs.inMinutes.asDouble)")
        XCTAssertEqual(fortyTwoSecs.inHours.asDouble, 0.0, "(hrs): \(fortyTwoSecs.inHours.asDouble)")
        XCTAssertEqual(fortyTwoSecs.string, "42", "(string): \(fortyTwoSecs)")
        XCTAssertEqual(fortyTwoSecs.paddedString, "42", "(pstr): \(fortyTwoSecs)")
        (h, m, s) = fortyTwoSecs.components()
        XCTAssertEqual(h.paddedString, "00", "(comp): \(h)")
        XCTAssertEqual(m.paddedString, "00", "(comp): \(m)")
        XCTAssertEqual(s.paddedString, "42", "(comp): \(s)")
        
        let sixtySecs = Seconds(value: 60)
        print("Testing 60 Seconds...")
        XCTAssertEqual(sixtySecs.asDouble, 60.0, "(dbl): \(sixtySecs.asDouble)")
        XCTAssertEqual(sixtySecs.inSeconds, 60.0, "(scs): \(sixtySecs.inSeconds)")
        XCTAssertEqual(sixtySecs.inMinutes.asDouble, 1.0, "(min): \(sixtySecs.inMinutes.asDouble)")
        XCTAssertEqual(sixtySecs.inHours.asDouble, 0.0, "(hrs): \(sixtySecs.inHours.asDouble)")
        XCTAssertEqual(sixtySecs.string, "60", "(str): \(sixtySecs)")
        XCTAssertEqual(sixtySecs.paddedString, "60", "(pstr): \(sixtySecs)")
        (h, m, s) = sixtySecs.components()
        XCTAssertEqual(h.paddedString, "00", "(comp): \(h)")
        XCTAssertEqual(m.paddedString, "01", "(comp): \(m)")
        XCTAssertEqual(s.paddedString, "00", "(comp): \(s)")
        
        let seventyThreeSecs = Seconds(value: 73)
        print("Testing 73 Secs...")
        XCTAssertEqual(seventyThreeSecs.asDouble, 73.0, "(dbl): \(seventyThreeSecs.asDouble)")
        XCTAssertEqual(seventyThreeSecs.inSeconds, 73.0, "(scs): \(seventyThreeSecs.inSeconds)")
        XCTAssertEqual(seventyThreeSecs.inMinutes.asDouble, 1.0, "(min): \(seventyThreeSecs.inMinutes.asDouble)")
        XCTAssertEqual(seventyThreeSecs.inHours.asDouble, 0.0, "(hrs): \(seventyThreeSecs.inHours.asDouble)")
        XCTAssertEqual(seventyThreeSecs.string, "73", "(str): \(seventyThreeSecs)")
        XCTAssertEqual(seventyThreeSecs.paddedString, "73", "(pstr): \(seventyThreeSecs)")
        (h, m, s) = seventyThreeSecs.components()
        XCTAssertEqual(h.paddedString, "00", "(comp): \(h)")
        XCTAssertEqual(m.paddedString, "01", "(comp): \(m)")
        XCTAssertEqual(s.paddedString, "13", "(comp): \(s)")
        
        let threeAndTwentyTwoSecs = Seconds(value: 202)
        print("Testing 322 Secs...")
        XCTAssertEqual(threeAndTwentyTwoSecs.asDouble, 202.0, "(dbl): \(threeAndTwentyTwoSecs.asDouble)")
        XCTAssertEqual(threeAndTwentyTwoSecs.inSeconds, 202.0, "(scs): \(threeAndTwentyTwoSecs.inSeconds)")
        XCTAssertEqual(threeAndTwentyTwoSecs.inMinutes.asDouble, 3.0, "(min): \(threeAndTwentyTwoSecs.inMinutes.asDouble)")
        XCTAssertEqual(threeAndTwentyTwoSecs.inHours.asDouble, 0.0, "(hrs): \(threeAndTwentyTwoSecs.inHours.asDouble)")
        XCTAssertEqual(threeAndTwentyTwoSecs.string, "202", "(str): \(threeAndTwentyTwoSecs)")
        XCTAssertEqual(threeAndTwentyTwoSecs.paddedString, "202", "(pstr): \(threeAndTwentyTwoSecs)")
        (h, m, s) = threeAndTwentyTwoSecs.components()
        XCTAssertEqual(h.paddedString, "00", "(comp): \(h)")
        XCTAssertEqual(m.paddedString, "03", "(comp): \(m)")
        XCTAssertEqual(s.paddedString, "22", "(comp): \(s)")
        
        let threeHours3MinsAnd22Secs = Seconds(value: 11002)
        print("Testing 11002 Secs...")
        XCTAssertEqual(threeHours3MinsAnd22Secs.asDouble, 11002.0, "(dbl): \(threeHours3MinsAnd22Secs.asDouble)")
        XCTAssertEqual(threeHours3MinsAnd22Secs.inSeconds, 11002.0, "(scs): \(threeHours3MinsAnd22Secs.inSeconds)")
        XCTAssertEqual(threeHours3MinsAnd22Secs.inMinutes.asDouble, 183.0, "(min): \(threeHours3MinsAnd22Secs.inMinutes.asDouble)")
        XCTAssertEqual(threeHours3MinsAnd22Secs.inHours.asDouble, 3.0, "(hrs): \(threeHours3MinsAnd22Secs.inHours.asDouble)")
        XCTAssertEqual(threeHours3MinsAnd22Secs.string, "11002", "(str): \(threeHours3MinsAnd22Secs)")
        XCTAssertEqual(threeHours3MinsAnd22Secs.paddedString, "11002", "(pstr): \(threeHours3MinsAnd22Secs)")
        (h, m, s) = threeHours3MinsAnd22Secs.components()
        XCTAssertEqual(h.paddedString, "03", "(comp): \(h)")
        XCTAssertEqual(m.paddedString, "03", "(comp): \(m)")
        XCTAssertEqual(s.paddedString, "22", "(comp): \(s)")
    }
    
    func testTimeModuleMinutes()
    {
        let mins1 = Minutes(value: 1)
        print("Testing 1 Minute...\(mins1)")
        XCTAssertEqual(mins1.asDouble, 1.0, "(dbl): \(mins1.asDouble)")
        XCTAssertEqual(mins1.inSeconds, 60.0, "(scs): \(mins1.inSeconds)")
        XCTAssertEqual(mins1.inMinutes.asDouble, 1.0, "(min): \(mins1.inMinutes.asDouble)")
        XCTAssertEqual(mins1.inHours.asDouble, 0.0, "(hrs): \(mins1.inHours.asDouble)")
        XCTAssertEqual(mins1.string, "1", "(strg): \(mins1)")
        XCTAssertEqual(mins1.paddedString, "01", "(pstr): \(mins1)")
        var (h, m, s) = mins1.components()
        XCTAssertEqual(h.paddedString, "00", "(comp): \(h)")
        XCTAssertEqual(m.paddedString, "01", "(comp): \(m)")
        XCTAssertEqual(s.paddedString, "00", "(comp): \(s)")
        
        let mins10 = mins1.multipliedBy(10)
        print("Testing 10 Minutes...\(mins1) * 10 == \(mins10)")
        XCTAssertEqual(mins10.asDouble, 10.0, "(dbl): \(mins10.asDouble)")
        XCTAssertEqual(mins10.inSeconds, 600.0, "(scs): \(mins10.inSeconds)")
        XCTAssertEqual(mins10.inMinutes.asDouble, 10.0, "(min): \(mins10.inMinutes.asDouble)")
        XCTAssertEqual(mins10.inHours.asDouble, 0.0, "(hrs): \(mins10.inHours.asDouble)")
        XCTAssertEqual(mins10.string, "10", "(strg): \(mins10)")
        XCTAssertEqual(mins10.paddedString, "10", "(pstr): \(mins10)")
        (h, m, s) = mins10.components()
        XCTAssertEqual(h.paddedString, "00", "(comp): \(h)")
        XCTAssertEqual(m.paddedString, "10", "(comp): \(m)")
        XCTAssertEqual(s.paddedString, "00", "(comp): \(s)")
        
        let mins60 = mins10.multipliedBy(6)
        print("Testing 60 Minutes...\(mins60)")
        XCTAssertEqual(mins60.asDouble, 60.0, "(dbl): \(mins60.asDouble)")
        XCTAssertEqual(mins60.inSeconds, 3600.0, "(scs): \(mins60.inSeconds)")
        XCTAssertEqual(mins60.inMinutes.asDouble, 60.0, "(min): \(mins60.inMinutes.asDouble)")
        XCTAssertEqual(mins60.inHours.asDouble, 1.0, "(hrs): \(mins60.inHours.asDouble)")
        XCTAssertEqual(mins60.string, "60", "(strg): \(mins60)")
        XCTAssertEqual(mins60.paddedString, "60", "(pstr): \(mins60)")
        (h, m, s) = mins60.components()
        XCTAssertEqual(h.paddedString, "01", "(comp): \(h)")
        XCTAssertEqual(m.paddedString, "00", "(comp): \(m)")
        XCTAssertEqual(s.paddedString, "00", "(comp): \(s)")
        
        let mins84 = (mins60 + Minutes(value: 24)).inMinutes
        print("Testing 84 Minutes...\(mins84)")
        XCTAssertEqual(mins84.asDouble, 84.0, "(dbl): \(mins84.asDouble)")
        XCTAssertEqual(mins84.inSeconds, 5040.0, "(scs): \(mins84.inSeconds)")
        XCTAssertEqual(mins84.inMinutes.asDouble, 84.0, "(min): \(mins84.inMinutes.asDouble)")
        XCTAssertEqual(mins84.inHours.asDouble, 1.0, "(hrs): \(mins84.inHours.asDouble)")
        XCTAssertEqual(mins84.string, "84", "(strg): \(mins84)")
        XCTAssertEqual(mins84.paddedString, "84", "(pstr): \(mins84)")
        (h, m, s) = mins84.components()
        XCTAssertEqual(h.paddedString, "01", "(comp): \(h)")
        XCTAssertEqual(m.paddedString, "24", "(comp): \(m)")
        XCTAssertEqual(s.paddedString, "00", "(comp): \(s)")
        
        let mins93and12 = mins84 + Minutes(value: 9) + Seconds(value: 12)
        print("Testing 93 Minutes and 12 Seconds...\(mins93and12)")
        XCTAssertEqual(mins93and12.asDouble, 5592.0, "(dbl): \(mins93and12.asDouble)")
        XCTAssertEqual(mins93and12.inSeconds, 5592.0, "(scs): \(mins93and12.inSeconds)")
        XCTAssertEqual(mins93and12.inMinutes.asDouble, 93.0, "(min): \(mins93and12.inMinutes.asDouble)")
        XCTAssertEqual(mins93and12.inHours.asDouble, 1.0, "(hrs): \(mins93and12.inHours.asDouble)")
        XCTAssertEqual(mins93and12.string, "5592", "(strg): \(mins93and12)")
        XCTAssertEqual(mins93and12.paddedString, "5592", "(pstr): \(mins93and12)")
        (h, m, s) = mins93and12.components()
        XCTAssertEqual(h.paddedString, "01", "(comp): \(h)")
        XCTAssertEqual(m.paddedString, "33", "(comp): \(m)")
        XCTAssertEqual(s.paddedString, "12", "(comp): \(s)")
    }
    
    func testTimeModuleHours()
    {
        let hours1 = Hours(value: 1)
        print("Testing 1 Hours...\(hours1)")
        XCTAssertEqual(hours1.asDouble, 1.0, "(dbl): \(hours1.asDouble)")
        XCTAssertEqual(hours1.inSeconds, 3600.0, "(scs): \(hours1.inSeconds)")
        XCTAssertEqual(hours1.inMinutes.asDouble, 60.0, "(min): \(hours1.inMinutes.asDouble)")
        XCTAssertEqual(hours1.inHours.asDouble, 1.0, "(hrs): \(hours1.inHours.asDouble)")
        XCTAssertEqual(hours1.string, "1", "(strg): \(hours1)")
        XCTAssertEqual(hours1.paddedString, "01", "(pstr): \(hours1)")
        var (h, m, s) = hours1.components()
        XCTAssertEqual(h.paddedString, "01", "(comp): \(h)")
        XCTAssertEqual(m.paddedString, "00", "(comp): \(m)")
        XCTAssertEqual(s.paddedString, "00", "(comp): \(s)")
        
        let hours2 = (hours1.multipliedBy(2)).inHours
        print("Testing 1 Hours...\(hours2)")
        XCTAssertEqual(hours2.asDouble, 2.0, "(dbl): \(hours2.asDouble)")
        XCTAssertEqual(hours2.inSeconds, 7200.0, "(scs): \(hours2.inSeconds)")
        XCTAssertEqual(hours2.inMinutes.asDouble, 120.0, "(min): \(hours2.inMinutes.asDouble)")
        XCTAssertEqual(hours2.inHours.asDouble, 2.0, "(hrs): \(hours2.inHours.asDouble)")
        XCTAssertEqual(hours2.string, "2", "(strg): \(hours2)")
        XCTAssertEqual(hours2.paddedString, "02", "(pstr): \(hours1)")
        (h, m, s) = hours2.components()
        XCTAssertEqual(h.paddedString, "02", "(comp): \(h)")
        XCTAssertEqual(m.paddedString, "00", "(comp): \(m)")
        XCTAssertEqual(s.paddedString, "00", "(comp): \(s)")
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
