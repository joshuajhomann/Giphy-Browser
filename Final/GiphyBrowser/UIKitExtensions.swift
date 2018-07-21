//
//  UIKitExtensions.swift
//  GiphyBrowser
//
//  Created by Joshua Homann on 7/17/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import UIKit

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension ByteCountFormatter {
    static var fileSizeFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter
    }()
}
