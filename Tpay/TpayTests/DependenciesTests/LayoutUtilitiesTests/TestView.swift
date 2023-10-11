//
//  Copyright © 2022 Tpay. All rights reserved.
//

@testable import Tpay

final class TestView: View {

    // MARK: - Properties

    let width: CGFloat = 200
    let height: CGFloat = 200
    
    // MARK: - Getters

    var layoutGuide: LayoutGuide {
        let guide = LayoutGuide()
        addLayoutGuide(guide)
        guide.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        guide.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        guide.topAnchor.constraint(equalTo: topAnchor).isActive = true
        guide.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        return guide
    }

    // MARK: - Initialization

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
    }

    required init?(coder: NSCoder) { nil }

}

#if canImport(UIKit)
import UIKit

extension TestView {

    // MARK: - Getters

    var direction: UserInterfaceLayoutDirection {
        effectiveUserInterfaceLayoutDirection == .leftToRight ? .leftToRight : .rightToLeft
    }

    // MARK: - Internal

    func prepare() {
        setNeedsLayout()
        layoutIfNeeded()
    }

}

#else
import AppKit

extension TestView {

    // MARK: - Getters

    override var isFlipped: Bool { true }

    var direction: UserInterfaceLayoutDirection {
        userInterfaceLayoutDirection == .leftToRight ? .leftToRight : .rightToLeft
    }

    // MARK: - Internal

    func prepare() {
        layoutSubtreeIfNeeded()
    }

}

#endif
