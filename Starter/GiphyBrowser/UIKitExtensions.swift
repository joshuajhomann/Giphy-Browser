//
//  UIKitExtensions.swift
//  GiphyBrowser
//
//  Created by Joshua Homann on 7/17/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import UIKit

//FIXME: Issue 14 (Advanced) Protocol Extensions
protocol ReuseIdentifiable {
}

extension ReuseIdentifiable {
}

extension ByteCountFormatter {
    static var fileSizeFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter
    }()
}
