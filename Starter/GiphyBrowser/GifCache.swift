//
//  GifCache.swift
//  GiphyBrowser
//
//  Created by Joshua Homann on 7/16/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import UIKit

class GifCache {
    static let shared = GifCache()
    private let cache = NSCache<NSURL, UIImage>()
    private init() { }
    //FIXME: Issue 10 (advanced) replace heterogeneous types with enum
    func image(for url: URL, completion: @escaping (UIImage?, URL?, Error?) -> ()) {
        guard let image = cache.object(forKey: url as NSURL) else {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let `self` = self,
                      let image = UIImage.gif(url: url.absoluteString) else {
                    completion(nil, nil, NSError())
                    return
                }
                self.cache.setObject(image, forKey: url as NSURL)
                completion(image, url, nil)
            }
            return
        }
        completion(image, url, nil)
    }
}
