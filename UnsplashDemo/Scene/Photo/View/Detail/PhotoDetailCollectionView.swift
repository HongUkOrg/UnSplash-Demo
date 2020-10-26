//
//  PhotoDetailCollectionView.swift
//  UnsplashDemo
//
//  Created by bleo on 2020/10/25.
//

import UIKit

final class PhotoDetailCollectionView: UICollectionView {

    // MARK: - Static properties
    enum Metric {
        static let collectionViewWidth: CGFloat = UIScreen.main.bounds.width
        static let collectionViewHeight: CGFloat = UIScreen.main.bounds.height - 100
        static let updateOffset: CGFloat = Metric.collectionViewWidth / 2.0
    }

    // MARK: - Properteis
    private let viewModel: PhotoViewModelType
    private let indexPath: IndexPath
    private var previousWidth: CGFloat = 0
    private var observationOfContentSize: NSKeyValueObservation?

    private var focusedPositionX: CGFloat {
        return self.contentOffset.x + self.bounds.width
    }
    private var updateThreshold: CGFloat {
        return self.contentSize.width - Metric.updateOffset
    }

    // MARK: - Initialize
    init(viewModel: PhotoViewModelType, indexPath: IndexPath) {
        self.viewModel = viewModel
        self.indexPath = indexPath

        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: Metric.collectionViewWidth,
                                               height: Metric.collectionViewHeight)
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.sectionInset = UIEdgeInsets.zero

        super.init(frame: .zero, collectionViewLayout: collectionViewLayout)

        self.isPagingEnabled = true
        self.delegate = self
        self.dataSource = self
        self.register(PhotoDetailCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(PhotoDetailCollectionViewCell.self))

        setUp()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - SetUp
    private func setUp() {
        self.backgroundColor = .white
    }

    // MARK: - Bind
    private func bind() {
        self.observationOfContentSize = self.observe(\.contentSize, options: [.new]) { [weak self] (_, value) in
            guard let self = self,
                  let size = value.newValue, size.width > 0,
                  size.width != self.previousWidth else { return }
            self.previousWidth = size.width
            self.scrollToItem(at: self.viewModel.currentItemPath, at: .centeredHorizontally, animated: false)
        }
    }

    // MARK: - Deinitialize
    deinit {
        observationOfContentSize = nil
    }
}

// MARK: - CollectionView Delegates
extension PhotoDetailCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.resources.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NSStringFromClass(PhotoDetailCollectionViewCell.self),
            for: indexPath
        )
        guard let photoDetailCell = cell as? PhotoDetailCollectionViewCell else { return cell }
        let resource = viewModel.resources[indexPath.row]
        photoDetailCell.urlString = resource.urls.small
        photoDetailCell.author = resource.user.name

        return photoDetailCell
    }
}

// MARK: - ScrollView Delegates
extension PhotoDetailCollectionView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if focusedPositionX > updateThreshold &&
            numberOfItems(inSection: 0) < viewModel.resources.count {
            DispatchQueue.main.async { [weak self] in
                self?.reloadData()
            }
        }

    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let index = Int(scrollView.contentOffset.x / Metric.collectionViewWidth)
        viewModel.updateCurrentItem(IndexPath(row: index, section: 0))
    }
}
