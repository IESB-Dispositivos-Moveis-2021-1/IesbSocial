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
    private var createUserCancellationToken: AnyCancellable?
    
    
    func fetchUsers() {
        userCancellationToken?.cancel()
        if let url = URL(string: "\(kBaseURL)/users") {
            let session = URLSession.shared
            let request = URLRequest(url: url)
            
            loading = true
            
            userCancellationToken = session.dataTaskPublisher(for: request)
                .tryMap(session.map(_:))
                .decode(type: [User].self, decoder: JSONDecoder())
                .breakpointOnError()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { self.sinkError($0) { self.loading = false }}) { self.users = $0 }
        }
    }
    
    func save(_ user: User) {
        if let url = URL(string: "\(kBaseURL)/users") {
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = try! JSONEncoder().encode(user)
            
            loading = true
            
            let task = session.uploadTask(with: request, from: body) { [unowned self] data, response, error in
                DispatchQueue.main.async { [unowned self] in
                    self.loading = false
                }
            }
            task.resume()
        }
    }
    
}
