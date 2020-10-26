//
//  PhotoViewController.swift
//  UnsplashDemo
//
//  Created by bleo on 2020/10/25.
//

import UIKit

@objc
class PhotoViewController: BaseViewController {

    // MARK: - Properties
    private let viewModel: PhotoViewModelType

    // MARK: - Initialize
    init(viewModel: PhotoViewModelType) {
        self.viewModel = viewModel
        self.pictureCollectionView = PhotoCollectionView(viewModel: viewModel)
        self.searchTextField = UITextField()
        super.init()
        self.searchTextField.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchPhotos { [weak self] (completed) in
            guard completed else { return }
            DispatchQueue.main.async { [weak self] in
                self?.pictureCollectionView.reloadData()
            }
        }
    }

    // MARK: - UI
    private let pictureCollectionView: PhotoCollectionView
    private let searchTextField: UITextField

    // MARK: - SetUp UI
    override func setupConstraints() {
        view.backgroundColor = .white

        view.addSubview(searchTextField)
        searchTextField.placeholder = "Please input text"
        searchTextField.layer.borderWidth = 1.0
        searchTextField.layer.borderColor = UIColor.systemBlue.cgColor
        searchTextField.layer.cornerRadius = 15
        searchTextField.layer.masksToBounds = true
        searchTextField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0);
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 50)

        ])

        view.addSubview(pictureCollectionView)
        pictureCollectionView.backgroundColor = .clear
        pictureCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pictureCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 15),
            pictureCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pictureCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pictureCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension PhotoViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let keyWord = textField.text, keyWord.isEmpty == false else {
            return
        }
        viewModel.clear()
        viewModel.setKeyWord(keyWord: keyWord)
        viewModel.fetchPhotos { (_) in
            DispatchQueue.main.async { [weak self] in
                self?.pictureCollectionView.reloadData()
                self?.pictureCollectionView.setContentOffset(.zero, animated: false)
            }
        }
    }
}
