//
//  LoadingView.swift
//  IesbSocial
//
//  Created by Pedro Henrique on 02/09/21.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
            Text("Aguarde... carregando...")
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
