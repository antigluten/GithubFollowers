//
//  User.swift
//  GithubFollowers
//
//  Created by Vladimir Gusev on 16.05.2022.
//

import Foundation

struct User: Codable {
    var login: String
    var id: String
    var name: String?
    var location: String?
    var bio: String?
    var publicRepos: Int
    var publicGists: Int
    var htmlUrl: String
    var following: Int
    var followers: Int
    var createdAt: String
}
