//
//  MainRepository.swift
//  UnsplashDemo
//
//  Created by bleo on 2020/10/25.
//

import Foundation

protocol PhotoRepositoryType {
    // MARK: - Properties
    var photoResources: [PhotoResponse] { get }

    // MARK: - Methods
    func fetchPhotos(keyWord: String?, page: Int, _ completion: @escaping ((Bool) -> ()))
    func clear()
}

final class PhotoRepository: PhotoRepositoryType {

    // MARK: - Protocol Properties
    private(set) var photoResources: [PhotoResponse] = []

    // MARK: - Properties
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder

    // MARK: - Initialize
    init() {
        self.urlSession = URLSession(configuration: .default)
        self.jsonDecoder = JSONDecoder()
    }

    // MARK: - Methods
    func fetchPhotos(keyWord: String?, page: Int, _ completion: @escaping ((Bool) -> ())) {
        if let keyWord = keyWord {
            fetchPhotos(keyWord: keyWord, page: page, completion)
        } else {
            fetchPhotos(page: page, completion)
        }
    }

    func clear() {
        photoResources = []
    }
}

extension PhotoRepository {
    // MARK: - Methods
    private func fetchPhotos(page: Int, _ completion: @escaping ((Bool) -> ())) {
        guard let url = PhotoEndPoint.common.makeUrl(page: page) else { completion(false); return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            /// Connection Error
            if let error = error {
                print("Error: Failed to get photos:: \(error)")
                completion(false)
                return
            }
            /// StatusCode Error
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("Error: Status code - \(response.statusCode)")
                completion(false)
                return
            }
            /// Data Error
            guard let data = data else {
                print("Error: Invalid data")
                completion(false)
                return
            }
            /// Success
            do {
                let photoResponse = try JSONDecoder().decode([PhotoResponse].self, from: data)
                self.photoResources += photoResponse
                completion(true)
            } catch { /// Decoding Error
                print("Error: Failed to decode response \(error)")
                completion(false)
            }

        }.resume()
    }

    private func fetchPhotos(keyWord: String, page: Int, _ completion: @escaping ((Bool) -> ())) {
        guard let url = PhotoEndPoint.search.makeUrl(page: page, query: keyWord) else { completion(false); return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            /// Connection Error
            if let error = error {
                print("Error: Failed to get photos:: \(error)")
                completion(false)
                return
            }
            /// StatusCode Error
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("Error: Status code - \(response.statusCode)")
                completion(false)
                return
            }
            /// Data Error
            guard let data = data else {
                print("Error: Invalid data")
                completion(false)
                return
            }
            /// Success
            do {
                let searchPhotoResponse = try JSONDecoder().decode(SearchPhotoResponse.self, from: data)
                self.photoResources += searchPhotoResponse.results
                completion(true)
            } catch { /// Decoding Error
                print("Error: Failed to decode response \(error)")
                completion(false)
            }

        }.resume()
    }
}
