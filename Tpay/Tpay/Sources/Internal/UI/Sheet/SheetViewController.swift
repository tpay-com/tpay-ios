//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class SheetViewController: UIViewController {
    
    // MARK: - Events
    
    var languageSelected: Observable<Language> { contentView.languageSelected }
    var closeButtonTapped: Observable<Void> { contentView.closeButtonTapped }
    var changePayerDetails: Observable<Void> { contentView.changePayerDetails }

    // MARK: - Properties
    
    private let contentView = ContentView()
    
    private var currentController: UIViewController?
    private var currentContext: Context = .default
    
    private let keyboardObserver = DefaultKeyboardObserver()
    private let notificationObserver = NotificationsObserver()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
    
    override var shouldAutorotate: Bool {
        false
    }
    
    deinit {
        Logger.debug("deinit from \(self)")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActions()
    }
    
    // MARK: - API
    
    func set(content viewController: UIViewController, with context: Context = .default) {
        guard let disappearing = currentController else {
            transitionTo(first: viewController, with: context)
            return
        }
        transition(from: disappearing, to: viewController, with: context)
    }
    
    func set(payerDetails: Domain.Payer) {
        contentView.set(payerDetails: payerDetails)
    }
    
    func set(titleImage: UIImage?) {
        contentView.set(titleImage: titleImage)
    }
    
    func goFullScreen() {
        contentView.set(appearance: .large)
    }
    
    // MARK: - Private
    
    private func setupActions() {
        keyboardObserver.notifyKeyboardChanges(on: contentView)
        
        contentView.appearanceChanged
            .subscribe(onNext: { [weak self] in self?.handleContentViewAppearanceChange(to: $0) })
            .add(to: disposer)
        
        notificationObserver.state
            .subscribe(onNext: { [weak self] state in
                self?.contentView.isUserInteractionEnabled = state == .idle
            })
            .add(to: disposer)
    }
    
    private func handleContentViewAppearanceChange(to appearance: ContentView.Appearance) {
        adjustTopSectionAfterContentViewAppearanceChange(to: appearance)
        notifyAppearanceChange(with: appearance)
    }
    
    private func notifyAppearanceChange(with appearance: ContentView.Appearance) {
        (currentController as? SheetAppearanceAware)?.adjust(for: appearance)
    }
    
    private func adjustTopSectionAfterContentViewAppearanceChange(to appearance: ContentView.Appearance) {
        switch (appearance, currentContext.topSection) {
        case (.large, .languageSwitcher):
            contentView.hideLanguageSwitch()
        case (.large, .payerDetails):
            contentView.hidePayerDetails()
        case (.compact, .languageSwitcher):
            contentView.showLanguageSwitch()
        case (.compact, .payerDetails):
            contentView.showPayerDetails()
        default:
            break
        }
    }
     
    private func transitionTo(first viewController: UIViewController, with context: Context) {
        addChild(viewController)
        contentView.set(content: viewController.view)
        contentView.set(title: viewController.title.value(or: .empty))
        viewController.didMove(toParent: self)
        
        currentController = viewController

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.adjust(for: context)
            self?.currentContext = context
        }
    }
    
    private func transition(from disappearing: UIViewController, to appearing: UIViewController, with context: Context) {
        appearing.willMove(toParent: self)
        disappearing.willMove(toParent: nil)
        
        contentView.set(content: appearing.view)
        contentView.set(title: appearing.title.value(or: .empty))
        appearing.view.alpha = 0
        
        adjust(for: context)
        
        currentController = appearing
        currentContext = context
        
        UIView.animateKeyframes(withDuration: 0.6,
                                delay: 0,
                                animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.33, animations: { disappearing.view.alpha = 0 })
            UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.33, animations: { appearing.view.alpha = 1 })
        },
                                completion: { [weak self] _ in
            disappearing.view.removeFromSuperview()
            disappearing.removeFromParent()
            
            appearing.didMove(toParent: self)
            disappearing.didMove(toParent: nil)
        })
    }
    
    private func adjust(for context: Context) {
        adjust(topSection: context.topSection)
        adjust(appearance: context.appearance)
        contentView.set(isCancellable: context.isCancellable)
    }
    
    private func adjust(topSection: TopSection) {
        guard currentContext.topSection != topSection, contentView.appearance != .large else { return }
        
        switch (currentContext.topSection, topSection) {
        case (.languageSwitcher, .none):
            contentView.hideLanguageSwitch()
        case (.payerDetails, .none):
            contentView.hidePayerDetails()
        case (.none, .languageSwitcher):
            contentView.showLanguageSwitch()
        case (.none, .payerDetails):
            contentView.showPayerDetails()
        case (.payerDetails, .languageSwitcher):
            contentView.hidePayerDetails { [weak self] in self?.contentView.showLanguageSwitch() }
        case (.languageSwitcher, .payerDetails):
            contentView.hideLanguageSwitch { [weak self] in self?.contentView.showPayerDetails() }
        default: break
        }
        
    }
    
    private func adjust(appearance: Appearance) {
        switch appearance {
        case .floating:
            contentView.unlockScroll()
        case .floatingWithInitialAppearance(let appearance):
            contentView.set(appearance: appearance)
            contentView.unlockScroll()
        case .fixed(let appearance):
            contentView.set(appearance: appearance)
            contentView.lockScroll()
        }
    }
}

extension SheetViewController {
    
    struct Context {
        
        // MARK: - Properties
        
        let topSection: TopSection
        let appearance: Appearance
        let isCancellable: Bool
        
        static let `default` = Context(topSection: .none)
        
        // MARK: - Initializers
        
        init(topSection: TopSection, appearance: Appearance = .floating, isCancellable: Bool = true) {
            self.topSection = topSection
            self.appearance = appearance
            self.isCancellable = isCancellable
        }
    }
    
    enum TopSection {
        
        // MARK: - Cases
        
        case none
        case languageSwitcher
        case payerDetails
    }
    
    enum Appearance {
        
        // MARK: - Cases
        
        case floating                                              // sheet panning enabled, appearance will be preserved on transition
        case floatingWithInitialAppearance(ContentView.Appearance) // sheet panning enabled, initial appearance will be adjusted on transition
        case fixed(ContentView.Appearance)                         // sheet panning disabled, appearance will be adjusted on transition
    }
}
