//
//  StationClick.swift
//  RadioBrowserKit
//
//  Created by Azamah Junior Khan on 28/05/2025.
//

import Foundation

public struct StationClick: Codable, Hashable {
    public let stationUuid: String
    public let clickUuid: String
    public let clickTimestampIso8601: String
    public let clickTimestamp: String
    
    enum CodingKeys: String, CodingKey {
        case stationUuid = "stationuuid"
        case clickUuid = "clickuuid"
        case clickTimestampIso8601 = "clicktimestamp_iso8601"
        case clickTimestamp = "clicktimestamp"
    }
}
