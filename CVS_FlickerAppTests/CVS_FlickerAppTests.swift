//
//  CVS_FlickerAppTests.swift
//  CVS_FlickerAppTests
//
//  Created by Varshith Chilamkurthi on 03/12/24.
//

import XCTest
import Combine
@testable import CVS_FlickerApp

final class CVS_FlickerAppTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = []
    var mockAPIManager: MockAPIManger!
    
    override func setUp() {
        super.setUp()
        
        mockAPIManager = MockAPIManger()
    }
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testGetData_Success() {
        mockAPIManager.getData(url: "https://mockurl.com", type: [Item].self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Expected success but got error: \(error)")
                }
            }, receiveValue: { items in
                XCTAssertEqual(items.count, 3)
                XCTAssertEqual(items.first?.title, "Item 1")
                XCTAssertEqual(items.first?.author, "Author 1")
            })
            .store(in: &cancellables)
    }
    
    func testGetData_Failure() {
        mockAPIManager.mockError = URLError(.badServerResponse)
        
        mockAPIManager.getData(url: "https://mockurl.com", type: [Item].self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Expected failure but got success")
                case .failure(let error):
                    XCTAssertEqual((error as? URLError)?.code, .badServerResponse)
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got data")
            })
            .store(in: &cancellables)
    }
}
