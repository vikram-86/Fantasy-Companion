//
//  Endpoint.swift
//  Fantasy-Companion
//
//  Created by Vikram on 31/08/2019.
//  Copyright © 2019 Vikram. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case put
    case get
    case delete
    case post
    
    var value: String {
        return self.rawValue.uppercased()
    }
}

typealias HTTPHeaders = [String : String]

protocol Endpoint {
    var baseUrl: URLComponents { get}
    var request: URLRequest? { get }
    var httpMethod: HTTPMethod { get }
    var httpHeaders: HTTPHeaders? { get }
    var queryItems: [URLQueryItem] { get }
    var body: Data? { get }
}

extension Endpoint {
    
    var baseUrl: URLComponents {
        guard let components = URLComponents(string: "https://fantasy.premierleague.com/api/")
        else { fatalError("BaseURL error") }
        return components
    }
    
    
    func request(forEndpoint endpoint: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.host = baseUrl.host!
        urlComponents.scheme = baseUrl.scheme
        urlComponents.path = baseUrl.path + endpoint
        
        guard let url = urlComponents.url else { return nil }
        return request(forUrl: url)
        
    }
    
    private func request(forUrl url: URL) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.value
        
        if let httpHeaders = httpHeaders {
            httpHeaders.forEach {
                request.setValue($0.value,
                                 forHTTPHeaderField: $0.key) }
        }
        request.httpBody = body
        return request
    }
}
