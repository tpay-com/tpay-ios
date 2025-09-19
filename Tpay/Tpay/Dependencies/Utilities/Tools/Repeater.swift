//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

final class Repeater {
    
    // MARK: - Properties
    
    var timeInterval: DispatchTimeInterval {
        willSet { cleanUp() }
        didSet {
            invalidate()
            start()
        }
    }
    
    private let cache: NSMapTable<AnyObject, ClosureContainer> = NSMapTable.weakToStrongObjects()
    
    private var state: State = .suspended
    
    private lazy var timer: DispatchSourceTimer = createTimer()
    
    // MARK: - Lifecycle
    
    convenience init() {
        self.init(timeInterval: .seconds(1))
    }
    
    init(timeInterval: DispatchTimeInterval) {
        self.timeInterval = timeInterval
    }
    
    deinit {
        cleanUp()
    }
    
    // MARK: - API
    
    func start() {
        guard state != .running else { return }
        state = .running
        timer.resume()
    }
    
    func suspend() {
        guard state != .suspended else { return }
        state = .suspended
        timer.suspend()
    }
    
    func notify<Observer: AnyObject>(on observer: Observer, fire: @escaping (Observer) -> Void) {
        let container = ClosureContainer { [weak observer] in
            if let strongObserver = observer { fire(strongObserver) }
        }
        cache.setObject(container, forKey: observer)
    }
    
    func remove<Observer: AnyObject>(observer: Observer) {
        cache.removeObject(forKey: observer)
    }
    
    // MARK: - Methods
    
    private func cleanUp() {
        timer.setEventHandler {}
        timer.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
         */
        start()
    }
    
    private func invalidate() {
        cleanUp()
        state = .suspended
        timer = createTimer()
    }
    
    // MARK: - Factory methods
    
    private func createTimer() -> DispatchSourceTimer {
        let timer = DispatchSource.makeTimerSource(queue: .main)
        timer.schedule(deadline: .now() + timeInterval, repeating: timeInterval, leeway: .microseconds(500))
        timer.setEventHandler { [weak self] in self?.fire() }
        return timer
    }
    
    // MARK: - Actions
    
    private func fire() {
        cache.objectEnumerator()?.allObjects.compactMap { object in object as? ClosureContainer }.forEach { container in container.closure() }
    }
    
}

extension Repeater {
    
    private enum State {
        
        case suspended
        case running
        
    }
    
}

extension Repeater {
    
    private final class ClosureContainer {
        
        // MARK: - Properties
        
        let closure: () -> Void
        
        // MARK: - Initializers
        
        init(closure: @escaping () -> Void) {
            self.closure = closure
        }
        
    }
    
}
