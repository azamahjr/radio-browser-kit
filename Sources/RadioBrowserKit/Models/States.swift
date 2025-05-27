//
//  States.swift
//  RadioBrowserKit
//
//  Created by Azamah Junior Khan on 27/05/2025.
//

import Foundation

public struct States: Codable, Hashable {
    public let name: String
    public let country: String
    public let stationCount: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case country
        case stationCount = "stationcount"
    }
}
