//
//  Toolbar.swift
//  UserList
//
//  Created by bertrand jesenberger on 14/12/2024.
//

import SwiftUI

struct Toolbar: ToolbarContent {
    
    @ObservedObject var viewModel: UserListViewModel
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Picker(selection: $viewModel.isGridView, label: Text("Display")) {
                Image(systemName: "rectangle.grid.1x2.fill")
                    .tag(true)
                    .accessibilityLabel(Text("Grid view"))
                Image(systemName: "list.bullet")
                    .tag(false)
                    .accessibilityLabel(Text("List view"))
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                Task {
                    await viewModel.reloadUsers()
                }
                
            }) {
                Image(systemName: "arrow.clockwise")
                    .imageScale(.large)
            }
        }
    }
}
