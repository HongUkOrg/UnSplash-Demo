//
//  SerachPhotoResponse.swift
//  UnsplashDemo
//
//  Created by bleo on 2020/10/26.
//

import Foundation

struct SearchPhotoResponse: Decodable {
    let total: Int
    let totalPage: Int
    let results: [PhotoResponse]

    private enum CodingKeys: String, CodingKey {
        case total = "total"
        case totalPage = "total_pages"
        case results = "results"
    }
}
