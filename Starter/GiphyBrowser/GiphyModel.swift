//
//  GiphyPage.swift
//  GiphyBrowser
//
//  Created by Joshua Homann on 7/15/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

//FIXME: Issue 3 make all of these struct Codable
struct GiphyPage {
    var data: [Giphy]
    init(json: JSON) {
        let array = json["data"] as! [JSON]
        var data: [Giphy] = []
        for element in array {
            data.append(Giphy(json: element))
        }
        self.data = data
    }
    var dictionaryValue: JSON {
        return ["data": data.map {$0.dictionaryValue}]
    }
}

struct GiphyContainer {
    let data: Giphy
    init(json: JSON) {
        data = Giphy(json: json["data"] as! JSON)
    }
    var dictionaryValue: JSON {
        return ["data": data.dictionaryValue]
    }
}

struct Giphy {
    var id: String
    // FIXME: Issue 2 (Easy) Instead of a string make rating an enum called Rating.  Also make Rating conform to CustomStringConvertible
    typealias Rating = String
    var rating: Rating?
    var images: Images
    var title: String

    init(json: JSON) {
        id = json["id"] as? String ?? UUID().uuidString
        rating = json["Rating"] as? String
        images = Images(json: json["images"] as! JSON)
        title = json["title"] as! String
    }
    var dictionaryValue: JSON {
        return ["id": id,
                "rating": rating,
                "images": images.dictionaryValue,
                "title" : title]
    }

    struct Images {
        let original: Info
        let fixedHeight: Info
        init(json: JSON) {
            original = Info(json: json["original"] as! JSON)
            fixedHeight = Info(json: json["fixed_height"] as! JSON)
        }
        var dictionaryValue: JSON {
            return ["original": original.dictionaryValue, "fixed_height": fixedHeight.dictionaryValue]
        }

        //FIXME: Issue 1 (Easy) Extend Info and make a computed property sizeDescription that returns the size as a formatted string using ByteCountFormatter
        struct Info {
            let url: URL
            let size: Int
            init(json: JSON) {
                url = URL(string: json["url"] as! String)!
                size = Int(json["size"] as! String)!
            }
            var dictionaryValue: JSON {
                return ["url": url.absoluteString, "size": String(describing: size)]
            }
        }
    }

}

