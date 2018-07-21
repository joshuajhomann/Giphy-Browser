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
        let paramterString = APIService.parameterString(from: parameters)
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
    static func parameterString(from parameters: [String: Any]) -> String {
        //FIXME: Issue 5: (Advanced)  Replace the below with a single functional return
        var apiParameters: [String: Any] = [:]
        for (key, value) in APIService.requiredParamenters {
            apiParameters[key] = value
        }
        for (key, value) in parameters {
            apiParameters[key] = value
        }
        var pairs: [String] = []
        for (key, value) in apiParameters {
            pairs.append("\(key)=\(value)")
        }
        var parameterString = pairs.first!
        for pair in pairs.dropFirst() {
            parameterString += "&\(pair)"
        }
        return parameterString
    }
}

extension Giphy {
    static func getRandom(tag: String, completion: @escaping (APIService.Result<Giphy>) -> ()) {
        let path = "random"
        let parameters: [String: Any] = ["tag": tag.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "random"]
        //FIXME: Issue 4 (Intermediate): Replace the code below with a generic request to getCodable
        let paramterString = APIService.parameterString(from: parameters)
        let request = URLRequest(url: URL(string: "\(APIService.domain)\(path)?".appending(paramterString))!)
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                completion(.failure(error!))
                return
            }
            guard let data = data,
            let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? JSON else {
                completion(.failure(error ?? NSError(domain: "Unknown", code: 0, userInfo: nil)))
                return
            }
            let giphyContainer = GiphyContainer.init(json: json)
            completion(.success(giphyContainer.data))
        }
        task.resume()

    }

    static func getSearchResults(term: String, page: Int, completion: @escaping (APIService.Result<GiphyPage>) -> ()) {
        let path = "search"
        let parameters: [String: Any] = [
            "q": term.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "random",
            "offset": APIService.pageSize * page,
            "limit": APIService.pageSize
        ]
        //FIXME: Issue 4 (Intermediate): Replace the code below with a generic request to getCodable
        let paramterString = APIService.parameterString(from: parameters)
        let request = URLRequest(url: URL(string: "\(APIService.domain)\(path)?".appending(paramterString))!)
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                completion(.failure(error!))
                return
            }
            guard let data = data,
                let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? JSON else {
                    completion(.failure(error ?? NSError(domain: "Unknown", code: 0, userInfo: nil)))
                    return
            }
            let giphyPage = GiphyPage.init(json: json)
            completion(.success(giphyPage))
        }
        task.resume()
    }
}
