//
//  Copyright © 2026 Tpay. All rights reserved.
//

/// Concrete container for the three protocol-typed validators used by `DefaultNetworkingService`.
///
/// Background (TPS-55, follow-up to TPS-50 v1/v2):
/// Production crashes on `com.tpay.networking` showed nested `block_destroy_helper` chains
/// terminating in destruction of boxed opaque existentials. The v2 fix moved the destruction
/// onto a serial queue but the closures dispatched on that queue still captured three
/// protocol-typed values (`ErrorValidator`, `ResponseValidator`, `BodyDecoder`), each held
/// inside its own boxed existential. Concurrent destruction of those boxes across
/// URLSession's release thread and `com.tpay.networking` kept reproducing the crash.
///
/// Wrapping the three validators inside a single concrete class means closures capture
/// one class reference instead of three boxed existentials. Block destruction collapses
/// to a single atomic `swift_release` — no value-witness destroy of opaque boxes.
final class NetworkingValidators {

    let errorValidator: ErrorValidator
    let responseValidator: ResponseValidator
    let bodyDecoder: BodyDecoder

    init(errorValidator: ErrorValidator,
         responseValidator: ResponseValidator,
         bodyDecoder: BodyDecoder) {
        self.errorValidator = errorValidator
        self.responseValidator = responseValidator
        self.bodyDecoder = bodyDecoder
    }
}
