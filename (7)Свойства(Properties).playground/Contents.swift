import Foundation

// Свойства (Properties)
// Связывают значения с конкретным классом/структурой
// (1)Хранимые - запоминают свое значение переменной (Доступны классам/структурам)
// (2)Вычисляемые - рассчитывают значение при каждом обращении (Доступны классам/структурам/перечислениям)

// Инстанс(образец) — экземпляр класса

class DataStore {
    var counter = 0
}

class DataManager {
    // отложенная инициализация
    lazy var dataStore = DataStore() // Когда впервые обратимся к переменной, тогда и будет выполнена инициализация
}

let dataManager = DataManager()
dataManager.dataStore.counter // Обращаемся к переменной DataStore -> Иницизиализируем

// (2)Вычисляемые

class AnothetDataStore {
    var counter: Int { // Вычисляемая переменная
        get {
            return numbers.count
        }
        set(newCounter) { // newValue - default
            numbers = []
            for index in 0...newCounter {
                numbers.append(index)
            }
        }
    }
    
    var numbers: [Int] = [] // Хранимая переменная
}

var anotherDS = AnothetDataStore()
anotherDS.counter = 8 // set
print(anotherDS.counter) // get

// Наблюдатели свойств (property observers) - Обозреватели - willSet & didSet
// Cледят за изменением значений свойств и могут реагировать на эти изменения.

class ExplicitCounter {
    var total: Int = 0 {
        willSet(newTotal) { // newValue
            print("Скоро установится новое значение \(newTotal) == newValue")
        }
        didSet {
            if total > oldValue {
                print("OldValue = \(oldValue), total = \(total)")
                print("Значение изменилось на : \(total - oldValue)")
            }
        }
    }
}

let explicitCounter = ExplicitCounter()
explicitCounter.total = 5
explicitCounter.total = 9
explicitCounter.total = 2

// Свойства типом
// Структура с 2-мя свойствами типов
struct SomeStruct {
    static var storedProperty = 1  // Хранимое свойство
    static var squareProperty: Int { // Вычисляемое свойство зависит от хранимого
        return storedProperty * storedProperty
    }
}
// Класс с 3-мя свойствами типов
class SomeClass {
    static var storedProperty = 2 // Хранимое свойство
    static var square: Int { // Вычисляемое свойство
        return storedProperty * storedProperty
    }
    
    class var overrideProperty: Int { // Вычисляемое свойство с ключем словом class
        // Возможно переопределить при наследовании
        get {
            return storedProperty * storedProperty
        }
        set {
            storedProperty = newValue / 2
        }
    }
}

SomeStruct.storedProperty = 2
print(SomeStruct.storedProperty)

print(SomeClass.overrideProperty) // get
SomeClass.overrideProperty = 10 // set
print(SomeClass.storedProperty) // get
