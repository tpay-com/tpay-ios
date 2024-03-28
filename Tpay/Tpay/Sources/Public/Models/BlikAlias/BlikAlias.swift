//
//  Copyright © 2022 Tpay. All rights reserved.
//

/// The `BlikAlias` struct represents a BLIK alias. It could serve wether as an alias to be registered during a regular BLIK payment, or as an already registered alias for a BLIK OneClick payment.

public struct BlikAlias<RegistrationStatus>: Equatable {
    
    // MARK: - Properties
    
    let value: Value
    
    // MARK: - Initializers
    
    public init(value: Value) {
        self.value = value
    }
}

public protocol AliasRegistrationStatus { }

@_documentation(visibility: internal)
public enum Registered: AliasRegistrationStatus { }

@_documentation(visibility: internal)
public enum NotRegistered: AliasRegistrationStatus { }

/// Represents an already registered BLIK alias in the system.

public typealias RegisteredBlikAlias = BlikAlias<Registered>

/// Represents a BLIK alias to be registered during a standard BLIK transaction (payment via BLIK code).

public typealias NotRegisteredBlikAlias = BlikAlias<NotRegistered>
