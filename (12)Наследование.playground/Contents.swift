import UIKit

// Наследование
// Базовый/Родительский(суперкласс) от него наследуется подкласс(сабкласс) дочерний


class Animal {
    var weight = 0.0
    var description: String {
        return "weight is : \(weight)"
    }
    
    func makeSound() {
        print("Default animal sound")
    }
}

let animal = Animal() // Инстанс/Объект класса
print(animal.description)

// Наследование, определение нового класса на основе существуещего
class Dog : Animal {
    var color = UIColor.red
}

let dog = Dog()
dog.weight = 10.0 // Получает характеристики от родительского класса
dog.color = UIColor.yellow
print(dog.description)

// Подкласс может определять собственную реализацию для методов и переменных
class Cat: Animal {
    override func makeSound() { // override/переопределение
//        super.makeSound()  // Доступ к базовой реализации метода super.
        print("meooow")
    }
}
let cat = Cat()
cat.makeSound()

// Переопределение свойства позволяет написать собственные сеттеры и геттеры свойств
class EnglishDog: Dog {
    override var description: String {
        get {
            return "weight in pounds : \(weight * 2.2)"
        }
    }
}

let bulldog = EnglishDog()
bulldog.weight = 5
print(bulldog.description)


// Переопределение свойства для создания собственных обозревателей
class LimitEnglishDog: EnglishDog {
    var weightLimit: Double?
    
    override var weight: Double {
        didSet {
            if let limit = weightLimit, (weight > limit) {
                print("Слишком большой вес (\(weight))! Лимит = \(limit)")
                print("Последний вес = \(oldValue)")
                weight = oldValue
            }
        }
    }
}

let bloodhound = LimitEnglishDog() // ищейка/сыщик
bloodhound.weightLimit = 120
bloodhound.weight = 60 // good
bloodhound.weight = 150 // limit !

//

class DontOverrideMyProperties {
    // final для ограничение переопределения свойств
    final var description: String {
        return "Лучшее описание"
    }
}

class IDontReadClassName : DontOverrideMyProperties {
//    override var description: String {
//        return "Тут какая-то ошибка"
//    }
}

// Инициализация классов
// (1) Designated/Назначенный initializer - основной инициализатор класса, должен присутствовать минимум 1 такой инициализатор
// - выставляет начальные значения всем свойствам, вызывает конструктор родительского класса, чтобы он выставил значения своим полям (Вертикальная цепочка инициализаторов)

// (2) Convenience/Удобный initializer - основной инициализатор класса (Дополнительный)
// Вызывают либо основной, либо вспомогательный конструктор (Горизонтальная цепочка инициализаторов)

class MyClass {
    var intProperty: Int
    
    init(intProperty: Int) {
        self.intProperty = intProperty
    }
    
    convenience init() {
        self.init(intProperty: 4)
    }
}

// Convenience инициализатор

struct FuelTank { // Топливный бак
    let fuelConsumption: Float // Расход топлива
    let fuelЕankСapacity: Float // Емкость топливного бака
}

class Vehicle {
    let fuelTank: FuelTank
    
    init(fuelTank: FuelTank) {
        self.fuelTank = fuelTank // Принимает структуру в качестве параметра для инициализации
    }
}

extension Vehicle {
    // Инициализатор, который будет самостоятельно создавать структуры из переданных параметров и вызывать Designated инициализтаор
    convenience init(fuelConsumption: Float, fuelЕankСapacity: Float) {
        self.init(fuelTank: FuelTank(fuelConsumption: fuelConsumption, fuelЕankСapacity: fuelЕankСapacity))
    }
}

// Инициализаторы в подклассах

class MySubClass: MyClass {
    var doubleProperty: Double
    
    convenience init() { // Convenience
        self.init(intProperty: 5)
    }
    
    override init(intProperty: Int) { // Designated
        doubleProperty = 6
        super.init(intProperty: intProperty)
    }
}

// Переопределение Failable/Неудачного инициализатора

class A {
    init?() {} // Failable инициализатор
}

