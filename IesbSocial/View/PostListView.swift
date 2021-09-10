//
//  PostListView.swift
//  IesbSocial
//
//  Created by Pedro Henrique on 02/09/21.
//

import SwiftUI

struct PostListView: View {
    
    @EnvironmentObject
    var viewModel: PostViewModel
    
    var user: User
    
    var body: some View {
        VStack {
            if viewModel.loading {
                LoadingView()
            }else {
                List {
                    ForEach(viewModel.posts) { post in
                        VStack(alignment: .leading) {
                            Text(post.title).font(.title)
                            Text(post.body).font(.body)
                        }
                    }
                }
            }
        }
        .navigationTitle(user.name)
        .onAppear {
            viewModel.fetchPosts(for: user)
        }
    }
}

