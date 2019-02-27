//
//  URLRequest+Test.swift
//  SwiftAdditions
//
//  Created by Prince Ugwuh on 2/27/19.
//

import Foundation

extension URLRequest {
    var jsonBody: [String: Any] {
        guard let httpBodyStream = self.httpBodyStream else { return [:] }
        do { return try JSONSerialization.jsonObject(with: Data(reading: httpBodyStream), options: []) as? [String: Any] ?? [:] }
        catch { return [:] }
    }
    
    var urlComponents: URLComponents? {
        guard let url = self.url else { return nil }
        return URLComponents(url: url, resolvingAgainstBaseURL: false)
    }
}
