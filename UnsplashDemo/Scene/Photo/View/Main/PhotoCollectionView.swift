//
//  PhotoCollectionView.swift
//  UnsplashDemo
//
//  Created by bleo on 2020/10/25.
//

import UIKit

final class PhotoCollectionView: UICollectionView {

    // MARK: - Properteis
    private let viewModel: PhotoViewModelType
    private var observationOfCurrentItemPath: NSKeyValueObservation?

    private var focusedPositionY: CGFloat {
        return self.contentOffset.y + self.bounds.height
    }
    private var updateThreshold: CGFloat {
        return self.contentSize.height - Metric.updateOffset
    }

    enum Metric {
        static let collectionViewWidth: CGFloat = UIScreen.main.bounds.width
        static let collectionViewHeight: CGFloat = 200
        static let updateOffset: CGFloat = Metric.collectionViewHeight * 3.0 / 4.0
    }

    // MARK: - Initialize
    init(viewModel: PhotoViewModelType) {
        self.viewModel = viewModel

        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 3
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.sectionInset = UIEdgeInsets.zero

        super.init(frame: .zero, collectionViewLayout: collectionViewLayout)
        self.delegate = self
        self.dataSource = self
        self.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(PhotoCollectionViewCell.self))

        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Bind
    private func bind() {
        guard let viewModel = viewModel as? PhotoViewModel else { return }
        self.observationOfCurrentItemPath = viewModel.observe(\.currentItemPath, options: [.new]) { [weak self] (_, value) in
            guard let indexPath = value.newValue else { return }
            self?.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
        }
    }

    // MARK: - Deinitialize
    deinit {
        self.observationOfCurrentItemPath = nil
    }
}

// MARK: - CollectionView Delegates
extension PhotoCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, ImageDownloadTraits {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.resources.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NSStringFromClass(PhotoCollectionViewCell.self),
            for: indexPath
        )
        guard let photoCell = cell as? PhotoCollectionViewCell else { return cell }
        let resource = viewModel.resources[indexPath.row]
        photoCell.urlString = resource.urls.small
        photoCell.author = resource.user.name

        return photoCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.itemSelected(indexPath)
    }
}

extension PhotoCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = viewModel.resources[indexPath.row]
        return CGSize(width: UIScreen.main.bounds.width,
                      height: UIScreen.main.bounds.width * photo.widthToHeightRatio)
    }
}

// MARK: - ScrollView Delegates
extension PhotoCollectionView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if focusedPositionY > updateThreshold {
            viewModel.fetchPhotos { (completed) in
                guard completed else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.reloadData()
                }
            }
        }
    }
}
