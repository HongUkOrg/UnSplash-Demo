//
//  DownloadService.swift
//  UnsplashDemo
//
//  Created by bleo on 2020/10/25.
//

import Foundation

final class ImageDownloadService {

    // MARK: - Instance
    static let shared: ImageDownloadService = ImageDownloadService()

    // MARK: - Properties
    private let urlSession: URLSession
    private var cache: TempCache<String, Data>

    // MARK: - Initialize
    private init() {
        self.urlSession = URLSession(configuration: .default)
        self.cache = TempCache(threshold: 100)
    }

    func download(urlString: String, _ completion: @escaping ((Data?) -> ())) {
        if let data = cache[urlString] {
            completion(data)
            return
        }
        DispatchQueue.global().async { [weak self]  in
            guard let url = URL(string: urlString) else { return }
            self?.urlSession.dataTask(with: url) { [weak self] (data, response, error) in
                if let error = error {
                    print("Error: Failed to download image \(error)")
                    completion(nil)
                    return
                }
                if let data = data {
                    self?.cache[urlString] = data
                    completion(data)
                }
            }.resume()
        }
    }
}
