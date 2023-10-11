//
//  Copyright © 2022 Tpay. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit

final class VideoPreviewLayer: AVCaptureVideoPreviewLayer {
    
    // MARK: - Properties
    
    var videoAspectRatio: AVLayerVideoGravity = .resizeAspectFill {
        didSet {
            configure()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            configure()
        }
    }
    
    // MARK: - Initializers
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    init(session: AVCaptureSession, bounds: CGRect = .zero) {
        super.init(session: session)
        
        self.bounds = bounds
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Private
    
    private func configure() {
        videoGravity = videoAspectRatio
        position = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}
