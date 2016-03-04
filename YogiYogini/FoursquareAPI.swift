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
let k4SQ_VENUES_URL = "https://api.foursquare.com/v2/venues/explore"

let FLICKR_DICT_URLM = "url_m"
let FLICKR_DICT_ID = "id"

class FoursquareRequestController: NSObject
{
    typealias CompletionHander = (result: AnyObject!, error: NSError?) -> Void

    func getVenuesAroundLocation(lat: Double, lon: Double, completionHandler: CompletionHander)
    {
        let coords = "\(lat),\(lon)"
        let methodArguments = [
            "ll": coords,
            "v": kAPI_VERSION,
            "m": kAPI_TYPE,
            "client_id": kCLIENT_ID,
            "client_secret": kCLIENT_SECRET,
            "sortByDistance": "1",
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
            
            guard let stat = parsedResult["stat"] as? String where stat == "ok" else {
                print("Foursquare API returned an error. See error code and message in \(parsedResult)")
                return
            }
            
            guard let photosDictionary = parsedResult["photos"] as? NSDictionary,
                _ = photosDictionary["photo"] as? [[String: AnyObject]] else {
                    print("Cannot find keys 'photos' and 'photo' in \(parsedResult)")
                    return
            }
            
            guard let _ = photosDictionary["pages"] as? Int else {
                print("Cannot find key 'pages' in \(photosDictionary)")
                return
            }
            completionHandler(result: photosDictionary, error: error)
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