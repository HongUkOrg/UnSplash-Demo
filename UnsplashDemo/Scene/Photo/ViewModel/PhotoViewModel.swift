//
//  MainViewModel.swift
//  UnsplashDemo
//
//  Created by bleo on 2020/10/25.
//

import Foundation

protocol PhotoViewModelType {
    // MARK: - Properties
    var resources: [PhotoResponse] { get }
    var currentItemPath: IndexPath { get }

    // MARK: - Methods
    func fetchPhotos(_ completion: @escaping ((Bool) -> ()))
    func setKeyWord(keyWord: String)
    func itemSelected(_ indexPath: IndexPath)
    func updateCurrentItem(_ indexPath: IndexPath)
    func clear()
}

@objc
final class PhotoViewModel: NSObject, PhotoViewModelType {

    // MARK: - Properties
    private let repository: PhotoRepositoryType
    private var fetchPage: Int = 1
    private var isFetching: Bool = false
    private var searchKeyWord: String? = nil
    @objc dynamic private(set) var currentItemPath: IndexPath = .init(row: 0, section: 0)

    var resources: [PhotoResponse] {
        return repository.photoResources
    }

    // MARK: - Initialize
    init(repository: PhotoRepositoryType) {
        self.repository = repository

    }

    // MARK: - Methods
    func fetchPhotos(_ completion: @escaping ((Bool) -> ())) {
        guard isFetching == false else { completion(false); return }
        isFetching = true
        repository.fetchPhotos(keyWord: searchKeyWord, page: fetchPage) { [weak self] (success) in
            guard let self = self, success else { completion(false); return }
            self.isFetching = false
            self.fetchPage += 1
            completion(true)
        }
    }

    func setKeyWord(keyWord: String) {
        searchKeyWord = keyWord
    }

    func itemSelected(_ indexPath: IndexPath) {
        currentItemPath = indexPath
        TempNavigator.shared.navigate(.detail(.main(indexPath)))
    }

    func updateCurrentItem(_ indexPath: IndexPath) {
        currentItemPath = indexPath
    }

    func clear() {
        isFetching = false
        fetchPage = 1
        searchKeyWord = nil
        repository.clear()
    }
}
