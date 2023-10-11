//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultBodyEncoder: BodyEncoder {
    
    // MARK: - Properties
    
    private let jsonEncoder: ObjectEncoder
    
    // MARK: - Lifecycle
    
    init(jsonEncoder: ObjectEncoder) {
        self.jsonEncoder = jsonEncoder
    }
    
    // MARK: - API
    
    func body<ObjectType>(from object: ObjectType, for resource: NetworkResource) -> Data? where ObjectType: Encodable {
        guard resource.method != .get else { return nil }
        
        switch resource.contentType {
        case .none: return nil
        case .json: return json(from: object)
        }
    }
    
    // MARK: - Private
    
    private func json<ObjectType: Encodable>(from object: ObjectType) -> Data? {
        do {
            return try jsonEncoder.encode(object)
        } catch {
            assertionFailure("Cannot encode \(object) using json encoder!")
            return nil
        }
    }
}
