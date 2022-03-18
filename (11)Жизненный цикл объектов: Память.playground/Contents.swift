import UIKit

// Жизненный цикл объектов (init/deinit)
// Инициализатор(Конструктор) / Деинициализатор(Деструктор)

class View {
    var height, width: Float
    
    // Инициализатор - процесс подготовки класса, структуры к использованию
    // - Выставление начальных значений свойствам объекта
    init() {
        height = 0
        width = 0
    }
    
    // Деинициализатор (Для классов) - вызвается перед уничтожением объекта, освобождение ресурсов
    deinit {
        print("Уничтожение объекта")
    }
}

// memberwise инициализатор для структур
// Инициализатор, куда нужно передать начальное значение для всех свойств
struct User1 {
    var name: String
    var age: Int
}

var user = User1(name: "Bob", age: 34)

// Делегирование инициализаторов - вынести одинаковый код из нескольких инициализаторов в другой

struct Size {
    var width = 0
    var height = 0
}

struct Point {
    var x = 0
    var y = 0
}

struct Rect {
    var origin = Point()
    var size = Size()
    
    init() {}
    
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        // Внутри вызывается другой инит с вычисленными параметрами
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

// Failable(неудачный) инициализатор
struct SizeSquare {
    var width = 0
    var height = 0
    
    init() {}
    
    init?(width: Int, height: Int) { // Failable
        guard width >= 0 && height >= 0 else { return nil } // Инициализация совершилась с ошибкой
        
        self.width = width
        self.height = height
    }
}

let sizeSquare = Size(width: -22, height: 6) // Иниализатор ничего не возвращает
sizeSquare // nil

// ------------------ //
// Управление памятью
// Управление происходит автоматически ARC(Automatic Reference Counting)

class TestClass {
    init() {
        print("TestClass создан")
    }
    
    deinit {
        print("TestClass удален")
    }
}

var reference1: TestClass? = TestClass() // 1
var reference2 = reference1 // Новый объект не создаетсся, увеличивается кол-во ссылок +1 (2)

reference1 = nil // удаляем объект, 1 ссылка остается
reference2 = nil // нет ссылок
 
// Strong reference cycle
class User {
    let name: String
    var devices: [Device] // Ссылка на устройство
    
    init(name: String) {
        self.name = name
        devices = []
        print("Создан пользователь", name)
    }
}

class Device {
    let model: String
    let owner: User // Ссылка на владельца // "weak var owner: User?"
    // unowned // unowned unsafe(небезопасный) -> неопределенной поведение
    
    init(model: String, owner: User) {
        self.model = model
        self.owner = owner
        print(print("Создано устройство", model, "Его владелец", owner.name))
    }
}

// Device и User ссылаются друг на друга и никогда не будут удалены

var bob: User? = User(name: "Bob")
var iphone11: Device? = Device(model: "Iphone 11", owner: bob!)

bob!.devices.append(iphone11!)

bob = nil
iphone11 = nil

// Unowned-ссылки не обнуляются при удалении объекта
// (не обязательно использовать optional -> то есть указывает сразу на объект)
// swift безопасный и при обращении к ней, он не повредит данные и завершит выполнение программы
