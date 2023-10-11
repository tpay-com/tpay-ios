//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class UIView_Finder_Tests: XCTestCase {
    
    // MARK: - Tests
    
    func test_allSubviews() {
        let parent = UIView()
        
        let child1 = UIView()
        let child2 = UIView()
        let child3 = UIView()
        
        let child11 = UIView()
        let child12 = UIView()
        let child21 = UIView()
        
        parent.addSubview(child1)
        parent.addSubview(child2)
        parent.addSubview(child3)
        
        child1.addSubview(child11)
        child1.addSubview(child12)
        
        child2.addSubview(child21)

        expect(parent.allSubviews.count).to(equal(6))
        
        expect(child1.allSubviews.count).to(equal(2))
        expect(child2.allSubviews.count).to(equal(1))
        expect(child3.allSubviews.count).to(equal(0))
        
        expect(child11.allSubviews.count).to(equal(0))
        expect(child12.allSubviews.count).to(equal(0))
        expect(child21.allSubviews.count).to(equal(0))
    }
    
    func test_subviewsOfType() {
        let parent = UIView()
        
        let child1 = UIView()
        let child2 = UIView()
        let child3 = CustomView()
        
        let child11 = CustomView()
        let child12 = UIView()
        let child21 = CustomView()
        
        parent.addSubview(child1)
        parent.addSubview(child2)
        parent.addSubview(child3)
        
        child1.addSubview(child11)
        child1.addSubview(child12)
        
        child2.addSubview(child21)
        
        expect(parent.allSubviews(of: CustomView.self).count).to(equal(3))
        expect(child1.allSubviews(of: CustomView.self).count).to(equal(1))
    }
    
    func test_firstSubviewOfType() {
        let parent = UIView()
        
        let child1 = UIView()
        let child2 = UIView()
        let child3 = CustomView()
        
        let child11 = CustomView()
        let child12 = UIView()
        let child21 = CustomView()
        
        parent.addSubview(child1)
        parent.addSubview(child2)
        parent.addSubview(child3)
        
        child1.addSubview(child11)
        child1.addSubview(child12)
        
        child2.addSubview(child21)
        
        expect(parent.firstSubview(of: CustomView.self)).to(equal(child3))
        expect(child1.firstSubview(of: CustomView.self)).to(equal(child11))
    }
}

private extension UIView_Finder_Tests {
    
    final class CustomView: UIView { }
}
