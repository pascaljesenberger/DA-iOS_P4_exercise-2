//
//  UserListGridView.swift
//  UserList
//
//  Created by bertrand jesenberger on 14/12/2024.
//

import SwiftUI

struct UserListGridView: View {
    @ObservedObject var viewModel: UserListViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                ForEach(viewModel.users) { user in
                    UserListDetailView(user: user, viewModel: viewModel, isList: false)
                }
            }
        }
        .navigationTitle("Users")
        .toolbar {
            Toolbar(viewModel: viewModel)
        }
        
    }
}

#Preview {
    UserListGridView(
        viewModel: UserListViewModel(
            repository: UserListRepository()
        )
    )
}
