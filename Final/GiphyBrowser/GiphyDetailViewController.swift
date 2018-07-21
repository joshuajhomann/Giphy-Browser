//
//  GiphyDetailViewController.swift
//  GiphyBrowser
//
//  Created by Joshua Homann on 7/15/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import UIKit

class GiphyDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var copiedView: UIView!
    enum Mode {
        case detail(Giphy)
        case favorite(Giphy)
        case cat
    }
    var mode: Mode!
    private var url: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let mode = mode else {
            return
        }
        switch mode {
        case .cat:
            Giphy.getRandom(tag: "cat") { result in
                switch result {
                case .success(let giphy):
                    DispatchQueue.main.async {
                        self.configure(with: giphy)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case .favorite(let giphy):
            configure(with: giphy)
        case .detail(let giphy):
            configure(with: giphy)
        }
    }

    func configure(with giphy: Giphy) {
        url = giphy.images.original.url
        navigationItem.title = giphy.title
        titleLabel.text = giphy.title
        ratingLabel.text = giphy.rating.flatMap{ String(describing: $0.description) } ?? "Unrated"
        sizeLabel.text = giphy.images.original.sizeDescription
        GifCache.shared.image(for: giphy.images.original.url) { [weak self] result in
            switch result {
            case .success(let image, _):
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    @IBAction private func copyToClipBoard(_ sender: Any) {
        guard let urlString = url?.absoluteString else {
            return
        }
        UIPasteboard.general.string = urlString
        copiedView.isHidden = false
        UIView.animate(withDuration: 1, animations: {
            self.copiedView.alpha = 0
        }, completion: {_ in
            self.copiedView.isHidden = true
            self.copiedView.alpha = 1
        })
    }

    @IBAction private func tap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
