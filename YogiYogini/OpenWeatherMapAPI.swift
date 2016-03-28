//
//  OpenWeatherMapAPI.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 3/28/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//

import Foundation

private let kAPI_KEY = "83dc5b7f6bcc5310e4c1e6b37c766a0c"

private struct OpenWeatherMapURL
{
    static let ByCoords = "http://api.openweathermap.org/data/2.5/weather"
}

class OpenWeatherMapRequestController: NSObject
{
    typealias CompletionHandler = (result: AnyObject?, error: NSError?) -> Void
    
    private func escapedParameters(parameters: [String : AnyObject]) -> String
    {
        var urlVars = [String]()
        for (key, value) in parameters {
            
            let stringValue = "\(value)"
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    private func callAPIEndpoint(url: String, arguments: NSDictionary, apiCompletion: CompletionHandler)
    {
        let session = NSURLSession.sharedSession()
        let urlString = url + escapedParameters(arguments as! [String : AnyObject])
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request)
        { (data, response, error) in
            
            guard (error == nil) else
            {
                apiCompletion(result: nil, error: error)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else
            {
                var errorString = "The call to OpenWeatherMap returned an error."
                if let response = response as? NSHTTPURLResponse {
                    errorString.appendContentsOf(" Error code: \(response.statusCode)")
                    
                } else if let response = response {
                    errorString.appendContentsOf(" Error code: \(response)")
                }
                let errorJSON = ["error":errorString]
                apiCompletion(result: errorJSON, error: error)
                return
            }
            
            guard let data = data else
            {
                let errorJSON = ["error": "No data was returned by the request."]
                apiCompletion(result: errorJSON, error: error)
                return
            }
            
            let json: AnyObject!
            do {
                json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                apiCompletion(result: json, error: error)
                
            } catch {
                let errorJSON = ["error": "The data could not be parsed as JSON.", "data":"\(data)"]
                apiCompletion(result: errorJSON, error: nil)
                return
            }
        }
        task.resume()
    }
    
    func getWeather(lat: Double, lon: Double, completion: CompletionHandler)
    {
        let methodArguments = [
            "appid": kAPI_KEY,
            "lat": lat,
            "lon": lon,
            ]
        
        callAPIEndpoint(OpenWeatherMapURL.ByCoords, arguments: methodArguments, apiCompletion:
            { (json, error) in
                
                guard error == nil && json != nil else
                {
                    completion(result: json, error: error)
                    return
                }
                
                guard let main = json!["main"] as? NSDictionary else
                {
                    let userInfo = [
                        NSLocalizedDescriptionKey: NSLocalizedString(YogiErrorDescriptionParsingFailureError, comment: ""),
                        NSLocalizedFailureReasonErrorKey: NSLocalizedString("'main' from root", comment: ""),
                        NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString("", comment: "")
                    ]
                    let parsingError = NSError(domain: YogiErrorDomain, code: YogiErrorCodeParseFailure, userInfo: userInfo)
                    completion(result: nil, error: parsingError)
                    return
                }
                
                guard let temperature = main["temp"]! as? Double else
                {
                    let userInfo = [
                        NSLocalizedDescriptionKey: NSLocalizedString(YogiErrorDescriptionParsingFailureError, comment: ""),
                        NSLocalizedFailureReasonErrorKey: NSLocalizedString("'temp' from main", comment: ""),
                        NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString("", comment: ""),
                        "additionalInfo": main,
                    ]
                    let parsingError = NSError(domain: YogiErrorDomain, code: YogiErrorCodeParseFailure, userInfo: userInfo)
                    completion(result: nil, error: parsingError)
                    return
                }
                
                let result = NSDictionary(objects: [temperature], forKeys: ["kelvin"])
                completion(result: result, error: error)
        })
    }
}