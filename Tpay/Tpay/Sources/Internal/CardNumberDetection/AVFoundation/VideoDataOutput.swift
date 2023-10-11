//
//  Copyright © 2022 Tpay. All rights reserved.
//

import AVFoundation
import Foundation

class VideoDataOutput: AVCaptureVideoDataOutput {
    
    // MARK: - Properties
    
    var orientation: AVCaptureVideoOrientation = .portrait {
        didSet {
            configureConnection()
        }
    }
    
    var connectionEnabled: Bool = true {
        didSet {
            configureConnection()
        }
    }
    
    // MARK: - API
    
    func configureOutput() {
        alwaysDiscardsLateVideoFrames = true
        videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
        configureConnection()
    }
    
    func configureConnection() {
        let captureConnection = connection(with: .video)
        captureConnection?.videoOrientation = orientation
        captureConnection?.isEnabled = connectionEnabled
    }
}
