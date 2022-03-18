import UIKit

// Протоколы // Protocols - список требований
// Может быть в классе/структуре и перечислении

protocol MyProtocol {
}

struct MyStruct : MyProtocol {
}

protocol MyProtocolWithProperties {
    var setProperty: Int { set get }
    var getProperty: Double { get }
}

struct MyStructWithProperties: MyProtocolWithProperties {
    private var storage: Int = 10
    var setProperty: Int {
        get {
            return storage
        }
        set {
            storage = newValue
        }
    }
    var getProperty: Double
    
    init(getProperty: Double) {
        self.getProperty = getProperty
    }
}

protocol MyProtocolWithProperty {
    static var typeProperty: Int { get } // Требования для самих типов // static
}

protocol MyProtocolWithMethods { // Требования к методам
    mutating func instanceMethod(parameter: Int) // B
    static func typeMethod() -> Double
}

struct MyStructWithPropertyAndMethods : MyProtocolWithProperties , MyProtocolWithMethods{
    var setProperty: Int
    var getProperty: Double
    
    var count: Double
    static var typeProperty = 10
    
    mutating func instanceMethod(parameter: Int) {
        count = Double(parameter)
    }
    
    static func typeMethod() -> Double {
        return 5.44
    }
}

// Наличие инициализатора в протоколе

protocol MyProtocolWithInit {
    init(parameter: Int) // наследние должен будет написать required - требуется
}

class MyClassWithInit: MyProtocolWithInit {
    let someValue: Int
    
    required init(parameter: Int) { // чтобы все наследники предоставили собственную реализацию
        someValue = parameter
    }
}

var someProtocol: MyProtocolWithProperties = MyStructWithProperties(getProperty: 4.21)

// Класс, который обрабатывает массив строк
protocol StringProcessorDelegate {
    var concatenateSeparator: String { get }
    
    func transform(_ str: String) -> String
}

class StringProcessor {
    var delegate: StringProcessorDelegate?
    
    func process(_ str: [String]) -> String {
        guard str.count > 0, let delegate = delegate else { return "" }
        
        var temp: [String] = []
        for s in str {
            let t = delegate.transform(s)
            temp.append(t)
        }
        
        return temp.joined(separator: delegate.concatenateSeparator )
    }
}

// Композиция - это объединение нескольких протоколов в один тип (экзистенциальные типы / existential types)

let compoundObject: MyProtocolWithProperties & MyProtocolWithMethods
compoundObject = MyStructWithPropertyAndMethods(setProperty: 10, getProperty: 44.6, count: 32.6)
