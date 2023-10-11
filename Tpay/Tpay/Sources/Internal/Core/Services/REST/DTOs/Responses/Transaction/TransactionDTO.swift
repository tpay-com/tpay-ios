//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class TransactionDTO: ResponseDTO {
    
    // MARK: - Properties
    
    let transactionId: String
    let title: String
    let posId: String
    let status: TransactionStatus
    let dates: TransactionDatesDTO
    
    let amount: Double
    let currency: Currency
    
    let description: String?
    let hiddenDescription: String?
    
    let transactionPaymentUrl: String?
    
    let payments: Payments?
    
    // MARK: - Initializers
        
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        transactionId = try container.decode(String.self, forKey: .transactionId)
        title = try container.decode(String.self, forKey: .title)
        posId = try container.decode(String.self, forKey: .posId)
        status = try container.decode(TransactionStatus.self, forKey: .status)
        dates = try container.decode(TransactionDatesDTO.self, forKey: .date)
        
        amount = try container.decode(Double.self, forKey: .amount)
        currency = try container.decode(Currency.self, forKey: .currency)
        
        description = try container.decode(String.self, forKey: .description)
        hiddenDescription = try container.decode(String.self, forKey: .hiddenDescription)
        
        transactionPaymentUrl = try? container.decode(String.self, forKey: .transactionPaymentUrl)

        payments = try container.decodeIfPresent(Payments.self, forKey: .payments)
        
        try super.init(from: decoder)
    }
}

extension TransactionDTO {
    
    private enum CodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case transactionId
        case title
        case posId
        case status
        case date
        
        case amount
        case currency
        
        case description
        case hiddenDescription
        
        case transactionPaymentUrl
        
        case payments
    }
    
}
