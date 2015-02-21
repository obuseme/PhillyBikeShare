//
//  Structs.swift
//  PhillyBikeShare
//
//  Created by Mike Stanziano on 2/21/15.
//  Copyright (c) 2015 Team Awesome. All rights reserved.
//

struct Rack {
    let rackId: String
    let lat: String
    let lng: String
    let name: String
    let maxBikes: Int
    let availBikes: Int

    static func decode(json: [String : AnyObject]) -> Rack? {
        if let rackId = json["_id"] as? String {
            if let lat = json["lat"] as? String {
                if let lng = json["lng"] as? String {
                    if let name = json["name"] as? String {
                        if let maxBikes = json["maxBikes"] as? Int {
                            if let availBikes = json["availBikes"] as? Int {
                                return Rack(rackId: rackId, lat: lat, lng: lng, name: name, maxBikes: maxBikes, availBikes: availBikes)
                            }
                        }
                    }
                }
            }
        }

        return .None
    }

}
