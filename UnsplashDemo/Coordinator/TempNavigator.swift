//
//  TempNavigator.swift
//  UnsplashDemo
//
//  Created by bleo on 2020/10/25.
//

import UIKit

protocol TempNavigatorProtocol {
    associatedtype Step: NavigateStep

    // MARK: - Properties
    static var shared: Self { get }
    static var window: UIWindow? { get set }

    // MARK: - Methods
    func navigate(_ step: Step)
}

final class TempNavigator: TempNavigatorProtocol {

    typealias Step = TempNavigateStep

    // MARK: - Properties
    static let shared: TempNavigator = TempNavigator()
    static var window: UIWindow?
    private let photoViewModel: PhotoViewModelType

    init() {
        let photoRepository = PhotoRepository()
        self.photoViewModel = PhotoViewModel(repository: photoRepository)
    }

    func navigate(_ step: Step) {
        assert(Self.window != nil, "UIWindow in coordinator should be set before navigating")
        switch step {
        case .photo(let step):
            switch step {
            case .main:
                let mainVC = PhotoViewController(viewModel: photoViewModel)
                Self.window?.rootViewController = mainVC
                Self.window?.makeKeyAndVisible()
            case .dismissed:
                break
            }
        case .detail(let step):
            switch step {
            case .main(let indexPath):
                let detailVC = PhotoDetailViewController(viewModel: photoViewModel, indexPath: indexPath)
                UIViewController.topMost?.present(detailVC, animated: true)
            case .dismissed:
                break
            }
        }
    }
}
