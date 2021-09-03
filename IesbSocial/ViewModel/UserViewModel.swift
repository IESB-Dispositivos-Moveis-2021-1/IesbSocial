//
//  UserViewModel.swift
//  IesbSocial
//
//  Created by Pedro Henrique on 02/09/21.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    
    private let kBaseURL = "https://jsonplaceholder.typicode.com"
    
    
    @Published
    private(set) var loading = false
    
    @Published
    private(set) var users = [User]() {
        didSet {
            loading = false
        }
    }
    
    private var userCancellationToken: AnyCancellable?
    
    
    func newFetchUsers() {
        if let url = URL(string: "\(kBaseURL)/users") {
            let session = URLSession.shared
            let request = URLRequest(url: url)
            
            loading = true
            
            userCancellationToken = session.dataTaskPublisher(for: request)
                .tryMap(session.map(_:))
                .decode(type: [User].self, decoder: JSONDecoder())
                .breakpointOnError()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: sinkError(_:)) { self.users = $0 }

            
            
        }
    }
    
    private func sinkError(_ completion: Subscribers.Completion<Error>) {
        switch completion {
            case .failure(let error):
                loading = false
                debugPrint(error)
            default:
                break
        }
    }
    
    func fetchUsers() {
        // GCD = Grand Central Dispatch
        
        let session = URLSession.shared
        
        if let url = URL(string: "\(kBaseURL)/users") {
            session.dataTask(with: url) { (data, response, error) in
                if let resp = response as? HTTPURLResponse,
                   resp.statusCode >= 200, resp.statusCode < 300,
                   let json = data {
                    DispatchQueue.main.async {
                        self.users = try! JSONDecoder().decode([User].self, from: json)
                    }
                }
            }.resume()
        }
        
    }
    
    
}
