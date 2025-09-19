//
//  Copyright © 2022 Tpay. All rights reserved.
//

/// Dependency container for value converters
final class Converters {
    
    // MARK: - Static properties
        
    static var dateToDate: DateToDateConverter { instance.dateToDate }
    static var dateToServiceString: DateToServiceStringConverter { instance.dateToServiceString }
    static var dateToString: DateToStringConverter { instance.dateToString }
    
    static var timeIntervalToString: TimeIntervalToStringConverter { instance.timeIntervalToString }
    
    static var decimalToString: DecimalToStringConverter { instance.decimalToString }
    static var doubleToString: DoubleToStringConverter { instance.doubleToString }
    static var integerToString: IntegerToStringConverter { instance.integerToString }
    
    static var numberToServiceString: NumberToServiceString { instance.numberToServiceString }
    
    static var stringToDate: StringToDateConverter { instance.stringToDate }
    
    static var personNameComponentsToString: PersonNameComponentsToStringConverter { instance.personNameComponentsToString }
    
    // MARK: - Properties
    
    private lazy var dateToDate = DefaultDateToDateConverter()
    private lazy var dateToServiceString = DefaultDateToServiceStringConverter()
    private lazy var dateToString = DefaultDateToStringConverter()
    
    private lazy var timeIntervalToString = DefaultTimeIntervalToStringConverter()
    
    private lazy var decimalToString = DefaultDecimalToStringConverter()
    private lazy var doubleToString = DefaultDoubleToStringConverter()
    private lazy var integerToString = DefaultIntegerToStringConverter()
    
    private lazy var numberToServiceString = DefaultNumberToServiceString()
    
    private lazy var stringToDate = DefaultStringToDateConverter()
    
    private lazy var personNameComponentsToString = DefaultPersonNameComponentsToStringConverter()
        
    private static let instance = Converters()
    
    // MARK: - Initializers
    
    private init() { }
    
}
