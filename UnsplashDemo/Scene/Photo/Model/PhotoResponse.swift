//
//  PhotoResponse.swift
//  UnsplashDemo
//
//  Created by bleo on 2020/10/25.
//

import UIKit

struct PhotosResponse: Decodable {
    let photos: [PhotoUrlResponse]
}

struct PhotoResponse: Decodable {
    let width: Int
    let height: Int
    let urls: PhotoUrlResponse
    let user: UserResponse
}

struct PhotoUrlResponse: Decodable {
    let regular: String
    let small: String
    let thumb: String
}

struct UserResponse: Decodable {
    let name: String
}

extension PhotoResponse {
    var widthToHeightRatio: CGFloat {
        return CGFloat(height) / CGFloat(width)
    }
}
