//
//  Helper.swift
//  CVS_FlickerApp
//
//  Created by Varshith Chilamkurthi on 03/12/24.
//

import Foundation

class Helper {
    static let shared = Helper()
    private init(){}
        
    func cleanName(title: String) -> String {
        let cleanedString = title.replacingOccurrences(of: "nobody@flickr.com (\"", with: "")
            .replacingOccurrences(of: "\")", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .capitalized
        return cleanedString
    }
    
    func formattedDate(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formatter.date(from: dateString) {
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        return "N/A"
    }
    
    func extractImageDimensions(from html: String?) -> String? {
        guard let html = html else { return nil }
        
        // Regex pattern to extract width and height from the image tag
        let pattern = "<img[^>]*width=\"(\\d+)\"[^>]*height=\"(\\d+)\""
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return nil }
        let nsString = html as NSString
        let results = regex.matches(in: html, options: [], range: NSRange(location: 0, length: nsString.length))
        
        if let match = results.first {
            let width = nsString.substring(with: match.range(at: 1))
            let height = nsString.substring(with: match.range(at: 2))
            return "Width: \(width) px, Height: \(height) px"
        }
        
        return nil
    }
    
    // Clean the description by stripping HTML tags
    func cleanDescription(from html: String?) -> String {
        guard let html = html else { return "No description available." }
        
        // Regex to remove HTML tags
        let regex = try? NSRegularExpression(pattern: "<.*?>", options: [])
        let range = NSRange(location: 0, length: html.utf16.count)
        let cleanText = regex?.stringByReplacingMatches(in: html, options: [], range: range, withTemplate: "")
        
        // Return the cleaned description, fall back to a default message if empty
        return cleanText?.isEmpty ?? true ? "No description available." : cleanText!
    }
}

