//
//  ObservableObject+Sink.swift
//  IesbSocial
//
//  Created by Pedro Henrique on 02/09/21.
//

import Foundation
import Combine

extension ObservableObject {
    
    internal func sinkError(_ completion: Subscribers.Completion<Error>, loadingFinisher: @escaping () -> Void) {
        switch completion {
            case .failure(let error):
                debugPrint(error)
            default:
                break
        }
        loadingFinisher()
    }
    
}
