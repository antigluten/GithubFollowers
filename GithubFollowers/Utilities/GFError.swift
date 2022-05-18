//
//  ErrorMessage.swift
//  GithubFollowers
//
//  Created by Vladimir Gusev on 17.05.2022.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername = "This username created invalid request."
    case unableToComplete = "Unable to complete your request."
    case invalidResponse = "Invalid response from server"
    case invalidData = "The data received from server was invalid"
    
    case invalidUrl = "The url received was invalid"
}
