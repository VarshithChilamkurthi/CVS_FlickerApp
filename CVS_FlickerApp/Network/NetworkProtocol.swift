//
//  NetworkProtocol.swift
//  CVS_FlickerApp
//
//  Created by Varshith Chilamkurthi on 03/12/24.
//

import Foundation
import Combine

protocol NetworkProtocol {
    func getData<T: Decodable>(url: String, type: T.Type) -> AnyPublisher<T, Error>
}
