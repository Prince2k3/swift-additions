//
//  SwiftyUserDefaults+Extension.swift
//
//  Created by Prince Ugwuh on 12/12/18.
//

import Foundation
import SwiftyUserDefaults

extension UserDefaults {
    subscript<T: Codable>(key: DefaultsKey<T?>) -> T? {
        get {
            guard
                let data = data(forKey: key._key)
                else { return nil }
            do {
                let decoder = JSONDecoder()
                //                decoder.dateDecodingStrategy = .iso8601
                return try decoder.decode(T.self, from: data)
            } catch { return nil }
        }
        set {
            do {
                let encoder = JSONEncoder()
                let value = try encoder.encode(newValue)
                set(key, value)
            } catch { set(key, nil) }
        }
    }
}
