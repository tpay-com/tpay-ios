//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension TransactionsController.Channels {

    struct Response: Decodable {
        
        let channels: [ChannelDTO]
        
        // MARK: - Initializers
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            channels = try container.decode([ChannelDTO].self, forKey: .channels)
        }
    }
}

extension TransactionsController.Channels.Response {
    
    private enum CodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case channels
    }
}
