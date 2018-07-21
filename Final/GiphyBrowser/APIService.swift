//
//  APIService.swift
//  GiphyBrowser
//
//  Created by Joshua Homann on 7/16/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import Foundation

import UIKit

enum APIService {
    enum Result<T> {
        case success(T)
        case failure(Error)
    }
    static let domain = "https://api.giphy.com/v1/gifs/"
    static let requiredParamenters: [String: Any] = ["api_key": "dc6zaTOxFJmzC"]
    static let pageSize = 25
    static func getCodable<Decoded: Decodable>(from path: String, parameters: [String: Any] = [:], completion: @escaping (Result<Decoded>) -> ()) {
        let paramterString = requiredParamenters
            .merging(parameters) {required, _ in required}
            .map { key, value in "\(key)=\(value)"}
            .joined(separator: "&")
        let request = URLRequest(url: URL(string: "\(domain)\(path)?".appending(paramterString))!)
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                completion(.failure(error ?? NSError(domain: "Unknown", code: 0, userInfo: nil)))
                return
            }
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(Decoded.self, from: data)
                completion(.success(decoded))
            } catch (let error) {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

extension Giphy {
    static func getRandom(tag: String, completion: @escaping (APIService.Result<Giphy>) -> ()) {
        let path = "random"
        let parameters: [String: Any] = ["tag": tag.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "random"]
        APIService.getCodable(from: path, parameters: parameters) { (result: APIService.Result<GiphyContainer>) -> () in
            switch result {
            case .success(let container):
                completion(.success(container.data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }

    static func getSearchResults(term: String, page: Int, completion: @escaping (APIService.Result<GiphyPage>) -> ()) {
        let path = "search"
        let parameters: [String: Any] = [
            "q": term.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "random",
            "offset": APIService.pageSize * page,
            "limit": APIService.pageSize
        ]
        APIService.getCodable(from: path, parameters: parameters, completion: completion)
    }
}
