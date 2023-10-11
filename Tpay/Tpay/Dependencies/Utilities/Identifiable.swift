//
//  Copyright © 2022 Tpay. All rights reserved.
//

/// Allows identify object by providing id field
///
/// ToDo:
///  After setting minimal SDK to iOS 13 this protocol can be remove
protocol Identifiable {

    /// A type representing the stable identity of the entity associated with `self`.
    associatedtype ID: Hashable

    /// The stable identity of the entity associated with `self`.
    var id: Self.ID { get }
    
}
