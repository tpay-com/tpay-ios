//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension ChoosePaymentMethodViewController {
    
    final class ContentView: UIScrollView, KeyboardAware {
    
        // MARK: - Properties
        
        let collectionView = CollectionView()
        
        private let container = UIView()
        private let paymentContentView = UIView()
        
        private var pinnedContent: PinnableContent?
        private var pinnedContentPlaceholder: UIView?
        private let bottomSectionLogo = BottomSection.Logo()
                
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()

            setupLayout()
            setupAppearance()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            recalculateShading()
        }
        
        // MARK: - KeyboardAware
        
        func adjust(for payload: KeyboardAppearancePayload) {
            guard let firstResponder = firstResponder else { return }
            
            let maxY = contentOffset.y + visibleSize.height

            let converted = firstResponder.convert(firstResponder.frame.origin, to: self).y
            let firstResponderMaxY = converted + firstResponder.frame.height

            let pinnedContentHeight = pinnedContent?.frame.size.height ?? .zero
            let distanceToPinnedContent = (maxY - pinnedContentHeight) - firstResponderMaxY
            
            if payload.mode == .appearing, distanceToPinnedContent < 8 {
                let contentOffset = contentOffset.applying(.init(translationX: 0, y: -distanceToPinnedContent + 8))
                setContentOffset(contentOffset, animated: false)
            }
        }
        
        // MARK: - API
        
        func set(payment contentView: UIView) {
            contentView.layout
                .add(to: paymentContentView)
                .leading.equalTo(paymentContentView, .leading)
                .trailing.equalTo(paymentContentView, .trailing)
                .top.equalTo(paymentContentView, .top)
                .bottom.equalTo(paymentContentView, .bottom)
                .activate()
                        
            if let pinnableContentProvider = contentView as? PinnableContentProvider {
                pinnedContentPlaceholder = pinnableContentProvider.pinnedContentPlaceholder
                pin(bottomSection: pinnableContentProvider.pinnableContent)
                pinnableContentProvider.adjustAfterPinning()
            } else {
                unpinPreviousContent()
            }
            
            setNeedsLayout()
            layoutIfNeeded()
            
            recalculateShading()
        }
        
        func select(paymentMethod atIndexPath: IndexPath) {
            collectionView.selectItem(at: atIndexPath, animated: false, scrollPosition: .top)
        }
        
        // MARK: - Private
        
        private func setupLayout() {
            translatesAutoresizingMaskIntoConstraints = false
            
            container.layout
                .add(to: self)
                .leading.equalTo(safeAreaLayoutGuide, .leading)
                .trailing.equalTo(safeAreaLayoutGuide, .trailing)
                .top.equalTo(self, .top)
                .bottom.equalTo(self, .bottom)
                .xAxis.center(with: self).with(priority: .defaultLow)
                .yAxis.center(with: self).with(priority: .defaultLow)
                .height.greaterThanOrEqualTo(self, .height)
                .activate()

            collectionView.layout
                .add(to: container)
                .top.equalTo(container, .top)
                .leading.equalTo(container, .leading)
                .trailing.equalTo(container, .trailing)
                .height.equalTo(constant: 80)
                .activate()
            
            paymentContentView.layout
                .add(to: container)
                .top.equalTo(collectionView, .bottom).with(constant: 16)
                .bottom.equalTo(container, .bottom)
                .leading.equalTo(container, .leading)
                .trailing.equalTo(container, .trailing)
                .activate()
            
            bottomSectionLogo.layout
                .add(to: self)
                .leading.equalTo(container, .leading).with(constant: 16)
                .trailing.equalTo(container, .trailing).with(constant: -16)
                .activate()
        }
        
        private func setupAppearance() {
            bottomSectionLogo.hide()
        }
        
        private func unpinPreviousContent() {
            pinnedContent?.removeFromSuperview()
        }
        
        private func pin(bottomSection view: PinnableContent) {
            let previousContent = pinnedContent
            
            view.removeFromSuperview()
            view.layout
                .add(to: self)
                .width.equalTo(self, .width)
                .xAxis.center(with: self)
                .bottom.equalTo(safeAreaLayoutGuide, .bottom)
                .activate()
            
            bottomSectionLogo.layout
                .bottom.equalTo(view, .top)
                .activate()
                        
            pinnedContent = view
            previousContent?.removeFromSuperview()
        }
        
        private func recalculateShading() {
            guard let pinnedContent = pinnedContent,
                  let pinnedContentPlaceholder = pinnedContentPlaceholder else {
                return
            }

            let bottomSectionLogoYPosition = convert(pinnedContent.frame.origin, to: paymentContentView).y - bottomSectionLogo.bounds.height
            let pinnedContentPlaceholderYPosition = pinnedContentPlaceholder.frame.minY
            let distanceToPlaceholder = bottomSectionLogoYPosition - pinnedContentPlaceholderYPosition

            guard distanceToPlaceholder > -8 else {
                shade()
                return
            }
            removeShade()
        }
        
        private func shade() {
            pinnedContent?.shade()
            bottomSectionLogo.fadeOut()
        }
        
        private func removeShade() {
            pinnedContent?.removeShade()
            bottomSectionLogo.fadeIn()
        }
    }
}

extension ChoosePaymentMethodViewController.ContentView: SheetAppearanceAware {
    
    func adjust(for appearance: SheetViewController.ContentView.Appearance) {
        recalculateShading()
    }
}
