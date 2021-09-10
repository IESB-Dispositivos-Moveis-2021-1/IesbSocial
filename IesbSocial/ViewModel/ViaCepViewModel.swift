//
//  CepViewModel.swift
//  IesbSocial
//
//  Created by Pedro Henrique on 09/09/21.
//

import Foundation
import Combine

class ViaCepViewModel: ObservableObject {
    
    private let kBaseURL = "https://viacep.com.br/ws"
    
    
    @Published
    private(set) var loading = false
    
    @Published
    private(set) var address: ViaCep? {
        didSet {
            loading = false
        }
    }
    
    private var cancellationToken: AnyCancellable?
    
    
    func fetchAddress(with zip: String) {
        if let url = URL(string: "\(kBaseURL)/\(zip)/json/") {
            let session = URLSession.shared
            let request = URLRequest(url: url)
            
            loading = true
            
            cancellationToken = session.dataTaskPublisher(for: request)
                .tryMap(session.map(_:))
                .decode(type: ViaCep.self, decoder: JSONDecoder())
                .breakpointOnError()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { self.sinkError($0) { self.loading = false }}) { self.address = $0 }
        }
    }
    
    
    
}
