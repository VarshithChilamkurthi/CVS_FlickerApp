//
//  ImageViewModel.swift
//  CVS_FlickerApp
//
//  Created by Varshith Chilamkurthi on 03/12/24.
//

import Foundation
import Combine

class ImageViewModel: ObservableObject {
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
                    self.fetchImages(url: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=porcupine")
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
                url: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(tag)",
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
                        print("Finished fetching images for tag")
                    case .failure(let error):
                        print("Error fetching images: \(error.localizedDescription)")
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
    
    /// Fetches images for a single URL
    func fetchImages(url: String) {
        APIManger.shared.getData(url: url, type: ImageInfo.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished fetching images")
                case .failure(let error):
                    print("Error fetching images: \(error.localizedDescription)")
                }
            } receiveValue: { image in
                self.images = image.items ?? []
            }
            .store(in: &cancellables)
    }
}
