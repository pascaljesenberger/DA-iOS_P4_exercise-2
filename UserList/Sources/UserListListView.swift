//
//  UserListListView.swift
//  UserList
//
//  Created by bertrand jesenberger on 14/12/2024.
//

import SwiftUI

struct UserListListView: View {
    @ObservedObject var viewModel: UserListViewModel
    
    var body: some View {
        List(viewModel.users) { user in
            UserListDetailView(user: user, viewModel: viewModel, isList: true)
        }
        .navigationTitle("Users")
        .toolbar {
            Toolbar(viewModel: viewModel)
        }
    }
}

#Preview {
    UserListListView(
        viewModel: UserListViewModel(
            repository: UserListRepository()
        )
    )
}
