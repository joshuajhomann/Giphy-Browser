//
//  FavoriteHeaderView.swift
//  GiphyBrowser
//
//  Created by Joshua Homann on 7/17/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import UIKit

class FavoriteHeaderView: UIView {
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var ratedGLabel: UILabel!
    @IBOutlet weak var ratePgLabel: UILabel!
    @IBOutlet weak var ratedPg13Label: UILabel!
    @IBOutlet weak var ratedRLabel: UILabel!
    @IBOutlet weak var totalSizeLabel: UILabel!
    @IBOutlet weak var averageSizeLabel: UILabel!
    func configure(with favorites: [Giphy]) {
        //FIXME Issue 8 (Intermediate) Express this computation without any for loops
        var g = 0
        var pg = 0
        var pg13 = 0
        var r = 0
        var totalSize: Int64 = 0
        for giphy in favorites {
            if giphy.rating == "g" {
                g += 1
            } else if giphy.rating == "pg" {
                pg += 1
            } else if giphy.rating == "pg-13" {
                pg13 += 1
            } else if giphy.rating == "r" {
                r += 1
            }
            totalSize += Int64(giphy.images.original.size)
        }

        //FIXME: Issue 9 (Easy) make avergaeSize a let
        var averageSize:Int64 =  0
        if favorites.count > 0 {
            averageSize = totalSize / Int64(favorites.count)
        }

        totalSizeLabel.text = "Total Size: \(ByteCountFormatter.fileSizeFormatter.string(fromByteCount: totalSize))"
        averageSizeLabel.text = "Avg Size: \(ByteCountFormatter.fileSizeFormatter.string(fromByteCount: averageSize))"
        ratedGLabel.text = "Rated G: \(g)"
        ratePgLabel.text = "Rated PG: \(pg)"
        ratedPg13Label.text = "Rated PG-13: \(pg13)"
        ratedRLabel.text = "Rated R: \(r)"
        countLabel.text = String(describing: favorites.count)
    }
}
