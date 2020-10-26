//
//  ImageTraits.swift
//  UnsplashDemo
//
//  Created by bleo on 2020/10/25.
//

import UIKit

protocol ImageDownloadTraits {}

// MARK: - Extensions
extension ImageDownloadTraits {
    func downloadImage(urlString: String, _ completion: @escaping((UIImage?) -> ())) {
        ImageDownloadService.shared.download(urlString: urlString) { (data) in
            guard let data = data, let image = UIImage(data: data) else {
                print("Error: Failed to make image from data - \(urlString)")
                completion(nil)
                return
            }
            completion(image)
        }
    }
}
