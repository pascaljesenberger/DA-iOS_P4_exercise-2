// UserListViewModelTests.swift
// UserListTests
//
// Created by bertrand jesenberger on 14/12/2024.
//

import XCTest
@testable import UserList

final class UserListViewModelTests: XCTestCase {
    
    func testFetchUsersModeleView() async  {
        // Given
        let quantity = 2
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let viewModel =  UserListViewModel(repository: repository, quantity: quantity)
        
        
        // When
        await viewModel.fetchUsers()
        
        // Then
        XCTAssertEqual(viewModel.users.count, quantity)
        XCTAssertEqual(viewModel.users[0].name.first, "John")
        XCTAssertEqual(viewModel.users[0].name.last, "Doe")
        XCTAssertEqual(viewModel.users[0].dob.age, 31)
        XCTAssertEqual(viewModel.users[0].picture.large, "https://example.com/large.jpg")
        
        XCTAssertEqual(viewModel.users[1].name.first, "Jane")
        XCTAssertEqual(viewModel.users[1].name.last, "Smith")
        XCTAssertEqual(viewModel.users[1].dob.age, 26)
        XCTAssertEqual(viewModel.users[1].picture.medium, "https://example.com/medium.jpg")
    }
    
    func testFetchUsersInvalidResponse() async throws{
        // Given
        let invalidJSONData = "invalid JSON".data(using: .utf8)!
        let invalidJSONResponse = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        let mockExecuteDataRequest: (URLRequest) async throws -> (Data, URLResponse) = { _ in
            return (invalidJSONData, invalidJSONResponse)
        }
        
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let viewModel =  UserListViewModel(repository: repository)
        
        // When
        await viewModel.fetchUsers()
        
        XCTAssert(viewModel.users.isEmpty)
        
    }
    
    func testshouldLoadMoreData() async  {
        // Given
        let quantity = 2
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let viewModel =  UserListViewModel(repository: repository, quantity: quantity)
        
        
        // When
        await viewModel.fetchUsers()
        
        if let currentItem = viewModel.users.last  {
            
            if viewModel.shouldLoadMoreData(currentItem: currentItem)
            {
                await viewModel.fetchUsers()
            }
            
            // Then
            XCTAssertEqual(viewModel.users.count, 4)
            XCTAssertEqual(viewModel.users[0].name.first, "John")
            XCTAssertEqual(viewModel.users[0].name.last, "Doe")
            XCTAssertEqual(viewModel.users[0].dob.age, 31)
            XCTAssertEqual(viewModel.users[0].picture.large, "https://example.com/large.jpg")
            
            XCTAssertEqual(viewModel.users[1].name.first, "Jane")
            XCTAssertEqual(viewModel.users[1].name.last, "Smith")
            XCTAssertEqual(viewModel.users[1].dob.age, 26)
            XCTAssertEqual(viewModel.users[1].picture.medium, "https://example.com/medium.jpg")
            
            XCTAssertEqual(viewModel.users[2].name.first, "John")
            XCTAssertEqual(viewModel.users[2].name.last, "Doe")
            XCTAssertEqual(viewModel.users[2].dob.age, 31)
            XCTAssertEqual(viewModel.users[2].picture.large, "https://example.com/large.jpg")
            
            XCTAssertEqual(viewModel.users[3].name.first, "Jane")
            XCTAssertEqual(viewModel.users[3].name.last, "Smith")
            XCTAssertEqual(viewModel.users[3].dob.age, 26)
            XCTAssertEqual(viewModel.users[3].picture.medium, "https://example.com/medium.jpg")
        }
    }
    
    func testShouldLoadMoreDataNo() async  {
        // Given
        let quantity = 2
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let viewModel =  UserListViewModel(repository: repository, quantity: quantity)
        
        // When
        await viewModel.fetchUsers()
        if let currentItem = viewModel.users.first  {
            
            if viewModel.shouldLoadMoreData(currentItem: currentItem)
            {
                await viewModel.fetchUsers()
            }
            
            // Then
            XCTAssertEqual(viewModel.users.count,2)
            XCTAssertEqual(viewModel.users[0].name.first, "John")
            XCTAssertEqual(viewModel.users[0].name.last, "Doe")
            XCTAssertEqual(viewModel.users[0].dob.age, 31)
            XCTAssertEqual(viewModel.users[0].picture.large, "https://example.com/large.jpg")
            
            XCTAssertEqual(viewModel.users[1].name.first, "Jane")
            XCTAssertEqual(viewModel.users[1].name.last, "Smith")
            XCTAssertEqual(viewModel.users[1].dob.age, 26)
            XCTAssertEqual(viewModel.users[1].picture.medium, "https://example.com/medium.jpg")
            
        }
    }
    
    func testShouldLoadMoreDataError() async  {
        // Given
        let quantity = 2
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let viewModel =  UserListViewModel(repository: repository, quantity: quantity)
        
        // When
        await viewModel.fetchUsers()
        if let currentItem = viewModel.users.last
        {
            viewModel.users.removeAll()
            XCTAssert(!viewModel.shouldLoadMoreData(currentItem: currentItem))
            
        }
        
    }
    
