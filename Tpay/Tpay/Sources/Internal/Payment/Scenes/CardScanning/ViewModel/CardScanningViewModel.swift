//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol CardScanningViewModel: AnyObject {
    
    // MARK: - API
    
    func close()
    func creditCardScanned(data: CardNumberDetectionModels.CreditCard)
}
