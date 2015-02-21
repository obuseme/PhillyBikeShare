//
//  RackAPI.swift
//  PhillyBikeShare
//
//  Created by Mike Stanziano on 2/21/15.
//  Copyright (c) 2015 Team Awesome. All rights reserved.
//

import UIKit

// Enum representing API environments
enum Environment {
    case Local

    var baseURL: NSURL {
        switch self {
        case .Local:
            // NOTE: NSURL has an optional initializer, but we're hardcoding - we'll force unwrap.
            return NSURL(string: "http://localhost:9999")!
        }
    }
}

// Enum representing the Rack endpoints
enum RackEndpoint {
    case All

    var path: String {
        switch self {
        case .All:
            return "/api/rack/all/"
        }
    }
}

func urlForEndpoint(endpoint: RackEndpoint, inEnvironment environment: Environment) -> NSURL
{
    return environment.baseURL.URLByAppendingPathComponent(endpoint.path)
}