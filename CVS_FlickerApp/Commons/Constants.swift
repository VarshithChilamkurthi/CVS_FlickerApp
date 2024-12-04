//
//  Commons.swift
//  CVS_FlickerApp
//
//  Created by Varshith Chilamkurthi on 03/12/24.
//

import Foundation

enum Constants {
    enum API: String {
        case baseURL = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=porcupine"
        case emptyBaseURL = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags="
    }
}
enum UIStrings: String {
    case failedToLoadImage = "Failed to load image. Tap to retry."
    case titleNotAvailable = "Title not available."
    case descriptionNotAvailable = "Description not available."
    case notApplicable = "N/A"
    case flickrSearchTitle = "Flickr Search"
    case searchImagesPlaceholder = "Search images..."
    case fetchSuccessTag = "Finished fetching images for tag"
    case fetchFail = "Error fetching images..."
}
