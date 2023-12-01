//
// Copyright (c) 2022 Tpay. All rights reserved.
//

extension PaymentData {

    public struct Bank: Equatable {
        
        // MARK: - Properties
        
        public let id: String
        public let name: String
        public let imageUrl: URL?
        
        // MARK: - Initializers
        
        public init(id: String, name: String, imageUrl: URL?) {
            self.id = id
            self.name = name
            self.imageUrl = imageUrl
        }
    }
}
