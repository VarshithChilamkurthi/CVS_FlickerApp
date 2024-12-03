//
//  MockAPIManager.swift
//  CVS_FlickerApp
//
//  Created by Varshith Chilamkurthi on 03/12/24.
//

import Foundation
import Combine

class MockAPIManager: NetworkProtocol {
    func getData<T: Decodable>(url: String, type: T.Type) -> AnyPublisher<T, Error> {
        let dummyData: Data
        let decoder = JSONDecoder()
        
        // Define dummy data
        if type == ImageInfo.self {
            let items = [
                Item(title: "Nature 1", link: "link1", media: Media(m: "https://example.com/nature1.jpg"), description: "Nature 1 description", published: "2024-11-01T10:00:00Z", author: "Author 1"),
                Item(title: "Sports 1", link: "link2", media: Media(m: "https://example.com/sports1.jpg"), description: "Sports 1 description", published: "2024-11-02T11:00:00Z", author: "Author 2"),
                Item(title: "Nature 2", link: "link3", media: Media(m: "https://example.com/nature2.jpg"), description: "Nature 2 description", published: "2024-11-03T12:00:00Z", author: "Author 3")
            ]
            let imageInfo = ImageInfo(
                title: "Mock Title",
                link: "https://example.com",
                description: "Mock Description",
                items: items
            )
            
            // Encode the dummy data into JSON
            dummyData = try! JSONEncoder().encode(imageInfo)
        } else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        // Return dummy data wrapped in a publisher
        return Just(dummyData)
            .decode(type: T.self, decoder: decoder)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

