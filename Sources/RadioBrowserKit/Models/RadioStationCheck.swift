//
//  RadioStationCheck.swift
//  RadioBrowserKit
//
//  Created by Azamah Junior Khan on 27/05/2025.
//


import Foundation

/// This struct is used in a represent an online check of a stream. Most of the information got extracted by checking the http headers of the stream
struct RadioStationCheck: Codable, Hashable {
    /// An unique id for this StationCheck
    let stationUuid: String
    
    /// An unique id for referencing a Station
    let checkUuid: String
    
    /// DNS Name of the server that did the stream check.
    let source: String
    
    /// High level name of the used codec of the stream. May have the format AUDIO or AUDIO/VIDEO.
    let codec: String
    
    /// Bitrate 1000 bits per second (kBit/s) of the stream. (Audio + Video)
    let bitrate: Int
    
    /// 1 means this is an HLS stream, otherwise 0.
    let hls: Int
    
    /// 1 means this stream is reachable, otherwise 0.
    let ok: Int
    
    /// Date and time of check creation
    /// Possible value/data types: datetime, YYYY-MM-DD HH:mm:ss
    let timestamp: String
    
    /// Date and time of check creation
    let timestampIso8601: String
    
    /// Direct stream url that has been resolved from the main stream url. HTTP redirects and playlists have been decoded. If hls==1 then this is still a HLS-playlist.
    let urlCache: String
    
    /// 1 means this stream has provided extended information and it should be used to override the local database, otherwise 0.
    let metaInfoOverridesDatabase: Int
    
    /// 1 that this stream appears in the public shoutcast/icecast directory, otherwise 0.
    let isPublic: String?
    
    /// The name extracted from the stream header.
    let name: String?

    /// The description extracted from the stream header.
    let description: String?
    
    /// Comma separated list of tags. (genres of this stream)
    let tags: String?
    
    /// Official country codes as in ISO 3166-1 alpha-2
    let countryCode: String?
    
    /// Official country subdivision codes as in ISO 3166-2
    let countrySubdivisionCode: String?
    
    /// The homepage extracted from the stream header.
    let homepage: String?
    
    /// The favicon extracted from the stream header.
    let favicon: String?
    
    /// The load balancer extracted from the stream header.
    let loadBalancer: String?
    
    /// The name of the server software used.
    let serverSoftware: String?
    
    /// Audio sampling frequency in Hz
    let sampling: Int?
    
    /// Timespan in milliseconds this check needed to be finished.
    let timingMs: Int
    
    /// The description extracted from the stream header
    let languageCodes: String?
    
    /// 1 means that a ssl error occurred while connecting to the stream, 0 otherwise.
    let sslError: Int
    
    /// Latitude on earth where the stream is located.
    let geoLatitude: Double?
    
    /// Longitude on earth where the stream is located.
    let geoLongitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case stationUuid = "stationuuid"
        case checkUuid = "checkuuid"
        case source
        case codec
        case bitrate
        case hls
        case ok
        case timestamp
        case timestampIso8601 = "timestamp_iso8601"
        case urlCache = "urlcache"
        case metaInfoOverridesDatabase = "metainfo_overrides_database"
        case isPublic = "public"
        case name
        case description
        case tags
        case countryCode = "countrycode"
        case countrySubdivisionCode = "countrysubdivisioncode"
        case homepage
        case favicon
        case loadBalancer = "loadbalancer"
        case serverSoftware = "server_software"
        case sampling
        case timingMs = "timing_ms"
        case languageCodes = "languagecodes"
        case sslError = "ssl_error"
        case geoLatitude = "geo_lat"
        case geoLongitude = "geo_long"
    }
}

// MARK: - Convenience Extensions
extension RadioStationCheck {
    /// Returns true if the station check was successful
    var isSuccessful: Bool {
        return ok == 1
    }
    
    /// Returns true if the station supports HLS streaming
    var supportsHLS: Bool {
        return hls == 1
    }
    
    /// Returns true if there was an SSL error
    var hasSSLError: Bool {
        return sslError != 0
    }
    
    /// Returns true if metadata overrides the database
    var metadataOverridesDatabase: Bool {
        return metaInfoOverridesDatabase == 1
    }
    
    /// Returns tags as an array of strings (if available)
    var tagsArray: [String] {
        guard let tags = tags, !tags.isEmpty else { return [] }
        return tags.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
    }
    
    /// Returns language codes as an array of strings (if available)
    var languageCodesArray: [String] {
        guard let codes = languageCodes, !codes.isEmpty else { return [] }
        return codes.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
    }
    
    /// Returns the sampling rate in a human-readable format
    var samplingRateDescription: String {
        guard let sampling = sampling else { return "Unknown" }
        return "\(sampling) Hz"
    }
    
    /// Returns the timing in seconds
    var timingInSeconds: Double {
        return Double(timingMs) / 1000.0
    }
    
    /// Returns the check timestamp as a Date object
    var checkDate: Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: timestampIso8601)
    }
    
    /// Returns a summary of the audio quality
    var audioQualitySummary: String {
        return "\(codec) \(bitrate)kbps @ \(samplingRateDescription)"
    }
}

// MARK: - Check Status Enum
extension RadioStationCheck {
    enum CheckStatus {
        case success
        case failure
        case sslError
        case timeout
        
        var description: String {
            switch self {
            case .success:
                return "Station is working properly"
            case .failure:
                return "Station check failed"
            case .sslError:
                return "SSL/TLS error occurred"
            case .timeout:
                return "Connection timed out"
            }
        }
    }
    
    /// Returns the overall status of this check
    var status: CheckStatus {
        if hasSSLError {
            return .sslError
        } else if isSuccessful {
            return .success
        } else if timingMs > 10000 { // Arbitrary timeout threshold
            return .timeout
        } else {
            return .failure
        }
    }
}