class B: A {
    override init() {
        super.init()! // переопределить как обычный + force unwrap
    }
}

class C: A {
    override init?() {} // переопределить как failable
}

// Required/Необходимые инициализаторы
// Наследникам нужно обязательно предоставить required конструктор

class D {
    required init(someValue: Int) {} // Дочерним классам нужно обязательно предоставить реализацию этого инициализатора
}

class E: D {
    required init(someValue: Int)  {
        super.init(someValue: someValue)
    }
}

// Extensions - расширения, добавляют функционал для существующего класса, структуры, enum или протокола
// Могут добавлять : вычисляемые свойства / новые методы / сабскрипты / поддержку протоколов / создавать иниты / определять и использовать вложенные типы

//extension тип: протокол1, протокол2 {
//    код
//}

// 1 - Добавляют вычисляемые свойства для существующих типов
extension String {
    var upperCaseDescription: String { // Новое свойства для типа String
        return "Upper case : " + self.uppercased() // Новый функционал
    }
}
print("Hello world".upperCaseDescription)

// 2 - Добавляют новые инициализаторы
extension String {
    init(left: String, right: String) {
        self = left + ", " + right
    }
}

let helloWorld = String.init(left: "hello", right: "world :)")
print(helloWorld)

// 3 - Создание инициализатора в extension
struct Display {
    var width:      Float = 0.0
    var ppi:        Float = 0.0
    var resolution: Float = 0.0
}

extension Display {
    init(width: Float, resolution: Float) {
        let ppi = resolution / width
        self.init(width: width, ppi: ppi, resolution: resolution)
    }
}

let display = Display(width: 15.0, resolution: 1920)
print("PPI : ", display.ppi)

// 4 - Добавляют новые методы
extension String {
    func makeMePickle() {
        print("I am pickle", self)
    }
    
    mutating func doubleString() { // метод mutating - изменяет self
        self = self + " — " + self
    }
}

var name = "Rick"
name.doubleString()
name.makeMePickle()

// 5 - Добавляют subscript/индекс
extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}

print(123456[2])

// 6 - Определяет и использует вложенные типы
struct MyDisplay {
    var width   = 0.0
    var height  = 0.0
    var ppi     = 0.0
}

extension MyDisplay {
    struct Resolution {
        var horizontal = 0.0
        var vertical = 0.0
    }
    
    var resolution: Resolution {
        return Resolution(horizontal: width * ppi, vertical: height * ppi)
    }
}

var resolution = MyDisplay.Resolution(horizontal: 1920, vertical: 1080)
var myDisplay = MyDisplay(width: 16, height: 9, ppi: 320.0)
print(myDisplay.resolution)

// ----------------- //
// Практическое применение extension, группировка в private extension
private extension MyDisplay {
    func diagonalSize() -> Double {
        return sqrt(width * width + height * height)
    }
}

var display1 = MyDisplay(width: 16, height: 8, ppi: 320)
print("diagonal size : \(display1.diagonalSize())")


// ----------------- //
// Контроль доступа - помогает скрыть детали реализации типа
/*
Уровни доступа (5) :
 — Open, Public - позволяют обращаться к сущностям из любого модуля ( - это код, входящий в состав фреймоврка или приложения, может быть добавлен в проект с помощью import )
 (1) Open - может использоваться только классами и членами классов, но позволяет наследоваться и выполнять переопределение модулю, который импортировал наш код
 (2) Public - позволяет использовать наследование и переопределение только внутри модуля, в котором они объявлены
 (3) Internal (По умолчанию) - дает возможность работать с сущностями в рамках существующего модуля
 (4) File-private - ограничивает доступ рамками текущего файла (В рамках одного файла)
 (5) Private - позволяет работать с сущностями внутри определяющего их блока
*/

public class PublicClass {
    var internalProperty = "" // internal свойство
    private var privateProperty = "" // private свойство
    public func publicMethod() {} // publuc метод
    fileprivate func filePrivateMethod() {} // file-private метод
}



