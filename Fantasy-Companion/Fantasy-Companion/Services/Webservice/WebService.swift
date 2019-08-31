//
//  WebService.swift
//  Fantasy-Companion
//
//  Created by Vikram on 31/08/2019.
//  Copyright © 2019 Vikram. All rights reserved.
//

import UIKit

//MARK: Network Stack Errors
enum NetworkStackError: Error {
    case invalidRequest
    case dataMissing
    case responseError(error: Error)
    case parserError(error: Error)
}

typealias ResultCallback<T> = (Result<T, NetworkStackError>) -> Void

//MARK: Network Activity
protocol NetworkActivityProtocol {
    func increment()
    func decrement()
}

class NetworkActivity: NetworkActivityProtocol {
    private var activityCount: Int = 0 {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = (activityCount > 0 )
        }
    }
    
    func increment() {
        OperationQueue.main.addOperation {
            self.activityCount += 1
        }
    }
    
    func decrement() {
        OperationQueue.main.addOperation {
            self.activityCount -= 1
        }
    }
}

//MARK: Parser
protocol ParserProtocol {
    func json<T: Decodable>(data: Data, completion: @escaping ResultCallback<T>)
}

struct Parser: ParserProtocol {
    let decoder = JSONDecoder()
    
    func json<T>(data: Data,
                 completion: @escaping (Result<T, NetworkStackError>) -> Void) where T : Decodable {
        do {
            let result: T = try decoder.decode(T.self, from: data)
            OperationQueue.main.addOperation {completion(.success(result))}
        } catch let error {
            OperationQueue.main.addOperation {completion(.failure(.parserError(error: error)))}
        }
    }
}

//MARK: WebService

protocol WebServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping ResultCallback<T>)
}

class WebService: WebServiceProtocol {
    private let urlSession: URLSession
    private let parser: Parser
    private let networkActivity: NetworkActivityProtocol
    
    init(urlSession: URLSession = URLSession(configuration: .default),
         parser: Parser = Parser(),
         networkActivity: NetworkActivityProtocol = NetworkActivity()) {
        self.urlSession = urlSession
        self.parser = parser
        self.networkActivity = networkActivity
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint,
                    completion: @escaping ResultCallback<T>) {
        guard let request = endpoint.request else {
            OperationQueue.main.addOperation {
                completion(.failure(.invalidRequest))
            }
            return
        }
        networkActivity.increment()
        urlSession.dataTask(with: request) { (data, response, error) in
            self.networkActivity.decrement()
            
            if let error = error {
                OperationQueue.main.addOperation {
                    completion(.failure(.responseError(error: error)))
                }
                return
            }
            
            guard let data = data else {
                OperationQueue.main.addOperation {
                    completion(.failure(.dataMissing))
                }
                return
            }
            self.parser.json(data: data, completion: completion)
        }.resume()
    }
}


