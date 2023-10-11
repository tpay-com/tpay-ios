//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension SheetViewController {
    
    final class ContentView: UIView, KeyboardAware {
        
        // MARK: - Events
        
        var languageSelected: Observable<Language> { languageSwitch.languageSelected }
        var closeButtonTapped: Observable<Void> { cardView.closeButtonTapped }
        var changePayerDetails: Observable<Void> { payerDetailsView.changePayerDetails }
        
        let appearanceChanged = Observable<Appearance>()

        // MARK: - Properties
        
        private(set) var appearance: Appearance = .default
        
        private let cardView = CardView()
        private let payerDetailsView = PayerDetailsView()
        private let languageSwitch = LanguageSwitch(initialLanguage: .current, supportedLanguages: Language.supported)
        
        private let panHandler = PanHandler()
        private var isScrollable = true
        private var scrollDisposer = Disposer()
        
        private lazy var cardHeightConstraint: NSLayoutConstraint = {
            let constraint = cardView.heightAnchor.constraint(equalToConstant: Appearance.compactAppearanceHeight)
            constraint.priority = .defaultLow
            return constraint
        }()
        
        private lazy var cardBottomConstraint: NSLayoutConstraint = {
            let constraint = cardView.bottomAnchor.constraint(equalTo: bottomAnchor)
            return constraint
        }()
        
        private lazy var languageSwitchBottomConstraint: NSLayoutConstraint = {
            languageSwitch.bottomAnchor.constraint(equalTo: cardView.topAnchor, constant: 50)
        }()
        
        private lazy var payerDetailsBottomConstraint: NSLayoutConstraint = {
            payerDetailsView.bottomAnchor.constraint(equalTo: cardView.topAnchor, constant: 83)
        }()
        
        // MARK: - Lifecycle
        
        init() {
            super.init(frame: .zero)
            
            setupLayout()
            setupAppearance()
            setupActions()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) { nil }
        
        // MARK: - API
        
        func set(appearance: Appearance) {
            self.appearance = appearance

            updateAppearance()
            
            UIView.animate(withDuration: 0.2,
                           delay: 0.0,
                           options: .curveEaseIn,
                           animations: { [weak self] in self?.layoutIfNeeded() },
                           completion: { [weak self] _ in self?.appearanceChanged.on(.next(appearance)) })
        }
        
        func set(title: String?) {
            cardView.set(title: title)
        }
        
        func set(titleImage: UIImage?) {
            cardView.set(titleImage: titleImage)
        }
        
        func set(content: UIView) {
            cardView.set(content: content)
            
            if let scrollView = content as? UIScrollView {
                observeScrollContent(for: scrollView)
            }
        }
        
        func set(isCancellable: Bool) {
            cardView.set(isCancellable: isCancellable)
        }
        
        func set(payerDetails: Domain.Payer) {
            payerDetailsView.set(name: payerDetails.name)
            payerDetailsView.set(email: payerDetails.email)
        }
        
        func showPayerDetails(_ then: (() -> Void)? = nil) {
            payerDetailsView.show()
            layoutIfNeeded()
            payerDetailsBottomConstraint.constant = -8

            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 10,
                           animations: { [weak self] in self?.layoutIfNeeded() },
                           completion: { _ in then?() })
        }
        
        func hidePayerDetails(_ then: (() -> Void)? = nil) {
            layoutIfNeeded()
            payerDetailsBottomConstraint.constant = 83
            
            UIView.animate(withDuration: 0.2,
                           animations: { [weak self] in self?.layoutIfNeeded() },
                           completion: { [weak self] _ in self?.payerDetailsView.hide(); then?() })
        }
        
        func showLanguageSwitch(_ then: (() -> Void)? = nil) {
            languageSwitch.show()
            layoutIfNeeded()
            languageSwitchBottomConstraint.constant = -8

            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 10,
                           animations: { [weak self] in self?.layoutIfNeeded() },
                           completion: { _ in then?() })
        }
        
        func hideLanguageSwitch(_ then: (() -> Void)? = nil) {
            layoutIfNeeded()
            languageSwitchBottomConstraint.constant = 83
            
            UIView.animate(withDuration: 0.2,
                           animations: { [weak self] in self?.layoutIfNeeded() },
                           completion: { [weak self] _ in self?.languageSwitch.hide(); then?() })
        }
        
        func lockScroll() {
            isScrollable = false
        }
        
        func unlockScroll() {
            isScrollable = true
        }
        
        // MARK: - KeyboardAware
        
        func adjust(for payload: KeyboardAppearancePayload) {
            if payload.mode == .appearing {
                set(appearance: .large)
                cardBottomConstraint.constant = -payload.height
            } else {
                cardBottomConstraint.constant = 0
            }
            layoutIfNeeded()
        }
        
        // MARK: - Private
        
        private func setupLayout() {
            cardView.layout
                .add(to: self)
                .top.greaterThanOrEqualTo(safeAreaLayoutGuide, .top)
                .height.greaterThanOrEqualTo(constant: Appearance.minCardHeight)
                .leading.equalTo(self, .leading)
                .trailing.equalTo(self, .trailing)
                .activate()
            
            payerDetailsView.layout
                .add(to: self)
                .leading.equalTo(self, .leading).with(constant: 16)
                .trailing.equalTo(self, .trailing).with(constant: -16)
                .activate()
            
            languageSwitch.layout
                .add(to: self)
                .trailing.equalTo(self, .trailing).with(constant: -16)
                .activate()
            
            NSLayoutConstraint.activate([cardHeightConstraint, cardBottomConstraint, languageSwitchBottomConstraint, payerDetailsBottomConstraint])
        }
        
        private func setupAppearance() {
            updateAppearance()
            
            sendSubviewToBack(languageSwitch)
            sendSubviewToBack(payerDetailsView)
        }
        
        private func setupActions() {
            panHandler.setup(for: self)
        }
        
        private func updateAppearance() {
            switch appearance {
            case .compact:
                cardHeightConstraint.constant = Appearance.compactAppearanceHeight
            case .large:
                cardHeightConstraint.constant = frame.height
            }
        }
        
        private func observeScrollContent(for view: UIScrollView) {
            scrollDisposer.disposeAll()
            
            view.panGestureRecognizer.asObservable()
                .map { $0 as? UIPanGestureRecognizer }
                .subscribe(onNext: { [weak self] gestureRecognizer in
                    self?.panHandler.handleExternalPan(gestureRecognizer)
                })
                .add(to: scrollDisposer)
            
            view.contentOffsetObservable
                .subscribe(onNext: { [weak self] contentOffset in
                    self?.updateShading(for: contentOffset)
                })
                .add(to: scrollDisposer)
        }
        
        private func updateShading(for contentOffset: CGPoint) {
            guard panHandler.transitionStatus != .transitioning else {
                cardView.removeShade()
                return
            }
            contentOffset.y <= 0 ? cardView.removeShade() : cardView.shade()
        }
    }
}

