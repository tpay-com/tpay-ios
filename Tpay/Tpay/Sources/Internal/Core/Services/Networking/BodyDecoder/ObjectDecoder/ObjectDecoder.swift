//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol ObjectDecoder {
    
    // MARK: - API
    
    func decode<ResultType: Decodable>(_ type: ResultType.Type, from: Data) throws -> ResultType
}
