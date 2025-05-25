//
//  LookUpServers.swift
//  RadioBrowserKit
//
//  Created by Azamah Junior Khan on 25/05/2025.
//


import Foundation
import Network

// MARK: - SRV Record Model
struct SRVRecord {
    let name: String
    let port: UInt16
    let priority: UInt16
    let weight: UInt16
}

// MARK: - Radio Browser API
public class LookUpRadioBrowserServers {
    
    // MARK: - Main Function
    /**
     * Get a list of base URLs of all available radio-browser servers
     * Returns: Array of strings - base URLs of radio-browser servers
     */
    static func getRadioBrowserBaseURLs() async throws -> [String] {
        let srvRecords = try await resolveSRV(hostname: "_api._tcp.radio-browser.info")
        
        // Sort records (by priority, then by weight)
        let sortedRecords = srvRecords.sorted { lhs, rhs in
            if lhs.priority != rhs.priority {
                return lhs.priority < rhs.priority
            }
            return lhs.weight < rhs.weight
        }
        
        // Convert to HTTPS URLs
        return sortedRecords.map { record in
            "https://\(record.name)"
        }
    }
    
    // MARK: - DNS-over-HTTPS Implementation
    private static func resolveSRV(hostname: String) async throws -> [SRVRecord] {
        // Using Cloudflare's DNS-over-HTTPS service
        let urlString = "https://1.1.1.1/dns-query?name=\(hostname)&type=SRV"
        guard let url = URL(string: urlString) else {
            throw RadioBrowserError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/dns-json", forHTTPHeaderField: "Accept")
        request.setValue("application/dns-json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw RadioBrowserError.networkError
        }
        
        return try parseDNSResponse(data)
    }
    
    // MARK: - DNS Response Parser
    private static func parseDNSResponse(_ data: Data) throws -> [SRVRecord] {
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let answers = json["Answer"] as? [[String: Any]] else {
            throw RadioBrowserError.invalidDNSResponse
        }
        
        var srvRecords: [SRVRecord] = []
        
        for answer in answers {
            guard let type = answer["type"] as? Int,
                  type == 33, // SRV record type
                  let data = answer["data"] as? String else {
                continue
            }
            
            if let record = parseSRVData(data) {
                srvRecords.append(record)
            }
        }
        
        return srvRecords
    }
    
    // MARK: - SRV Data Parser
    private static func parseSRVData(_ data: String) -> SRVRecord? {
        // SRV data format: "priority weight port target"
        let components = data.split(separator: " ")
        guard components.count == 4,
              let priority = UInt16(components[0]),
              let weight = UInt16(components[1]),
              let port = UInt16(components[2]) else {
            return nil
        }
        
        let target = String(components[3])
        let name = target.hasSuffix(".") ? String(target.dropLast()) : target
        
        return SRVRecord(name: name, port: port, priority: priority, weight: weight)
    }
}


// MARK: - Error Types
enum RadioBrowserError: Error, LocalizedError {
    case invalidURL
    case networkError
    case invalidDNSResponse
    case noServersFound
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL for DNS query"
        case .networkError:
            return "Network error occurred during DNS resolution"
        case .invalidDNSResponse:
            return "Invalid DNS response format"
        case .noServersFound:
            return "No Radio Browser servers found"
        }
    }
}

 class RadioBrowserClient {
    private var baseURLs: [String] = []
    
    func initialize() async throws {
        self.baseURLs = try await LookUpRadioBrowserServers.getRadioBrowserBaseURLs()
        print("Discovered Radio Browser servers: \(baseURLs)")
    }
    
    func getRandomServerURL() -> String? {
        guard !baseURLs.isEmpty else { return nil }
        return baseURLs.randomElement()
    }
    
    func searchStations(query: String) async throws -> Data {
        guard let baseURL = getRandomServerURL() else {
            throw RadioBrowserError.noServersFound
        }
        
        let searchURL = "\(baseURL)/json/stations/search?name=\(query)"
        guard let url = URL(string: searchURL) else {
            throw RadioBrowserError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}

