//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

protocol ShadowEmitter {
    
    // MARK: - API
    
    func adjustAfterShading()
    func adjustAfterRemovingShade()
}

extension ShadowEmitter where Self: UIView {
    
    // MARK: - Properties

    private var isShading: Bool {
        shadowLayer?.opacity == 1
    }
    
    private var shadowLayer: CALayer? {
        layer.sublayers?.first(where: { $0.name == .shadowLayer })
    }
    
    private var isDroppingShadow: Bool {
        shadowLayer != nil
    }
    
    // MARK: - API
    
    func shade() {
        dropShadow()
        guard !isShading else { return }
        updateShading()
    }
    
    func removeShade() {
        guard isShading else { return }
        updateShading()
    }
    
    // MARK: - Private
    
    private func updateShading() {
        shadowLayer?.opacity = isShading ? 0 : 1
        isShading ? adjustAfterShading() : adjustAfterRemovingShade()
    }
    
    private func dropShadow() {
        guard !isDroppingShadow, bounds != .zero else { return }
        let layer = CALayer()
        layer.name = .shadowLayer
        layer.masksToBounds = false
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 8
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.frame = bounds
        self.layer.insertSublayer(layer, at: 0)
        adjustAfterShading()
    }
}

private extension String {
    static let shadowLayer = "shadowLayer"
}
