//
//  URLSession+Map.swift
//  IesbSocial
//
//  Created by Pedro Henrique on 02/09/21.
//

import Foundation

extension URLSession {
    
    func map(_ entity: (Data, URLResponse)) throws -> Data {
        let (data, response) = entity
        guard let resp = response as? HTTPURLResponse,
              resp.statusCode >= 200,
              resp.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return data
    }
    
}
