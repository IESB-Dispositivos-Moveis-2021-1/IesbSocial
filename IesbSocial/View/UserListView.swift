//
//  UserListView.swift
//  IesbSocial
//
//  Created by Pedro Henrique on 02/09/21.
//

import SwiftUI

struct UserListView: View {
    
    @ObservedObject
    var viewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.loading {
                    loading()
                }else {
                    List {
                        ForEach(viewModel.users) { user in
                            NavigationLink(destination: PostListView()) {
                                VStack(alignment: .leading) {
                                    Text(user.name).font(.title2)
                                    Text(user.email).font(.subheadline)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Usuários")
            .environmentObject(PostViewModel())

        }
        .onAppear {
            viewModel.newFetchUsers()
            
        }
    }
    
    @ViewBuilder
    private func loading() -> some View {
        VStack {
            ProgressView()
            Text("Aguarde... carregando...")
        }
    }
}
