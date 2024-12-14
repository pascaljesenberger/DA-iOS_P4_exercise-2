//
//  UserListDetailView.swift
//  UserList
//
//  Created by bertrand jesenberger on 14/12/2024.
//

import SwiftUI

struct UserListDetailView: View {
    
    var user: User
    @StateObject var viewModel: UserListViewModel
    var isList: Bool
    
    var body: some View {
        NavigationLink(destination: UserDetailView(user: user)) {
            if (isList) {
                HStack {
                    userView(user: user, viewModel: viewModel, isList: isList)
                }.onAppear {
                    Task {
                        await viewModel.fetchUsersIfMoreData(currentItem: user)
                    }
                }
            } else {
                VStack {
                    userView(user: user, viewModel: viewModel, isList: isList)
                }.onAppear {
                    Task {
                        await viewModel.fetchUsersIfMoreData(currentItem: user)
                    }
                }
            }
            
            
        }
    }
}
