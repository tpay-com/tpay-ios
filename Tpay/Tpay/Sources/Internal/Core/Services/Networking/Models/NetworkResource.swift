//
//  Copyright © 2022 Tpay. All rights reserved.
//

struct NetworkResource {
    
    // MARK: - Properties
    
    let url: URL
    let method: HttpMethod
    let contentType: ContentType
    let authorization: Authorization
    
    let queryParameters: Encodable?
    
    // MARK: - Initializers
    
    init(url: URL, method: HttpMethod = .post, contentType: ContentType = .json, authorization: Authorization = .bearer, queryParameters: Encodable? = nil) {
        self.url = url
        self.method = method
        self.contentType = contentType
        self.authorization = authorization
        self.queryParameters = queryParameters
    }
}

extension NetworkResource: Encodable {
    
    func encode(to encoder: Encoder) throws { }
}
