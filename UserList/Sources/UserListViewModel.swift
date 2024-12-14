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
    
     let repository = UserListRepository()
    
    func fetchUsers() {
        isLoading = true
        Task {
            do {
                let users = try await repository.fetchUsers(quantity: 20)
                // Utilisez MainActor.run pour garantir que les mises à jour se font sur le thread principal
                await MainActor.run {
                    self.users.append(contentsOf: users)
                    self.isLoading = false
                }
            } catch {
                // Même chose pour la gestion des erreurs
                await MainActor.run {
                    print("Error fetching users: \(error.localizedDescription)")
                    self.isLoading = false
                }
            }
        }
    }
    
    func shouldLoadMoreData(currentItem item: User) -> Bool {
        guard let lastItem = users.last else { return false }
        return !isLoading && item.id == lastItem.id
    }
    
    func reloadUsers() {
        users.removeAll()
        fetchUsers()
    }
}
