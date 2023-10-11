//
//  Copyright © 2022 Tpay. All rights reserved.
//

import AVFoundation
import Foundation

class CaptureSession: AVCaptureSession {
    
    // MARK: - Properties

    private let preset: AVCaptureSession.Preset
    private let videoDataOutput: VideoDataOutput?

    // MARK: - Initialization

    init(dataOutput: VideoDataOutput, quality: AVCaptureSession.Preset = .hd1920x1080) {
        self.preset = quality
        self.videoDataOutput = dataOutput
        super.init()

        configure()
    }

    // MARK: - Methods

    private func configure() {
        guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        guard let output = videoDataOutput else { return }

        beginConfiguration()
        sessionPreset = preset

        if canAddInput(input) { addInput(input) }
        
        if canAddOutput(output) {
            addOutput(output)
            output.configureOutput()
        }

        commitConfiguration()
    }
}
