//
//  FileService.swift
//  GiphyBrowser
//
//  Created by Joshua Homann on 7/17/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import Foundation

//FIXME: Issue 12 (Advanced) make these functions generic
enum FileService {
    static func write(giphies: [Giphy], to filename: String) throws {
        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        let fileURL = documentDirectory.appendingPathComponent(filename)
        let data = try JSONSerialization.data(withJSONObject: giphies.map{$0.dictionaryValue}, options: [])
        try data.write(to: fileURL)
    }

    static func read(from filename: String) throws -> [Giphy]  {
        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        let fileURL = documentDirectory.appendingPathComponent(filename)
        let data = try Data(contentsOf: fileURL)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [JSON]
        return json.map(Giphy.init(json:))
    }
}
