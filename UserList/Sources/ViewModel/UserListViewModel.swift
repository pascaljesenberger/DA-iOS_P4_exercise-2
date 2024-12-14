//
//  UserListViewModel.swift
//  UserList
//
//  Created by bertrand jesenberger on 14/12/2024.
//

import Foundation

final class UserListViewModel: ObservableObject {
    
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var isGridView = false
    
    private let repository: UserListRepository
    private var quantity: Int
    
    init(repository: UserListRepository) {
        self.repository = repository
        self.quantity = 20
    }
    
    init(repository: UserListRepository, quantity: Int) {
        self.repository = repository
        self.quantity = quantity
    }

    @MainActor
    func fetchUsers() async {
        isLoading = true
           
        do {
            let users = try await repository.fetchUsers(quantity: quantity)
            
            self.users.append(contentsOf: users)
            isLoading = false
        } catch {
            print("Error fetching users: \(error.localizedDescription)")
        }
       
    }

    
    func shouldLoadMoreData(currentItem item: User) -> Bool {
        guard let lastItem = users.last else { return false }
        return !isLoading && item.id == lastItem.id
    }

    @MainActor
    func reloadUsers() async {
        users.removeAll()
        await fetchUsers()
    }
    
    func fetchUsersIfMoreData(currentItem item: User) async {
        if shouldLoadMoreData(currentItem: item) {
            await fetchUsers()
        }
    }
    
}

