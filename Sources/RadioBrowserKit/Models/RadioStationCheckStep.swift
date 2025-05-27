//
//  RadioStationCheckStep.swift
//  RadioBrowserKit
//
//  Created by Azamah Junior Khan on 27/05/2025.
//

/// This struct is used in a tree structure to represent all codepaths that were necessary to check an address of a single stream. Steps can cause multiple other steps for example playlists.
public struct RadioStationCheckStep: Codable, Hashable {
    /// A unique id for this station check step
    public let setUuid: String
    
    /// A unique id for referencing another `RadioStationCheckStep`
    /// It is set if this step has a parent
    public let parentStepUuid: String?
    
    /// A unique id for referencing a station check
    public let checkUuid: String
    
    /// A unique id for referencing a station
    public let stationUuid: String
    
    /// The url that this step of the checking process handled
    public let url: String
    
    /// It represents which kind of url it is.
    /// One of the following: `STREAM`, `REDIRECT`, `PLAYLIST`
    public let urlType: String?
    
    /// The url to the homepage of the stream, so you can direct the user to a page with more information about the stream
    public let error: String?
    
    /// Date and time of step creation
    public let creationIso8601: String
    
    
    enum CodingKeys: String, CodingKey {
        case setUuid = "stepuuid"
        case parentStepUuid = "parent_stepuuid"
        case checkUuid = "checkuuid"
        case stationUuid = "stationuuid"
        case url
        case urlType = "urltype"
        case error
        case creationIso8601 = "creation_iso8601"
    }
}
