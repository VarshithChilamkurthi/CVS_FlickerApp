//
//  APIManager.swift
//  CVS_FlickerApp
//
//  Created by Varshith Chilamkurthi on 03/12/24.
//

import Foundation
import Combine

class APIManger: NetworkProtocol {
    static let shared = APIManger()
    private init() {}
    
    func getData<T: Decodable>(url: String, type: T.Type) -> AnyPublisher<T, Error> {
        guard let url = URL(string: url) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result in
                return result.data
            }
            .decode(type: type, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
