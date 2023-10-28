//
//  testRepository.swift
//  RecipleaseTests
//
//  Created by pierrick viret on 01/10/2023.
//

import XCTest
import Alamofire
import Combine

@testable import Reciplease

final class TestRepository: TestCase {

    var cancellables = Set<AnyCancellable>()

    func testRecipFetching() {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockURLProtocol.self] + (configuration.protocolClasses ?? [])
        let sessionManager = NetworkRepository(sessionConfiguration: configuration)

        let response = HTTPURLResponse(url: URL(string: "https://api.edamam.com/api/recipes/v2?type=public&q=Lemon%20Cheese&app_key=key&app_id=id")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!

        let mockData = self.getData(fromJson: "RecipJSON")!

        MockURLProtocol.requestHandler = { _ in
            return (response, mockData)
        }

        let expectedLabel = "Blueberry-Lemon Cheese Blintzes"

        let requestExpectation = expectation(description: "Request should finish")

        sessionManager.fetchRecip(["Lemon", "Cheese"])
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    XCTFail("pas ici")
                }
            } receiveValue: { data in
                XCTAssertEqual(expectedLabel, data.hits[0].recipe.label)
                requestExpectation.fulfill()
            }.store(in: &cancellables)

        wait(for: [requestExpectation], timeout: 10.0)
    }

}
