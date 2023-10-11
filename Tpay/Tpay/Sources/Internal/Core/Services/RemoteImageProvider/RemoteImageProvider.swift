//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Foundation
import UIKit

struct RemoteImageProvider {
    
    // MARK: - Properties
    
    static let cache: ImageCache = .default
    
    private static var tasks: [UIView: DownloadTask] = [:]
    
    private let imageView: UIImageView
    
    init(imageView: UIImageView) {
        self.imageView = imageView
    }
    
    // MARK: - API
    
    static func clearAll(completion handler: (() -> Void)? = nil) {
        tasks.values.forEach { $0.cancel() }
        cache.clearCache(completion: handler)
    }
    
    static func prefetch(urls: [URL], completion: @escaping (Result<Void, Error>) -> Void) {
        let invocationGroup = Invocation.Group()
        urls.forEach { invocationGroup.append(method: prefetch, with: $0) }
        
        invocationGroup.invoke { completion($0) }
    }
    
    func invalidate() {
        Self.tasks[imageView]?.cancel()
    }
    
    func setImage(with url: URL, completion: @escaping (Result<Source, Error>) -> Void) {
        Self.tasks[imageView]?.cancel()
        Self.tasks[imageView] = imageView.kf.setImage(with: url) { [weak imageView] result in
            Logger.debug("Image retrieved with result: \(result)")
            if let view = imageView {
                Self.tasks[view] = nil
            }
            
            result.match(onSuccess: { completion(.success(Source(wrapping: $0.cacheType))) },
                         onFailure: { completion(.failure($0)) })
        }
    }
    
    // MARK: - Private
    
    private static func prefetch(url: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        KingfisherManager.shared.retrieveImage(with: url) { result in
            Logger.debug("Image prefetched with result: \(result)")
            result.match(onSuccess: { _ in completion(.success(())) },
                         onFailure: { completion(.failure($0)) })
        }
    }
}

extension UIImageView {
    
    var remoteImageProvider: RemoteImageProvider { RemoteImageProvider(imageView: self) }
}
