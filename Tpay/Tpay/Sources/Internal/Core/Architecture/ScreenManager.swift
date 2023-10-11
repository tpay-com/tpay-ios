//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit
    
final class ScreenManager {
    
    // MARK: - Properties
    
    let presenter: ViewControllerPresenter
    
    private var currentlyDisplayedScreens: [Screen] = []
    
    // MARK: - Initializers
    
    init(presenter: ViewControllerPresenter) {
        self.presenter = presenter
    }
    
    // MARK: - API
    
    func push(_ screen: Screen, then: (() -> Void)? = nil) {
        currentlyDisplayedScreens.append(screen)
        presenter.push(screen.viewController, then: then) { [weak self] in
            self?.remove(screen)
        }
    }
    
    func presentFullScreen(_ screen: Screen) {
        currentlyDisplayedScreens.append(screen)
        presenter.presentFullScreen(screen.viewController)
    }
    
    func presentPageSheet(_ screen: Screen) {
        currentlyDisplayedScreens.append(screen)
        presenter.presentPageSheet(screen.viewController)
    }
    
    func presentModally(_ screen: Screen) {
        currentlyDisplayedScreens.append(screen)
        presenter.presentModally(screen.viewController)
    }
    
    func show(_ screen: Screen) {
        currentlyDisplayedScreens.append(screen)
        presenter.show(screen.viewController)
        currentlyDisplayedScreens.removeFirst(currentlyDisplayedScreens.count - 1)
    }
    
    func popAll() {
        if let topScreen = currentlyDisplayedScreens.last {
            removePredecessor(of: topScreen)
            pop(topScreen)
        }
    }
    
    func pop(_ screen: Screen) {
        if currentlyDisplayedScreens.last === screen {
            presenter.pop()
            remove(screen)
        }
    }
    
    func pop(to screen: Screen) {
        presenter.pop(to: screen.viewController)
    }
    
    func dismiss(_ screen: Screen) {
        screen.viewController.dismiss(animated: true) { [weak self] in
            self?.remove(screen)
        }
    }
    
    func removePredecessor(of screen: Screen) {
        if let index = currentlyDisplayedScreens.lastIndex(where: { item in item === screen }) {
            currentlyDisplayedScreens.prefix(upTo: index).map(\.viewController).forEach(presenter.removeFromStack(_:))
            currentlyDisplayedScreens.removeFirst(index)
        }
    }
    
    // MARK: - Private
    
    private func remove(_ screen: Screen) {
        if let index = currentlyDisplayedScreens.lastIndex(where: { item in item === screen }) {
            currentlyDisplayedScreens.remove(at: index)
        }
    }
    
    private func removeSuccessors(of screen: Screen) {
        if let index = currentlyDisplayedScreens.lastIndex(where: { item in item === screen }) {
            currentlyDisplayedScreens.removeLast(currentlyDisplayedScreens.count - index + 1)
        }
    }
    
}