extension SheetViewController.ContentView {
    
    enum Appearance {
        
        // MARK: - Properties
        
        static let compactAppearanceHeight: CGFloat = 504
        static let minCardHeight: CGFloat = 100
        
        static let `default`: Appearance = .compact
        
        // MARK: - Cases
        
        case compact
        case large
    }
}

extension SheetViewController.ContentView {
    
    final class PanHandler {
        
        // MARK: - Properties
        
        private static let maxSnapYVelocity: CGFloat = 200
        
        private weak var contentView: SheetViewController.ContentView?
        
        private var gestureRecognizer: UIGestureRecognizer {
            UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(_:)))
        }
        
        private var largeAppearanceHeight: CGFloat {
            guard let contentView = contentView else {
                return .zero
            }
            return contentView.frame.height - contentView.safeAreaInsets.top
        }
        
        private var initialHeight: CGFloat = Appearance.compactAppearanceHeight
        private(set) var transitionStatus: TransitionStatus = .idle(.default)
        
        // MARK: - API
        
        func setup(for contentView: SheetViewController.ContentView) {
            self.contentView = contentView
            
            contentView.cardView.addGestureRecognizer(gestureRecognizer)
        }
        
        func handleExternalPan(_ sender: UIPanGestureRecognizer? = nil) {
            guard sender?.state != .possible,
                  let scrollView = sender?.view as? UIScrollView else {
                return
            }
            
            func lockScrollOnTop() {
                scrollView.setContentOffset(.zero, animated: false)
            }
            
            if transitionStatus == .transitioning {
                lockScrollOnTop()
            }
            
            if transitionStatus == .idle(.large), scrollView.contentOffset.y > 0 { // prevent card from transitioning while scrolling to top
                return
            }
            
            if transitionStatus == .idle(.large), sender?.state != .began { // prevent card from transitioning when content not fully scrolled to top
                return
            }

            handlePan(sender)
        }
        
        // MARK: - Private
        
        @objc private func handleCardPan(_ sender: UIPanGestureRecognizer? = nil) {
            if let scrollView = contentView?.firstSubview(of: UIScrollView.self) {
                scrollView.setContentOffset(.zero, animated: false)
            }
            handlePan(sender)
        }
        
        private func handlePan(_ sender: UIPanGestureRecognizer? = nil) {
            guard let sender = sender,
                  let contentView = contentView, contentView.isScrollable else {
                return
            }
            let piece = contentView.cardView
            
            let yTranslation = sender.translation(in: contentView).y
            let yVelocity = sender.velocity(in: contentView).y
            
            if sender.state == .began {
                initialHeight = piece.frame.height
                transitionStatus = .transitioning
            }
            
            guard sender.state != .cancelled else {
                contentView.set(appearance: contentView.appearance)
                transitionStatus = .idle(contentView.appearance)
                return
            }
            
            guard sender.state != .ended else {
                let resolvedAppearance = resolveSnap(yVelocity)
                contentView.set(appearance: resolvedAppearance)
                transitionStatus = .idle(resolvedAppearance)
                return
            }
            
            let newHeight = max(0, initialHeight - yTranslation)
            contentView.cardHeightConstraint.constant = newHeight
            contentView.layoutIfNeeded()

            transitionStatus = resolveTransitionStatus()
        }
        
        private func resolveSnap(_ yVelocity: CGFloat) -> Appearance {
            guard let contentView = contentView else {
                return .default
            }
            
            let currentHeight = contentView.cardHeightConstraint.constant
            
            let compactAppearanceHeight = Appearance.compactAppearanceHeight
            let largeAppearanceHeight = contentView.frame.height
            
            let compactDistance = abs(compactAppearanceHeight - currentHeight)
            let largeDistance = abs(largeAppearanceHeight - currentHeight)
            
            let nearest = min(compactDistance, largeDistance) == compactDistance ? Appearance.compact : Appearance.large

            if yVelocity > Self.maxSnapYVelocity,
               currentHeight > compactAppearanceHeight,
               currentHeight < largeAppearanceHeight {
                return PanHandler.switchAppearance(contentView.appearance)
            }
            return nearest
        }
                
        private static func switchAppearance(_ appearance: Appearance) -> Appearance {
            switch appearance {
            case .compact:
                return .large
            case .large:
                return .compact
            }
        }
        
        private func resolveTransitionStatus() -> TransitionStatus {
            guard let transitioningElement = contentView?.cardView else {
                return .transitioning
            }
            
            switch transitioningElement.frame.height {
            case largeAppearanceHeight:
                return .reached(.large)
            default:
                return .transitioning
            }
        }
    }
}

extension SheetViewController.ContentView.PanHandler {
    
    enum TransitionStatus: Equatable {
        
        // MARK: - Cases
        
        case idle(SheetViewController.ContentView.Appearance)
        case transitioning
        case reached(SheetViewController.ContentView.Appearance)
    }
}
