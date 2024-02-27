//
//  Copyright © 2023 Tpay. All rights reserved.
//

struct ChannelDTO {
    
    // MARK: - Properties
    
    let id: String
    let name: String
    let fullName: String
    let imageUrl: String
    let isAvailable: Bool
    let isOnlinePayment: Bool
    let isInstantRedirection: Bool
    let groupId: BankGroupId
    
    let constraints: [Constraint]?
}

extension ChannelDTO: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName
        case image
        case available
        case onlinePayment
        case instantRedirection
        case groups
        case constraints
    }
    
    private enum ImageCodingKeys: String, CodingKey {
        case url
    }
    
    private struct NestedBankGroup: Decodable {
        let id: BankGroupId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        fullName = try container.decode(String.self, forKey: .fullName)
        
        let imageContainer = try container.nestedContainer(keyedBy: ImageCodingKeys.self, forKey: .image)
        imageUrl = try imageContainer.decode(String.self, forKey: .url)
        
        isAvailable = try container.decode(Bool.self, forKey: .available)
        isOnlinePayment = try container.decode(Bool.self, forKey: .onlinePayment)
        isInstantRedirection = try container.decode(Bool.self, forKey: .instantRedirection)
        
        let groups = try container.decode([NestedBankGroup].self, forKey: .groups)
        groupId = groups.first?.id ?? .unknown
        
        constraints = try? container.decode([Constraint].self, forKey: .constraints)
    }
}
