//
//  Post.swift
//  IesbSocial
//
//  Created by Pedro Henrique on 02/09/21.
//

import Foundation

// MARK: - Post
struct Post: Codable, Identifiable {
    let userId, id: Int
    let title, body: String
}
