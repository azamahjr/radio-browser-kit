//
//  Countries.swift
//  RadioBrowserKit
//
//  Created by Azamah Junior Khan on 27/05/2025.
//

import Foundation

public struct Countries: Codable, Hashable {
    public let name: String
    public let iso31661: String
    public let stationCount: Int
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case iso31661 = "iso_3166_1"
        case stationCount
    }
}
