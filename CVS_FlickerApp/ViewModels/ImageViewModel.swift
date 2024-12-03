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
    
    var searchedApiUrl: String {
        let baseUrl = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=porcupine"
        if !searchText.isEmpty {
            return "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(searchText)"
        } else {
            return baseUrl
        }
    }
    
    var cancellables: Set<AnyCancellable> = []
    
    func fetchImages(url: String) {
        APIManger.shared.getData(url: url, type: ImageInfo.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished fetching images")
                case .failure:
                    print("Error fetching images")
                }
            } receiveValue: { image in
                self.images = image.items ?? []
            }
            .store(in: &cancellables)
    }
}
