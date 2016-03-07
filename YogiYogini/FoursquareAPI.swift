//
//  FoursquareAPI.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 3/3/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//

import Foundation

let kCLIENT_ID = "JVA4E2YMEKOMFDOQSC05U12U225EJHHQHIHY41TPRNQQWYXW"
let kCLIENT_SECRET = "J223UY0ECDXCGI0MYXVJIUGYVFSULGLNQOEZMH42KMEGEIHT"
let kAPI_VERSION = "20151201"
let kAPI_TYPE = "foursquare"
let kYOGA_SEARCH_CATEGORY_ID = "4bf58dd8d48988d102941735"

let k4SQ_VENUES_URL = "https://api.foursquare.com/v2/venues/explore"
let k4SQ_SEARCH_URL = "https://api.foursquare.com/v2/venues/search"

class FoursquareRequestController: NSObject
{
    typealias CompletionHander = (result: AnyObject!, error: NSError?) -> Void

    func getYogaVenuesAroundLocation(lat: Double, lon: Double)
    {
        let coords = "\(lat),\(lon)"
        let methodArguments = [
            "client_id": kCLIENT_ID,
            "client_secret": kCLIENT_SECRET,
            "ll": coords,
            "v": kAPI_VERSION,
            "m": kAPI_TYPE,
            "sortByDistance": "1",
            "query": "Yoga",
        ]
        
        let session = NSURLSession.sharedSession()
        let urlString = k4SQ_VENUES_URL + escapedParameters(methodArguments)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard (error == nil) else {
                print("There was an error with the call to Foursquare: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                parsedResult = nil
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard let meta = parsedResult["meta"] as? NSDictionary else {
                print("Cannot get meta info from root dictionary: \(parsedResult)")
                return
            }
            print("Meta info: \(meta)")
            
            guard let response = parsedResult["response"] as? NSDictionary else {
                print("Cannot find response in root: \(parsedResult)")
                return
            }
            
            guard let group = response["groups"]![0] as? NSDictionary else {
                print("Could not get group from response: \(response)")
                return
            }
            
            guard let venues = group["items"] as? NSArray else {
                print("Could not get venues from group: \(group)")
                return
            }
            
            for v in venues
            {
                guard let venue = v["venue"] else { break }
                
                guard let id = venue!["id"] else { break }
                guard let name = venue!["name"] else { break }
                
                guard let location = venue!["location"] else { break }
                guard let address = location!["address"] else { break }
                guard let crossStreet = location!["crossStreet"] else { break }
                guard let lat = location!["lat"] else { break }
                guard let lng = location!["lng"] else { break }
                guard let city = location!["city"] else { break }
                
                print("Venue: \(name!)(\(id)) - \(lat) / \(lng) \n \(address), near \(crossStreet), in \(city)")
            }
        }
        task.resume()
    }

    func searchForAYogaVenueNear(lat: Double, lon: Double, name: String)
    {
        let coords = "\(lat),\(lon)"
        let methodArguments = [
            "client_id": kCLIENT_ID,
            "client_secret": kCLIENT_SECRET,
            "ll": coords,
            "v": kAPI_VERSION,
            "m": kAPI_TYPE,
            "query": name,
            "categoryId": kYOGA_SEARCH_CATEGORY_ID,
        ]
        
        let session = NSURLSession.sharedSession()
        let urlString = k4SQ_SEARCH_URL + escapedParameters(methodArguments)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard (error == nil) else {
                print("There was an error with the call to Foursquare: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                parsedResult = nil
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard let meta = parsedResult["meta"] as? NSDictionary else {
                print("Cannot get meta info from root dictionary: \(parsedResult)")
                return
            }
            print("Meta info: \(meta)")
            
            guard let response = parsedResult["response"] as? NSDictionary else {
                print("Cannot find response in root: \(parsedResult)")
                return
            }
            
            guard let venues = response["venues"] as? NSArray else {
                print("Could not get venues from response: \(response)")
                return
            }
            
            for v in venues
            {
                guard let id = v["id"] else { break }
                guard let name = v["name"] else { break }
                
                guard let location = v["location"] else { break }
                guard let address = location!["address"] else { break }
                guard let lat = location!["lat"] else { break }
                guard let lng = location!["lng"] else { break }
                guard let city = location!["city"] else { break }
                
                print("Venue: \(name!)(\(id!)) - \(lat!) / \(lng!) \n \(address!), in \(city!)")
            }
        }
        task.resume()
    }

    
    func escapedParameters(parameters: [String : AnyObject]) -> String
    {
        var urlVars = [String]()
        for (key, value) in parameters {
            
            let stringValue = "\(value)"
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
}