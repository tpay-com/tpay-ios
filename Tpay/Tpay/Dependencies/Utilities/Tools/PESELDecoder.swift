//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

final class PESELDecoder {
    
    // MARK: - Properties
    
    private let calendar: Calendar
    private let weights = [1, 3, 7, 9, 1, 3, 7, 9, 1, 3]
    
    // MARK: - Lifecycle
    
    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }
    
    // MARK: - API
    
    func birthDate(from string: String) -> Date? {
        guard validate(input: string) else { return nil }
        
        var components = DateComponents()
        components.year = calculateBirthYear(from: string)
        components.month = calculateBirthMonth(from: string)
        components.day = calculateBirthDay(from: string)
        
        return calendar.date(from: components)
    }
    
    func validate(input string: String) -> Bool {
        string.count == 11 && string.map(String.init).map(Int.init).compacted().count == 11
    }
    
    func controlValue(from string: String) -> Int? {
        guard validate(input: string) else { return nil }
        return values(from: string).last
    }
    
    func checkSum(from string: String) -> Int? {
        guard validate(input: string) else { return nil }
        let restOfDivision = zip(weights, values(from: string)).map(*).reduce(0, +) % 10
        return restOfDivision == 0 ? restOfDivision : 10 - restOfDivision
    }
    
    // MARK: - Methods
    
    private func values(from string: String) -> [Int] {
        string.map(String.init).map(Int.init).compacted()
    }
    
    private func calculateBirthYear(from string: String) -> Int? {
        guard validate(input: string) else { return nil }
    
        let values = self.values(from: string)
    
        let year = values[0] * 10 + values[1]
        let month = values[2] * 10 + values[3]
        
        switch month {
        case 1 ..< 13: return year + 1_900
        case 21 ..< 33: return year + 2_000
        case 41 ..< 53: return year + 2_100
        case 61 ..< 73: return year + 2_200
        case 81 ..< 93: return year + 1_800
        default: return year
        }
        
    }
    
    private func calculateBirthMonth(from string: String) -> Int? {
        guard validate(input: string) else { return nil }
        
        let values = self.values(from: string)
        
        let value = values[2] * 10 + values[3]
        
        switch value {
        case 21 ..< 33: return value - 20
        case 41 ..< 53: return value - 40
        case 61 ..< 73: return value - 60
        case 81 ..< 93: return value - 80
        default: return value
        }
    }
    
    private func calculateBirthDay(from string: String) -> Int? {
        guard validate(input: string) else { return nil }
        
        let values = self.values(from: string)
        
        return values[4] * 10 + values[5]
    }
    
}
