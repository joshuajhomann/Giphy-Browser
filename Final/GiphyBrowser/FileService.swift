//
//  FileService.swift
//  GiphyBrowser
//
//  Created by Joshua Homann on 7/17/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import Foundation

enum FileService {
    static func write<Encoded: Encodable>(_ encodable: Encoded, to filename: String) throws {
        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        let fileURL = documentDirectory.appendingPathComponent(filename)
        let data = try JSONEncoder().encode(encodable)
        try data.write(to: fileURL)
    }

    static func read<Decoded: Decodable>(type: Decoded.Type, from filename: String) throws -> Decoded  {
        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        let fileURL = documentDirectory.appendingPathComponent(filename)
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(type, from: data)
    }
}
