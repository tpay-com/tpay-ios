//
//  Copyright © 2022 Tpay. All rights reserved.
//

enum BankGroupId: String, Codable {
    
    // MARK: - Cases
    
    case card = "103"
    case blik = "150"
    case googlePay = "166"
    case payPal = "106"
    case applePay = "170"
    case ratyPekao = "169"
    case payPo = "172"
    
    case alior = "113"
    case pekao = "102"
    case pko = "108"
    case inteligo = "110"
    case mBank = "160"
    case ing = "111"
    case millennium = "114"
    case santander = "115"
    case citibank = "132"
    case creditAgricole = "116"
    case velo = "119"
    case pocztowy = "124"
    case bankiSpoldzielcze = "135"
    case bnpParibas = "133"
    case neo = "159"
    case nest = "130"
    case plus = "145"
    
    case unknown = "-1"
    
    // MARK: - Decodable
    
    init(from decoder: Decoder) throws {
        self = try .init(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
