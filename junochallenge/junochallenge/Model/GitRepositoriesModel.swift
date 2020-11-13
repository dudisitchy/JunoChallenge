//
//  GitRepositoriesModel.swift
//  junochallenge
//
//  Created by Eduardo Maia on 12/11/20.
//

import Foundation

typealias Repositories = RepositoriesModel

struct Owner: Codable {
    
    public let login: String?
    public let id: Int?
    public let avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarUrl = "avatar_url"
    }
    
}

struct License: Codable {
    
    public let name: String?
    
}

struct Item: Codable {
    
    public let id: Int?
    public let name: String?
    public let owner: Owner?
    public let htmlUrl: String?
    public let description: String?
    public let created_at: String?
    public var createdAt: String? { return dateToFormat(created_at ?? "") }
    public let updated_at: String?
    public var updatedAt: String? { return dateToFormat(updated_at ?? "") }
    public let language: String?
    public let license: License?
    public let openIssues: Int?
    public let watchers: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case owner
        case htmlUrl = "html_url"
        case description
        case created_at
        case updated_at
        case language
        case license
        case openIssues = "open_issues"
        case watchers
    }
    
    // Format date from API
    func dateToFormat (_ inpDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: inpDate)

        dateFormatter.dateFormat = "dd/MM/yyyy"
        let strDate = dateFormatter.string(from: date!)
        
        return strDate
    }
    
}
    
struct RepositoriesModel: Codable {
    
    public let total_count: Int?
    public let incomplete_results: Bool?
    public let message: String?
    public let items: [Item]?
    
}
