//
//  StreamingServer.swift
//  RadioBrowserKit
//
//  Created by Azamah Junior Khan on 27/05/2025.
//

/// This struct is used in a tree structure to represent all codepaths that were necessary to check an address of a single stream. Steps can cause multiple other steps for example playlists.
public struct StreamingServer: Codable, Hashable {
    /// An unique id for this StreamingServer
    public let uuid: String
    
    /// The url that this streaming server
    public let url: String
    
    /// The url for fetching extended meta information from this streaming server
    public let statusUrl: String?
    
    /// If this field exists, the server either does not have extended information or the information was not parsable
    public let error: String?
    
    /// Administrative contact of the streaming server
    public let adminEmail: String
    
    /// Physical location of the streaming server
    public let location: String
    
    /// Server software name and version
    public let software: String
    
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case url
        case statusUrl = "statusurl"
        case error
        case adminEmail = "admin"
        case location
        case software
    }
}
