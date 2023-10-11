//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

@available(iOS 13.0, *)
final class RemoteImageProvider_Tests: XCTestCase {
    
    // MARK: - Lifecycle
    
    override func setUp() async throws {
        await withCheckedContinuation { continuation in
            RemoteImageProvider.clearAll {
                continuation.resume()
            }
        }
    }
    
    // MARK: - Tests
    
    func test_PrefetchSuccess() {
        let expectation = expectation(description: "test_PrefetchSuccess")
        prefetchStubs { [expectation] result in
            guard case .success = result else { return }
            expect(RemoteImageProvider.cache.isCached(forKey: Stub.image1Url.cacheKey)) == true
            expect(RemoteImageProvider.cache.isCached(forKey: Stub.image2Url.cacheKey)) == true
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
    
    func test_PrefetchFailure() {
        let expectation = expectation(description: "test_PrefetchFailure")
        RemoteImageProvider.prefetch(urls: [Stub.image1Url, Stub.notAnImageUrl]) { [expectation] result in
            guard case .failure = result else { return }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
    
    func test_ClearAll() {
        let expectation = expectation(description: "test_ClearAll")
        let expectationChecks = { [expectation] in
            expect(RemoteImageProvider.cache.isCached(forKey: Stub.image1Url.cacheKey)) == false
            expect(RemoteImageProvider.cache.isCached(forKey: Stub.image2Url.cacheKey)) == false
            
            expectation.fulfill()
        }
        prefetchStubs { _ in
            RemoteImageProvider.clearAll { expectationChecks() }
        }
        
        waitForExpectations(timeout: 3)
    }
    
    func test_SetImageWithPrefetchedImage() {
        let expectation = expectation(description: "test_SetImageWithPrefetchedImage")
        let sut = UIImageView().remoteImageProvider
        
        prefetchStubs { [sut] _ in
            sut.setImage(with: Stub.image1Url) { [expectation] result in
                guard case .success(let source) = result else { return }
                expect(source) == .memory
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3)
    }
    
    func test_SetImageWithoutPrefetchedImage() {
        let expectation = expectation(description: "test_SetImageWithoutPrefetchedImage")
        let sut = UIImageView().remoteImageProvider
        
        sut.setImage(with: Stub.image1Url) { [expectation] result in
            guard case .success(let source) = result else { return }
            expect(source) == .network
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
    
    func test_SetImageFailure() {
        let expectation = expectation(description: "test_SetImageFailure")
        let sut = UIImageView().remoteImageProvider
        
        sut.setImage(with: Stub.notAnImageUrl) { [expectation] result in
            guard case .failure = result else { return }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
    
    func test_SetImageCache() {
        let expectation = expectation(description: "test_SetImageCache")
        let sut = UIImageView().remoteImageProvider
        let stub = Stub.image1Url
        
        sut.setImage(with: stub) { [expectation, sut] result in
            guard case .success(let source) = result else { return }
            expect(source) == .network
            
            sut.setImage(with: stub) { [expectation] result in
                guard case .success(let source) = result else { return }
                expect(source) == .memory
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3)
    }
    
    func test_Invalidate() {
        let expectation = expectation(description: "test_Invalidate")
        let sut = UIImageView().remoteImageProvider
        
        sut.setImage(with: Stub.image1Url) { [expectation] result in
            guard case .failure(let error) = result else { return }
            expect(error).to(beAnInstanceOf(KingfisherError.self))
            expectation.fulfill()
        }
        sut.invalidate()
        
        waitForExpectations(timeout: 1)
    }
    
    // MARK: - Private
    
    private func prefetchStubs(completion handler: @escaping (Result<Void, Error>) -> Void) {
        let stubs = [Stub.image1Url, Stub.image2Url]
        RemoteImageProvider.prefetch(urls: stubs) { handler($0) }
    }
}

@available(iOS 13.0, *)
private extension RemoteImageProvider_Tests {
    
    enum Stub {
        
        static let image1Url = URL(safeString: "https://secure.tpay.com/_/g/113.png")
        static let image2Url = URL(safeString: "https://secure.tpay.com/_/g/166.png")
        
        static let notAnImageUrl = URL(safeString: "https://google.com")
    }
}
