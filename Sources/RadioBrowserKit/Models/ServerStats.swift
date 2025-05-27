//
//  ServerStats.swift
//  RadioBrowserKit
//
//  Created by Azamah Junior Khan on 28/05/2025.
//

import Foundation

public struct ServerStats: Codable, Hashable {
    public let supportedVersion: Int
    public let softwareVersion: String
    public let status: String
    public let stations: Int
    public let stationBroken: Int
    public let tags: Int
    public let clickLastHour: Int
    public let clickLastDay: Int
    public let languages: Int
    public let countries: Int
    
    enum CodingKeys: String, CodingKey {
        case supportedVersion = "supported_version"
        case softwareVersion = "software_version"
        case status
        case stations
        case stationBroken = "station_broken"
        case tags
        case clickLastHour = "click_last_hour"
        case clickLastDay = "click_last_day"
        case languages
        case countries
    }
}