    func testReloadUsers() async  {
        // Given
        let quantity = 2
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let viewModel =  UserListViewModel(repository: repository, quantity: quantity)
        
        // When
        await viewModel.fetchUsers()
        await viewModel.fetchUsers()
        await viewModel.reloadUsers()
        
        // Then
        XCTAssertEqual(viewModel.users.count,2)
        XCTAssertEqual(viewModel.users[0].name.first, "John")
        XCTAssertEqual(viewModel.users[0].name.last, "Doe")
        XCTAssertEqual(viewModel.users[0].dob.age, 31)
        XCTAssertEqual(viewModel.users[0].picture.large, "https://example.com/large.jpg")
        
        XCTAssertEqual(viewModel.users[1].name.first, "Jane")
        XCTAssertEqual(viewModel.users[1].name.last, "Smith")
        XCTAssertEqual(viewModel.users[1].dob.age, 26)
        XCTAssertEqual(viewModel.users[1].picture.medium, "https://example.com/medium.jpg")
        
    }
    
    func testFetchUsersIfMoreData() async {
        // Given
        let quantity = 2
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let viewModel =  UserListViewModel(repository: repository, quantity: quantity)
        
        // When
        await viewModel.fetchUsers()
        if let currentItem = viewModel.users.last  {
            
            await viewModel.fetchUsersIfMoreData(currentItem: currentItem)
            
            // Then
            XCTAssertEqual(viewModel.users.count, 4)
            XCTAssertEqual(viewModel.users[0].name.first, "John")
            XCTAssertEqual(viewModel.users[0].name.last, "Doe")
            XCTAssertEqual(viewModel.users[0].dob.age, 31)
            XCTAssertEqual(viewModel.users[0].picture.large, "https://example.com/large.jpg")
            
            XCTAssertEqual(viewModel.users[1].name.first, "Jane")
            XCTAssertEqual(viewModel.users[1].name.last, "Smith")
            XCTAssertEqual(viewModel.users[1].dob.age, 26)
            XCTAssertEqual(viewModel.users[1].picture.medium, "https://example.com/medium.jpg")
            
            XCTAssertEqual(viewModel.users[2].name.first, "John")
            XCTAssertEqual(viewModel.users[2].name.last, "Doe")
            XCTAssertEqual(viewModel.users[2].dob.age, 31)
            XCTAssertEqual(viewModel.users[2].picture.large, "https://example.com/large.jpg")
            
            XCTAssertEqual(viewModel.users[3].name.first, "Jane")
            XCTAssertEqual(viewModel.users[3].name.last, "Smith")
            XCTAssertEqual(viewModel.users[3].dob.age, 26)
            XCTAssertEqual(viewModel.users[3].picture.medium, "https://example.com/medium.jpg")
        }
        
    }
    
    func testFetchUsersIfMoreDataNo() async {
        // Given
        let quantity = 2
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let viewModel =  UserListViewModel(repository: repository, quantity: quantity)
        
        // When
        await viewModel.fetchUsers()
        if let currentItem = viewModel.users.first  {
            
            await viewModel.fetchUsersIfMoreData(currentItem: currentItem)
            
            // Then
            XCTAssertEqual(viewModel.users.count, 2)
            XCTAssertEqual(viewModel.users[0].name.first, "John")
            XCTAssertEqual(viewModel.users[0].name.last, "Doe")
            XCTAssertEqual(viewModel.users[0].dob.age, 31)
            XCTAssertEqual(viewModel.users[0].picture.large, "https://example.com/large.jpg")
            
            XCTAssertEqual(viewModel.users[1].name.first, "Jane")
            XCTAssertEqual(viewModel.users[1].name.last, "Smith")
            XCTAssertEqual(viewModel.users[1].dob.age, 26)
            XCTAssertEqual(viewModel.users[1].picture.medium, "https://example.com/medium.jpg")
            
        }
        
    }
 }

private extension UserListViewModelTests {
    // Define a mock for executeDataRequest that returns predefined data
    func mockExecuteDataRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        // Create mock data with a sample JSON response
        let sampleJSON = """
            {
                "results": [
                    {
                        "name": {
                            "title": "Mr",
                            "first": "John",
                            "last": "Doe"
                        },
                        "dob": {
                            "date": "1990-01-01",
                            "age": 31
                        },
                        "picture": {
                            "large": "https://example.com/large.jpg",
                            "medium": "https://example.com/medium.jpg",
                            "thumbnail": "https://example.com/thumbnail.jpg"
                        }
                    },
                    {
                        "name": {
                            "title": "Ms",
                            "first": "Jane",
                            "last": "Smith"
                        },
                        "dob": {
                            "date": "1995-02-15",
                            "age": 26
                        },
                        "picture": {
                            "large": "https://example.com/large.jpg",
                            "medium": "https://example.com/medium.jpg",
                            "thumbnail": "https://example.com/thumbnail.jpg"
                        }
                    }
                ]
            }
        """
        
        let data = sampleJSON.data(using: .utf8)!
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (data, response)
    }
}
