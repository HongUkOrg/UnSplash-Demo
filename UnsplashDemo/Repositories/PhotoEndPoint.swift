//
//  PhotoEndPoint.swift
//  UnsplashDemo
//
//  Created by bleo on 2020/10/26.
//

import Foundation

enum PhotoEndPoint {
    case search
    case common
}

extension PhotoEndPoint {

    var baseUrl: String {
        return "https://api.unsplash.com"
    }

    var endPoint: String {
        switch self {
        case .search:
            return self.baseUrl + "/search/photos"
        case .common:
            return self.baseUrl + "/photos"
        }
    }

    var queryItems: [URLQueryItem] {
        return [URLQueryItem(name: "client_id", value: "Htx22xXxMxrpU0bFhp6_HEqWHXXnVpna4DMNdcbl4TQ")]
    }

    func makeUrl(page: Int, query: String? = nil) -> URL? {

        guard var urlComponents: URLComponents = URLComponents(string: self.endPoint) else { return nil }
        urlComponents.queryItems = self.queryItems
        urlComponents.queryItems?.append(URLQueryItem(name: "page", value: String(page)))

        switch self {
        case .common:
            break
        case .search:
            guard let query = query else { break }
            urlComponents.queryItems?.append(URLQueryItem(name: "query", value: query))
        }

        return urlComponents.url
    }
}
