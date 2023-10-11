//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension ScreenManager {
 
    func presentNoCameraAccessDialog() {
        let screen = NoCameraAccessScreen()
        presentModally(screen)
    }
    
}
