//
//  PhotoDetailViewController.swift
//  UnsplashDemo
//
//  Created by bleo on 2020/10/25.
//

import UIKit

final class PhotoDetailViewController: BaseViewController {

    // MARK: - Properties
    private let viewModel: PhotoViewModelType
    private let photoDeatilCollectionView: PhotoDetailCollectionView

    // MARK: - Initialize
    init(viewModel: PhotoViewModelType, indexPath: IndexPath) {
        self.viewModel = viewModel
        self.photoDeatilCollectionView = PhotoDetailCollectionView(viewModel: viewModel, indexPath: indexPath)
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - SetUp UI
    override func setupConstraints() {
        self.view.backgroundColor = .white

        view.addSubview(photoDeatilCollectionView)
        photoDeatilCollectionView.backgroundColor = .white
        photoDeatilCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoDeatilCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoDeatilCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoDeatilCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoDeatilCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
