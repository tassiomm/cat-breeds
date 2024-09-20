//
//  NetworkClientTests.swift
//  cat-breeds
//
//  Created by Developer on 17/09/24.
//

import XCTest
@testable import cat_breeds

import Combine

final class NetworkClientTests: XCTestCase {
    var cancellable = Set<AnyCancellable>()
    var mockSession: MockSession!
    var client: HTTPClient!

    let mockRequest = MockRequest()


    override func setUp() {
        mockSession = MockSession()
        InjectionContainer.register(type: NetworkSession.self, value: mockSession)
        client = HTTPClient()
    }

    func testStatusCodeNot200Prefix() async {
        let expect = expectation(description: "")
        mockSession.statusCode = 501
        mockSession.data = MockRequest.validDataExample

        client.request(MockRequest())
            .sink { status in
                switch status {
                case .failure(let error):
                    XCTAssertEqual(error, NetworkError.badServerResponse)
                    expect.fulfill()
                case .finished:
                    XCTFail("Should not succeed")
                }
            } receiveValue: { _ in
                XCTFail("Should not succeed")
            }.store(in: &cancellable)

        await fulfillment(of: [expect])
    }

    func testStatusCodeSuccessful() async {
        let expect = expectation(description: "")
        mockSession.statusCode = 201
        mockSession.data = MockRequest.validDataExample

        client.request(MockRequest())
            .sink { status in
                switch status {
                case .failure:
                    XCTFail("Should not fail")
                case .finished:
                    break
                }
            } receiveValue: { _ in
                expect.fulfill()
            }.store(in: &cancellable)

        await fulfillment(of: [expect])
    }

    func testStatusCodeSuccessfulButInvalidJSON() async {
        let expect = expectation(description: "")
        mockSession.statusCode = 201
        mockSession.data = "kkk jj{}??//"

        client.request(MockRequest())
            .sink { status in
                switch status {
                case .failure:
                    expect.fulfill()
                case .finished:
                    break
                }
            } receiveValue: { _ in
                XCTFail("Should not succeed")
            }.store(in: &cancellable)

        await fulfillment(of: [expect])
    }


}

class MockSession: NetworkSession {
    var statusCode = 200
    var data = ""

    func dataTask(for request: URLRequest) -> AnyPublisher<SessionResponse, URLError> {
        let response = HTTPURLResponse(url: request.url!,
                                       statusCode: statusCode,
                                       httpVersion: "HTTP/1.1",
                                       headerFields: nil)!
        let data = data.data(using: .utf8)!
        return Just((data: data, response: response))
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }

    func dataTask(for url: URL) -> AnyPublisher<SessionResponse, URLError> {
        fatalError()
    }
}

struct MockRequest: NetworkRequest {
    let path: String = "/"
    let method: HTTPMethod = .get
    let responseType = [String].self

    static let validDataExample = """
    [
        "some data",
        "some other data"
    ]
    """
}
