//
//  TempNavigateStep.swift
//  UnsplashDemo
//
//  Created by bleo on 2020/10/25.
//

import UIKit

protocol NavigateStep { }

enum TempNavigateStep: NavigateStep {
    case photo(PhotoViewStep)
    case detail(PhotoDetailViewStep)
}

extension TempNavigateStep {
    enum PhotoViewStep {
        case main
        case dismissed
    }

    enum PhotoDetailViewStep {
        case main(IndexPath)
        case dismissed
    }
}

