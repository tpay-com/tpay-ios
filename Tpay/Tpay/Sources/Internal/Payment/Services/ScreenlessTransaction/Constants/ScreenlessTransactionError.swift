//
// Copyright (c) 2022 Tpay. All rights reserved.
//

enum ScreenlessTransactionError: Error {
    
    // MARK: - Cases
    
    case incorrectUrl
    case incorrectCardData
    case incorrectBlikData
    case unknownDigitalWallet
    case unknownPaymentMethod
}
