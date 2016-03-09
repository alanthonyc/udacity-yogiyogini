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
    
    func callAPIEndpoint(url: String, arguments: NSDictionary, apiCompletion: CompletionHander)
    {
        let session = NSURLSession.sharedSession()
        let urlString = url + escapedParameters(arguments as! [String : AnyObject])
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request)
        { (data, response, error) in
            
            guard (error == nil) else {
                print("There was an error with the call to Foursquare: \(error)")
                // TODO: error condition
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response. Status code: \(response.statusCode)!")
                    // TODO: error condition
                } else if let response = response {
                    print("Your request returned an invalid response. Response: \(response)!")
                    // TODO: error condition
                } else {
                    print("Your request returned an invalid response.")
                    // TODO: error condition
                }
                return
            }
            
            guard let data = data else {
                print("No data was returned by the request!")
                // TODO: error condition
                return
            }
            
            let json: AnyObject!
            do {
                json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                apiCompletion(result: json, error: error)
            } catch {
                json = nil
                print("Could not parse the data as JSON: '\(data)'")
                // TODO: error condition
                return
            }
        }
        task.resume()
    }
    
    func exploreVenues(lat: Double, lon: Double, query: String, completion: CompletionHander)
    {
        let coords = "\(lat),\(lon)"
        let methodArguments = [
            "client_id": kCLIENT_ID,
            "client_secret": kCLIENT_SECRET,
            "ll": coords,
            "v": kAPI_VERSION,
            "m": kAPI_TYPE,
            "sortByDistance": "1",
            "query": query,
        ]
        
        callAPIEndpoint(k4SQ_VENUES_URL, arguments: methodArguments, apiCompletion:
        { (json, error) in
            guard let meta = json["meta"] as? NSDictionary else {
                print("Cannot get meta info from root dictionary: \(json)")
                // TODO: error condition
                return
            }
            
            guard let response = json["response"] as? NSDictionary else {
                print("Cannot find response in root: \(json)")
                // TODO: error condition
                return
            }
            
            guard let group = response["groups"]![0] as? NSDictionary else {
                print("Could not get group from response: \(response)")
                // TODO: error condition
                return
            }
            
            guard let venues = group["items"] as? NSArray else {
                print("Could not get venues from group: \(group)")
                // TODO: error condition
                return
            }
            let result = NSDictionary(objects: [meta, venues], forKeys: ["meta", "venues"])
            completion(result: result, error: error)
        })
    }
    
    func searchYogaVenues(lat: Double, lon: Double, name: String, completion:CompletionHander)
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
        
        callAPIEndpoint(k4SQ_SEARCH_URL, arguments: methodArguments, apiCompletion: { (json, error) in
            guard let meta = json["meta"] as? NSDictionary else {
                print("Cannot get meta info from root dictionary: \(json)")
                // TODO: error condition
                return
            }
            
            guard let response = json["response"] as? NSDictionary else {
                print("Cannot find response in root: \(json)")
                // TODO: error condition
                return
            }
            
            guard let venues = response["venues"] as? NSArray else {
                print("Could not get venues from response: \(response)")
                // TODO: error condition
                return
            }
            let result = NSDictionary(objects: [meta, venues], forKeys: ["meta", "venues"])
            completion(result: result, error: error)
        })
    }
}