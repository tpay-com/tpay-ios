//
//  Copyright © 2024 Tpay. All rights reserved.
//

extension Domain {
    
    typealias ChannelId = String
    
    struct PaymentChannel {
        
        // MARK: - Properties
        
        let id: ChannelId
        let name: String
        let fullName: String
        let imageUrl: URL?
        let associatedGroupId: BankGroupId
        let constraints: [Constraint]?
        
        // MARK: - Getters
        
        var amountConstraints: [AmountConstraint] {
            constraints?.compactMap { Helpers.makeAmountConstraint(from: $0) } ?? []
        }
    }
}

private extension Domain.PaymentChannel {
    
    enum Helpers {
        
        static func makeAmountConstraint(from constraint: Domain.PaymentChannel.Constraint) -> AmountConstraint? {
            guard constraint.field == .amount else {
                return nil
            }
            switch (constraint.type, Double(constraint.value)) {
            case (.min, .some(let minValue)):
                return Domain.PaymentChannel.MinAmountConstraint(minValue: minValue)
            case (.max, .some(let maxValue)):
                return Domain.PaymentChannel.MaxAmountConstraint(maxValue: maxValue)
            default:
                return nil
            }
        }
    }
}

extension Domain.PaymentChannel {
    
    struct Constraint: Decodable {
        
        let field: Field
        let type: ConstraintType
        let value: String
    }
}

extension Domain.PaymentChannel.Constraint {
    
    enum Field: String, Decodable {
        
        case amount
        
        case applePaySession = "ApplePaySession"
    }
    
    enum ConstraintType: String, Decodable {
        
        case min
        case max
        
        case isSupported = "supported"
    }
}
