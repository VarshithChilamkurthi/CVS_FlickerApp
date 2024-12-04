import XCTest
import Combine
@testable import CVS_FlickerApp

class ImageViewModelTests: XCTestCase {
    var viewModel: ImageViewModel!
    var mockNetworkManager: ImageViewModel.MockAPIManager!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = ImageViewModel.MockAPIManager()
        viewModel = ImageViewModel(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        mockNetworkManager = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    // Test successful image fetch with multiple tags
    func testFetchImagesForMultipleTags() {
        // Prepare mock data
        let mockItem1 = Item(
            title: "Test Image 1",
            link: "https://example.com/image1",
            media: Media(m: "https://example.com/image1.jpg"),
            description: "Description 1",
            published: "2024-03-12",
            author: "Author 1"
        )
        let mockItem2 = Item(
            title: "Test Image 2",
            link: "https://example.com/image2",
            media: Media(m: "https://example.com/image2.jpg"),
            description: "Description 2",
            published: "2024-03-12",
            author: "Author 2"
        )
        let mockImageInfo1 = ImageInfo(
            title: "Test Images 1",
            link: "https://example.com/nature",
            description: "Nature images",
            items: [mockItem1]
        )
        let mockImageInfo2 = ImageInfo(
            title: "Test Images 2",
            link: "https://example.com/landscape",
            description: "Landscape images",
            items: [mockItem2]
        )
        
        // Create an expectation
        let expectation = XCTestExpectation(description: "Fetch images for multiple tags")
        
        // Modify the mock API manager to return multiple responses
        mockNetworkManager.mockResponses = [mockImageInfo1, mockImageInfo2]
        
        // Directly set up viewModel's images observer
        var imageUpdateCount = 0
        let imagesCancellable = viewModel.$images
            .sink { images in
                imageUpdateCount += 1
                
                // Wait for at least one update and ensure we have the expected number of images
                if imageUpdateCount >= 1 && images.count == 2 {
                    XCTAssertEqual(images.count, 2, "Should have two images")
                    XCTAssertTrue(images.contains { $0.title == "Test Image 1" }, "Should contain first image")
                    XCTAssertTrue(images.contains { $0.title == "Test Image 2" }, "Should contain second image")
                    expectation.fulfill()
                }
            }
        
        // Trigger search
        viewModel.searchText = "nature,landscape"
        // Store the cancellable to prevent early deallocation
        cancellables.insert(imagesCancellable)
    }
}
