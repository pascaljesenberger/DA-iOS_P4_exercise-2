//
//  UserListRepositoryProtocol.swift
//  UserListTests
//
//  Created by bertrand jesenberger on 14/12/2024.
//

import Foundation

protocol UserListRepositoryProtocol {
    func fetchUsers(quantity: Int) async throws -> [User]
}

extension UserListRepository: UserListRepositoryProtocol {}

final class UserListViewModel: ObservableObject {
    
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var isGridView = false
    
    private let repository: UserListRepositoryProtocol
    
    init(repository: UserListRepositoryProtocol = UserListRepository()) {
        self.repository = repository
    }
    
    func fetchUsers() {
        isLoading = true
        Task {
            do {
                let users = try await repository.fetchUsers(quantity: 20)
                await MainActor.run {
                    self.users.append(contentsOf: users)
                    self.isLoading = false
                }
            } catch {
                print("Error fetching users: \(error.localizedDescription)")
                await MainActor.run {
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

