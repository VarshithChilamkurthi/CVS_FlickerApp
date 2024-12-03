//
//  CVS_FlickerAppTests.swift
//  CVS_FlickerAppTests
//
//  Created by Varshith Chilamkurthi on 03/12/24.
//

import XCTest
import Combine
@testable import CVS_FlickerApp

class ImageViewModelTests: XCTestCase {
    var viewModel = ImageViewModel()
//    var mockAPIManager: MockAPIManager?
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
//        mockAPIManager = MockAPIManager()
//        viewModel = ImageViewModel(networkManager: mockAPIManager)
        cancellables = []
    }
    
    override func tearDown() {
//        viewModel = nil
//        mockAPIManager = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchImagesForSingleTag() {
        // Test with a single tag
        viewModel.fetchImages(url: "mock_url")
        
        let expectation = XCTestExpectation(description: "Fetch images for a single tag")
        
        viewModel.$images
            .sink { images in
                if !images.isEmpty {
                    XCTAssertEqual(images.count, 3, "Should fetch 3 dummy images")
                    XCTAssertEqual(images.first?.title, "Nature 1", "First image title should match")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchImagesForMultipleTags() {
        // Simulate multiple tags
        viewModel.searchText = "nature, sports"
        
        let expectation = XCTestExpectation(description: "Fetch images for multiple tags")
        
        viewModel.$images
            .dropFirst() // Skip the initial empty state
            .sink { images in
                if images.count == 6 { // Expecting 3 images per tag, 2 tags = 6 images
                    XCTAssertEqual(images[0].title, "Nature 1", "First image title should match for nature")
                    XCTAssertEqual(images[3].title, "Sports 1", "First image title should match for sports")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testEmptySearchReturnsDefaultImages() {
        // Simulate an empty search
        viewModel.searchText = ""
        
        let expectation = XCTestExpectation(description: "Fetch default images")
        
        viewModel.$images
            .dropFirst() // Skip the initial empty state
            .sink { images in
                if images.count == 3 { // Default set has 3 dummy images
                    XCTAssertEqual(images[0].title, "Nature 1", "First image title should match default")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}

