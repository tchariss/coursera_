import UIKit

struct Resolution { // значимый тип // копируется
    // небольшие значения
    var width = 0
    var height = 0
}

class VideoMode { // ссылочный тип // при присвоении значения не копируются, а передается ссылка
    // меньше памяти занимает
    // Наследование, жизненный циклб элементы интерфейса , отображаемые на экране
    var resolution = Resolution()
    var interlaced = false
    var opt: Int?
}

// ===   ->  идентичность, 2 объекта ссылаются ли на тот же экземпляр

// Создание экземпляра
let someResolution = Resolution()



// Enum

enum Compass { // значимый тип
    case north, south, east, west
}

var direction = Compass.east

enum ColorCode {
    case Color(UIColor)
    case RGB(Int, Int, Int)
    case name(String)
}

var webColor = ColorCode.RGB(0, 0, 128)

switch webColor {
case let .Color(color):
    print("Color: \(color)")
case .RGB(let red, let green, let blue):
    print("RGB: \(red), \(green), \(blue)")
case let .name(colorName):
    print("Color is: \(colorName)")
}

// RAW Values - необработанные значения
// В момент перечисления обозначается
enum ASCIIChar: Character {
    case tab = "\t"
    case lineFedd = "\n"
}

// Associated Values - необработанные значения
// В момент создания константы

enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter
}

let possiblePlanet = Planet(rawValue: 2)
//guard let possiblePlanet1 = Planet(rawValue: 33) else { return }
let eatherOrder = Planet.earth.rawValue


enum arihm {
    case number(Int)
    indirect case addition(arihm, arihm) 
    indirect case multiplication(arihm, arihm)
}
