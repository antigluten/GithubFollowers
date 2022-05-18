//
//  Follower.swift
//  GithubFollowers
//
//  Created by Vladimir Gusev on 16.05.2022.
//

import Foundation

struct Follower: Codable, Hashable {
    var login: String
    var avatarUrl: String
}
