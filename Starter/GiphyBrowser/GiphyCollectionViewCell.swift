//
//  GiphyCollectionViewCell.swift
//  GiphyBrowser
//
//  Created by Joshua Homann on 7/16/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import UIKit

protocol GiphyCollectionViewCellDelegate: class {
    func giphyCollectionViewCell(_ cell: GiphyCollectionViewCell, didUpdate isStar: Bool)
}

//FIXME: Issue 11 (Easy) Access control.  Make EVERYTHING that should be private private
class GiphyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    var isStar: Bool = false {
        didSet {
            starButton.setImage(isStar ? #imageLiteral(resourceName: "button.filled.star") : #imageLiteral(resourceName: "button.empty.star"), for: .normal)
        }
    }
    static let reuseIdentifier = String(describing: GiphyCollectionViewCell.self)
    weak var delegate: GiphyCollectionViewCellDelegate?
    func configure(with giphy: Giphy, isStar: Bool, delegate: GiphyCollectionViewCellDelegate) {
        self.isStar = isStar
        self.delegate = delegate
        titleLabel.text = giphy.title
        ratingLabel.text = giphy.rating.flatMap{ String(describing: $0) } ?? "Unrated"
        sizeLabel.text = ByteCountFormatter.fileSizeFormatter.string(fromByteCount: Int64(giphy.images.original.size))
        GifCache.shared.image(for: giphy.images.fixedHeight.url) { [weak self] image, downloadedURL, error in
            if error != nil {
                print(error!)
                return
            }
            if downloadedURL != giphy.images.fixedHeight.url  {
                return
            }
            DispatchQueue.main.async {
                self?.gifImageView.image = image!
            }
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        gifImageView.image = nil
    }
    @IBAction func tapStar(_ sender: Any) {
        isStar = !isStar
        delegate?.giphyCollectionViewCell(self, didUpdate: isStar)
    }
}

