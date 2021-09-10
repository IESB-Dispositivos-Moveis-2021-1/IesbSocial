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
    
    @StateObject
    var postViewModel = PostViewModel()
    
    
    @State
    private var showNewUserForm = false
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.loading {
                    LoadingView()
                }else {
                    List {
                        ForEach(viewModel.users) { user in
                            NavigationLink(destination: PostListView(user: user)) {
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
            .navigationBarItems(
                trailing: Button("\(Image(systemName: "plus"))") {
                    showNewUserForm.toggle()
                }.font(Font.title.weight(.light))
            )
        }
        .environmentObject(postViewModel)
        .onAppear {
            viewModel.fetchUsers()
        }
        .sheet(isPresented: $showNewUserForm) {
            NewUserView(viaCepViewModel: ViaCepViewModel())
                .environmentObject(viewModel)
        }
    }
    
}
