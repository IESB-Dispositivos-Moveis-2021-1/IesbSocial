//
//  Cep.swift
//  IesbSocial
//
//  Created by Pedro Henrique on 09/09/21.
//

import Foundation

// MARK: - ViaCep
struct ViaCep: Codable {
    let cep, logradouro, complemento, bairro: String
    let localidade, uf, ibge, gia: String
    let ddd, siafi: String
}
