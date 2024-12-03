//
//  MockAPIManager.swift
//  CVS_FlickerApp
//
//  Created by Varshith Chilamkurthi on 03/12/24.
//

import Foundation
import Combine

class MockAPIManger: NetworkProtocol {
    
    var mockError: Error?
    
    func getData<T: Decodable>(url: String, type: T.Type) -> AnyPublisher<T, Error> {
        let items = [
            Item(title: "Item 1", link: "Link 1", media: Media(m: "https://picsum.photos/200/300"), description: "Description 1", published: "2024-01-01", author: "Author 1"),
            Item(title: "Item 2", link: "Link 2", media: Media(m: "https://picsum.photos/200/300"), description: "Description 2", published: "2024-01-02", author: "Author 2"),
            
        ]
        
        // Encode mock data into JSON Data
        do {
            let data = try JSONEncoder().encode(items)
            
            // If there's an error, return a failed publisher
            if let error = mockError {
                return Fail(error: error).eraseToAnyPublisher()
            }
            
            // Return a publisher with the encoded data
            return Just(data)
                .tryMap { data in
                    // Decode the data into the expected type (T)
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    return decodedData
                }
                .eraseToAnyPublisher()
            
        } catch {
            // If encoding fails, return a failed publisher
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
