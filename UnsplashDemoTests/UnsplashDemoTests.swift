//
//  UnsplashDemoTests.swift
//  UnsplashDemoTests
//
//  Created by bleo on 2020/10/25.
//

import XCTest
@testable import UnsplashDemo

class UnsplashDemoTests: XCTestCase {

    var photoRepository: PhotoRepositoryType!
    var photoViewModel: PhotoViewModelType!
    var photoVC: PhotoViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    override func setUp() {
        super.setUp()
        self.photoRepository = PhotoRepository()
        self.photoViewModel = PhotoViewModel(repository: photoRepository)
        self.photoVC = PhotoViewController(viewModel: photoViewModel)
    }

    override func tearDown() {
        super.tearDown()
        self.photoRepository = nil
        self.photoViewModel = nil
        self.photoVC = nil
    }

    func testUrl() {
        XCTAssert(PhotoEndPoint.common.endPoint == "https://api.unsplash.com/photos")
        XCTAssert(PhotoEndPoint.search.endPoint == "https://api.unsplash.com/search/photos")

        let commonUrl = PhotoEndPoint.common.makeUrl(page: 1, query: "hello")
        let searchUrl = PhotoEndPoint.search.makeUrl(page: 1, query: "hello")

        let commonUrlComponents = URLComponents(url: commonUrl!, resolvingAgainstBaseURL: false)!
        let searchUrlComponents = URLComponents(url: searchUrl!, resolvingAgainstBaseURL: false)!

        XCTAssert(commonUrlComponents.queryItems?.first { $0.name == "page" }?.value == "1")
        XCTAssert(searchUrlComponents.queryItems?.first { $0.name == "page" }?.value == "1")
        XCTAssert(commonUrlComponents.queryItems?.first { $0.name == "query" } == nil)
        XCTAssert(searchUrlComponents.queryItems?.first { $0.name == "query" } != nil)
    }

    func testCache() {
        let threshold = 10
        var cache = TempCache<String, Data>(threshold: threshold)
        for i in 1...20 {
            let key = String(i)
            cache[key] = Data()
            if i == threshold + 1 {
                XCTAssert(cache["1"] == nil)
                XCTAssert(cache["2"] == nil)
                XCTAssert(cache["3"] == nil)
                XCTAssert(cache["4"] == nil)
                XCTAssert(cache["5"] == nil)
                XCTAssert(cache["11"] != nil)
            }
        }
        XCTAssert(cache["9"] == nil)
        XCTAssert(cache["20"] != nil)
    }

    func testCache2() {
        let threshold = 10
        var cache = TempCache<String, Data>(threshold: threshold)
        for i in 1...20 {
            let key = String(i)
            cache[key] = Data()
        }
        // use 18
        let _ = cache["18"]
        for i in 21...23 {
            let key = String(i)
            cache[key] = Data()
        }
        // 18 should be exist because it was used again
        XCTAssert(cache["18"] != nil)
        XCTAssert(cache["19"] == nil)
        XCTAssert(cache["20"] != nil)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
