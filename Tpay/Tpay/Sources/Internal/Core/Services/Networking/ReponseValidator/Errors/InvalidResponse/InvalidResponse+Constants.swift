//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension InvalidResponse {
    
    static let lackDataInResponseBody = InvalidResponse(reason: "Lack of data in response body")
    static let undecodableResponseBody = InvalidResponse(reason: "Response body cannot be decoded")
}
