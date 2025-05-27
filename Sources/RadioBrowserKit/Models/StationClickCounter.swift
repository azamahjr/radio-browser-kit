//
//  StationClickCounter.swift
//  RadioBrowserKit
//
//  Created by Azamah Junior Khan on 28/05/2025.
//

import Foundation

public struct StationClickCounter: Codable, Hashable {
    public let ok: Bool
    public let message: String
    public let stationUuid: String
    public let url: String
    
    enum CodingKeys: String, CodingKey {
        case ok
        case message = "message"
        case stationUuid = "stationuuid"
        case url
    }
}
