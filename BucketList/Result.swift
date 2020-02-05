//
//  Result.swift
//  BucketList
//
//  Created by Sarvad shetty on 2/5/20.
//  Copyright © 2020 Sarvad shetty. All rights reserved.
//

import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    //adding to check if desc if there or not
    var description: String {
        terms?["description"]?.first ?? "No further information"
    }
    
    //sorting func
    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}
