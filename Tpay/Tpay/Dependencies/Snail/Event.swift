//  Copyright © 2016 Compass. All rights reserved.

import Foundation

enum Event<T> {
    case next(T)
    case error(Error)
    case done
}
