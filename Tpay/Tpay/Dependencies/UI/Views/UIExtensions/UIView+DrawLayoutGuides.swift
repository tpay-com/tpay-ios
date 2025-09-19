//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension UIView {
    
    func drawLayoutGuides() {
        for subview in subviews {
            subview.drawLayoutGuides()
        }
        
        guard let layers = layer.sublayers else { return }
        
        layers.forEach { layer in (layer as? LayoutGuideLayer)?.removeFromSuperlayer() }
        layoutGuides.map(LayoutGuideLayer.init).forEach(layer.addSublayer)
    }
    
}

extension UIView {
    
    private final class LayoutGuideLayer: CAShapeLayer {
        
        init(guide: UILayoutGuide) {
            super.init()
            
            self.path = UIBezierPath(rect: guide.layoutFrame).cgPath
            self.lineWidth = 0.5
            self.lineDashPattern = [1, 1, 1, 1]
            self.fillColor = UIColor.clear.cgColor
            self.strokeColor = UIColor.red.cgColor
            
            let label = CATextLayer()
            label.foregroundColor = UIColor.black.cgColor
            label.font = UIFont.systemFont(ofSize: 12)
            label.fontSize = 16
            label.frame = guide.layoutFrame
            label.string = "\(guide.layoutFrame.size)"
            label.alignmentMode = CATextLayerAlignmentMode.center
            
            addSublayer(label)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}
