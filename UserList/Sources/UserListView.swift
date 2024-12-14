import SwiftUI

struct UserListView: View {
    
    @ObservedObject var viewModel: UserListViewModel
    
    var body: some View {
        NavigationView {
            if !viewModel.isGridView {
                UserListListView(viewModel: viewModel)
            } else {
                UserListGridView(viewModel: viewModel)
            }
        }
        .task {
            await viewModel.fetchUsers()
        }
    }
    
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView(
            viewModel: UserListViewModel(
                repository: UserListRepository()
            )
        )
    }
}
