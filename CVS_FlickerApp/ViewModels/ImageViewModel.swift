//
//  ImageViewModel.swift
//  CVS_FlickerApp
//
//  Created by Varshith Chilamkurthi on 03/12/24.
//

import Foundation
import Combine

public class ImageViewModel: ObservableObject {
    @Published var images: [Item] = []
    @Published var searchText = ""
    
    var cancellables: Set<AnyCancellable> = []
    
    private var networkManager: NetworkProtocol
    private let debounceTime: DispatchQueue.SchedulerTimeType.Stride = .milliseconds(300)
    
    init(networkManager: NetworkProtocol = APIManger.shared) {
        self.networkManager = networkManager
        
        // Debounce the search text updates
        $searchText
            .debounce(for: debounceTime, scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                guard let self = self else { return }
                let tags = self.processSearchText(searchText)
                if tags.isEmpty {
                    self.fetchImages(url: Constants.API.baseURL.rawValue)
                } else {
                    self.fetchImagesForMultipleTags(tags: tags)
                }
            }
            .store(in: &cancellables)
    }
    
    // Processes the search text to create a tag list
    private func processSearchText(_ text: String) -> [String] {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedText
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
    
    // Fetches images for multiple tags and appends results
    private func fetchImagesForMultipleTags(tags: [String]) {
        images = []
        let publishers = tags.map { tag in
            APIManger.shared.getData(
                url: Constants.API.emptyBaseURL.rawValue + tag,
                type: ImageInfo.self
            )
        }
        
        // Process each tag's results individually
        publishers.forEach { publisher in
            publisher
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print(UIStrings.fetchSuccessTag.rawValue)
                    case .failure(let error):
                        print("\(UIStrings.fetchFail.rawValue): \(error.localizedDescription)")
                    }
                } receiveValue: { [weak self] result in
                    guard let self = self else { return }
                    if let newItems = result.items {
                        self.images.append(contentsOf: newItems) // Append new items
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    // Fetches images for a single URL
    func fetchImages(url: String) {
        APIManger.shared.getData(url: url, type: ImageInfo.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print(UIStrings.fetchSuccessTag.rawValue)
                case .failure(let error):
                    print("\(UIStrings.fetchFail.rawValue): \(error.localizedDescription)")
                }
            } receiveValue: { image in
                self.images = image.items ?? []
            }
            .store(in: &cancellables)
    }
    
    class MockAPIManager: NetworkProtocol {
        var mockResponse: ImageInfo?
        var mockResponses: [ImageInfo] = []
        var mockError: Error?
        private var currentResponseIndex = 0
        
        func getData<T: Decodable>(url: String, type: T.Type) -> AnyPublisher<T, Error> {
            // If an error is set, return a failing publisher
            if let error = mockError {
                return Fail(error: error).eraseToAnyPublisher()
            }
            
            // Handle multiple responses for multiple tags
            if !mockResponses.isEmpty {
                guard currentResponseIndex < mockResponses.count,
                      let response = mockResponses[currentResponseIndex] as? T else {
                    return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
                }
                
                currentResponseIndex += 1
                
                return Just(response)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            
            // Fallback to single response
            guard let response = mockResponse as? T else {
                return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
            }
            
            return Just(response)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
