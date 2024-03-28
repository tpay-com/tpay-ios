//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation

protocol DomainToAPIModelsMapper: AnyObject {
    
    // MARK: - API
    
    func makeHeadlessModelsPaymentChannel(from domainPaymentChannel: Domain.PaymentChannel) throws -> Headless.Models.PaymentChannel
    func makeHeadlessModelsPaymentResult(from domainOngoingTransaction: Domain.OngoingTransaction) -> Headless.Models.PaymentResult
}
