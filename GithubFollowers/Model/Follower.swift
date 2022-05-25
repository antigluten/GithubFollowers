//
//  Follower.swift
//  GithubFollowers
//
//  Created by Vladimir Gusev on 16.05.2022.
//

import Foundation

struct Follower: Codable, Hashable {
    let login: String
    let avatarUrl: String
}
