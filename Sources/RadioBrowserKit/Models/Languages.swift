//
//  Languages.swift
//  RadioBrowserKit
//
//  Created by Azamah Junior Khan on 27/05/2025.
//

import Foundation

public struct Languages: Codable, Hashable {
    public let name: String
    public let iso639: String?
    public let stationCount: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case iso639 = "iso_639"
        case stationCount = "stationcount"
    }
}
