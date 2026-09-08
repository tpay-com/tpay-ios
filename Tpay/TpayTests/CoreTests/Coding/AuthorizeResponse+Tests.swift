//
//  Copyright © 2026 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class AuthorizeResponse_Tests: XCTestCase {

    // MARK: - Properties

    private let jsonDecoder = JSONDecoder()

    // MARK: - Tests

    func test_NumericExpiresInDecoding() throws {
        let sut = try decode(
        """
        {
            "access_token": "token",
            "expires_in": 7200
        }
        """)

        expect(sut.accessToken).to(equal("token"))
        expect(sut.expiresIn).to(equal(7_200))
    }

    func test_StringExpiresInDecoding() throws {
        let sut = try decode(
        """
        {
            "access_token": "token",
            "expires_in": "7200"
        }
        """)

        expect(sut.expiresIn).to(equal(7_200))
    }

    func test_MissingExpiresInDecoding() throws {
        let sut = try decode(
        """
        {
            "access_token": "token"
        }
        """)

        expect(sut.accessToken).to(equal("token"))
        expect(sut.expiresIn).to(beNil())
    }

    func test_NullExpiresInDecoding() throws {
        let sut = try decode(
        """
        {
            "access_token": "token",
            "expires_in": null
        }
        """)

        expect(sut.expiresIn).to(beNil())
    }

    func test_UnconvertibleStringExpiresInDecoding() throws {
        let sut = try decode(
        """
        {
            "access_token": "token",
            "expires_in": "soon"
        }
        """)

        expect(sut.expiresIn).to(beNil())
    }

    func test_UnexpectedTypeExpiresInDecoding() throws {
        let sut = try decode(
        """
        {
            "access_token": "token",
            "expires_in": { "seconds": 7200 }
        }
        """)

        expect(sut.expiresIn).to(beNil())
    }

    func test_MissingAccessTokenDecoding() {
        expect {
            try self.decode(
            """
            {
                "expires_in": 7200
            }
            """)
        }
        .to(throwError())
    }

    // MARK: - Private

    private func decode(_ payload: String) throws -> AuthorizationController.Authorize.Response {
        try jsonDecoder.decode(AuthorizationController.Authorize.Response.self, from: try XCTUnwrap(payload.data(using: .utf8)))
    }
}
