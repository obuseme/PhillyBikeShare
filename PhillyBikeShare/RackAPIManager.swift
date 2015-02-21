//
//  RackAPIManager.swift
//  PhillyBikeShare
//
//  Created by Mike Stanziano on 2/21/15.
//  Copyright (c) 2015 Team Awesome. All rights reserved.
//

let currentEnvironment = Environment.Local

@objc class RackAPIManager
{
    //! Not sure if this is the "normal" paradigm yet - but reads nicely in Obj-C.
    class func `new`() -> RackAPIManager {
        return RackAPIManager()
    }

    func loadAllRacks() {
        let allRacksURL = urlForEndpoint(RackEndpoint.All, inEnvironment: currentEnvironment)

//        if let allRacks = loadRequestForURL(allRacksURL) {
//
//        }
    }

    func loadRequestForURL(url: NSURL) {
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlSession = NSURLSession(configuration: sessionConfiguration)

        let task = urlSession.dataTaskWithURL(url, completionHandler: {
            (data: NSData!, response: NSURLResponse!, error:NSError!) in
            if error != nil {
                println("error: \(error.localizedDescription): \(error.userInfo)")
            }
            else if data != nil {
                if let str = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    var jsonError: NSError?
                    let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &jsonError)
                    let deserializedDictionary = jsonObject as Dictionary<String, AnyObject>
                    let dataArray = deserializedDictionary["data"] as [AnyObject]
//                    return dataArray
                }
                else {
                    println("unable to convert data to text")
                }
            }
        })
        
        task.resume()
    }
}