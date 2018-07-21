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
        let (g, pg, pg13, r) = favorites
            .compactMap{ $0.rating }
            .reduce((0, 0, 0, 0)) { (total: (Int, Int, Int, Int), rating: Giphy.Rating) in
                let (g, pg, pg13, r) = total
                return (g + (rating == .g ? 1 : 0),
                        pg + (rating == .pg ? 1 : 0),
                        pg13 + (rating == .pg13 ? 1 : 0),
                        r + (rating == .r ? 1 : 0))
            }
        let totalSize = favorites.map { Int64($0.images.original.size) }.reduce(0,+)
        let averageSize = favorites.isEmpty ? 0 : totalSize / Int64(favorites.count)

        totalSizeLabel.text = "Total Size: \(ByteCountFormatter.fileSizeFormatter.string(fromByteCount: totalSize))"
        averageSizeLabel.text = "Avg Size: \(ByteCountFormatter.fileSizeFormatter.string(fromByteCount: averageSize))"
        ratedGLabel.text = "Rated G: \(g)"
        ratePgLabel.text = "Rated PG: \(pg)"
        ratedPg13Label.text = "Rated PG-13: \(pg13)"
        ratedRLabel.text = "Rated R: \(r)"
        countLabel.text = String(describing: favorites.count)
    }
}
