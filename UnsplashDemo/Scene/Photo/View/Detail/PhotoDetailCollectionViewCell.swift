//
//  PhotoDetailCollectionViewCell.swift
//  UnsplashDemo
//
//  Created by bleo on 2020/10/25.
//

import UIKit

final class PhotoDetailCollectionViewCell: UICollectionViewCell, ImageDownloadTraits {

    var urlString: String? {
        didSet {
            guard let urlString = urlString else { return }
            downloadImage(urlString: urlString) { (image) in
                DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = image
                }
            }
        }
    }

    var author: String? {
        get {
            return photoName.text
        }
        set {
            photoName.text = newValue
        }
    }

    // MARK: - Initialize
    override init(frame: CGRect) {
        self.imageView = UIImageView()
        self.photoName = UILabel()

        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    private let imageView: UIImageView
    private let photoName: UILabel

    // MARK: - SetUp
    private func setUp() {
        self.backgroundColor = .clear

        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])


        imageView.addSubview(photoName)
        photoName.translatesAutoresizingMaskIntoConstraints = false
        photoName.textColor = .white
        photoName.font = .systemFont(ofSize: 15, weight: .bold)
        NSLayoutConstraint.activate([
            photoName.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 15),
            photoName.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -15),
        ])

    }

    // MARK: - View Life Cycle
    override func prepareForReuse() {
        imageView.image = nil
        super.prepareForReuse()
    }
}
