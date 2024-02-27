//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class DefaultTransportationToDomainModelsMapper_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private let sut = DefaultTransportationToDomainModelsMapper()
    
    // MARK: - Tests
    
    func test_PaymentMethodFromDTO() {
        let card = BankGroupDTO(id: "103")
        expect(self.sut.makePaymentMethod(from: card)) == .card
        
        let blik = BankGroupDTO(id: "150")
        expect(self.sut.makePaymentMethod(from: blik)) == .blik
        
        let googlePay = BankGroupDTO(id: "166")
        expect(self.sut.makePaymentMethod(from: googlePay)) == .digitalWallet(.init(id: "166",
                                                                                    kind: .googlePay,
                                                                                    name: .empty,
                                                                                    imageUrl: nil))
        
        let bank1 = BankGroupDTO(id: "113")
        expect(self.sut.makePaymentMethod(from: bank1).isPbl) == true
        
        let bank2 = BankGroupDTO(id: "102")
        expect(self.sut.makePaymentMethod(from: bank2).isPbl) == true
        
        let bank3 = BankGroupDTO(id: "108")
        expect(self.sut.makePaymentMethod(from: bank3).isPbl) == true
        
        let bank4 = BankGroupDTO(id: "110")
        expect(self.sut.makePaymentMethod(from: bank4).isPbl) == true
        
        let bank5 = BankGroupDTO(id: "160")
        expect(self.sut.makePaymentMethod(from: bank5).isPbl) == true
        
        let bank6 = BankGroupDTO(id: "111")
        expect(self.sut.makePaymentMethod(from: bank6).isPbl) == true
        
        let bank7 = BankGroupDTO(id: "114")
        expect(self.sut.makePaymentMethod(from: bank7).isPbl) == true
        
        let bank8 = BankGroupDTO(id: "115")
        expect(self.sut.makePaymentMethod(from: bank8).isPbl) == true
        
        let bank9 = BankGroupDTO(id: "132")
        expect(self.sut.makePaymentMethod(from: bank9).isPbl) == true
        
        let bank10 = BankGroupDTO(id: "116")
        expect(self.sut.makePaymentMethod(from: bank10).isPbl) == true
        
        let bank11 = BankGroupDTO(id: "119")
        expect(self.sut.makePaymentMethod(from: bank11).isPbl) == true
        
        let bank12 = BankGroupDTO(id: "124")
        expect(self.sut.makePaymentMethod(from: bank12).isPbl) == true
        
        let bank13 = BankGroupDTO(id: "135")
        expect(self.sut.makePaymentMethod(from: bank13).isPbl) == true
        
        let bank14 = BankGroupDTO(id: "133")
        expect(self.sut.makePaymentMethod(from: bank14).isPbl) == true
        
        let bank15 = BankGroupDTO(id: "159")
        expect(self.sut.makePaymentMethod(from: bank15).isPbl) == true
        
        let bank16 = BankGroupDTO(id: "130")
        expect(self.sut.makePaymentMethod(from: bank16).isPbl) == true
        
        let bank17 = BankGroupDTO(id: "145")
        expect(self.sut.makePaymentMethod(from: bank17).isPbl) == true
        
        let unknown = BankGroupDTO(id: "999")
        expect(self.sut.makePaymentMethod(from: unknown)) == .unknown
    }
    
    func test_PaymentChannelFromDTO() {
        
    }
}

private extension BankGroupDTO {

    init(id: String) {
        self.init(id: BankGroupId(rawValue: id) ?? .unknown, name: .empty, img: .empty)
    }
}

private extension Domain.PaymentMethod {
    
    var isPbl: Bool {
        switch self {
        case .pbl: return true
        default: return false
        }
    }
}
