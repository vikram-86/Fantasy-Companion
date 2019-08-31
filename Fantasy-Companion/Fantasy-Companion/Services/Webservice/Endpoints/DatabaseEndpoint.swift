//
//  DatabaseEndpoint.swift
//  Fantasy-Companion
//
//  Created by Vikram on 31/08/2019.
//  Copyright © 2019 Vikram. All rights reserved.
//

import Foundation

enum DatabaseEndpoint: Endpoint {
    case getBootstrap
    
    var request: URLRequest? {
        switch self {
        case .getBootstrap:
            return request(forEndpoint: "bootstrap-static/")
        }
    }
}

extension DatabaseEndpoint {
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var httpHeaders: HTTPHeaders? {
        return nil
    }
    
    var queryItems: [URLQueryItem] {
        return []
    }
    
    var body: Data? {
        return nil
    }
}
