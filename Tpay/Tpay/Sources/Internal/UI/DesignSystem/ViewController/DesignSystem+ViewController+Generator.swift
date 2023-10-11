//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension DesignSystem.ViewController.ContentView {
    
    final class Generator {
        
        private let numberOfLines: UInt
        
        init(numberOfLines: UInt) {
            self.numberOfLines = numberOfLines
        }
        
        func generate() -> [Label] {
            var labels = [Label]()
            for i in 0...numberOfLines {
                labels += [Label.Builder(label: Label.H1())
                            .set(text: "\(i)")
                            .set(color: DesignSystem.Color.Colors.Primary._900)
                            .build()]
            }
            return labels
        }
    }
}
