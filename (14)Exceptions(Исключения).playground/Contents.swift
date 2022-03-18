import UIKit

// Exceptions // Исключения
// Они помогают передать вызывающей стороне причину по которой выполнение кода было прервано

// Throw(бросок) - чтобы выбрасывать исключения

enum ProcessingError: Error {
    case incorrecInput
    case noConnection
    case internalError(errorCode: Int)
}
// Выбрасывание исключения (Экземпляр любой сущности, поддерживающий протокол error)
throw ProcessingError.internalError(errorCode: 2)

// Чтобы функция использовала исключения, ее нужно пометить throw
func canThrowErrors() throws -> String {
    throw ProcessingError.internalError(errorCode: 3)
}

// Исключения можно использовать в инициализаторах
struct MyStruct {
    init(parameter: Int) throws {
        guard parameter != 0 else {
            throw ProcessingError.incorrecInput
        }
    }
}

// Перехваты исключения (4 варианта обработки)

// (1) - Передача выше по стеку вызовов
func canThrowErrorsTo() throws {
    try canThrowErrors() // позволить подняться выше по стеку вызовов
}

// (2) - Catch(Ловить) - перехват нужных исключений
// Шаблоны для определения типа исключения
do {
    try canThrowErrors()
} catch ProcessingError.incorrecInput {
    // ...
} catch ProcessingError.noConnection {
    // ...
} catch ProcessingError.internalError(let errorCode) where errorCode == 1 {
    // ...
} catch let anotherError {
    // ...
}

// (3) - try? - Конвертация возвращаемого значения в опциональный тип
let result = try? canThrowErrors
type(of: result) // Optional<String>

// (4) - try! - Принудительное игнорирование
// Только если уверены, что исключение не возникнет
try! canThrowErrors()


// Брошенное исключение == return
// Исключение - это enum
enum Result<T> {
    case fail(Error) // Ошибка, любой объект поддерживающий протокол error
    case success(T) // Значение
}

func canThrowErrorsUsingEnum() -> Result<String> {
    return .fail(ProcessingError.internalError(errorCode: 2))
}

// ------------------- //
// Defer - выполнение кода при любых обстоятельствах, будет вызван при выходе из области видимости
// Для освобождения ресурсов
defer {
    // какие-то операции
}

struct MultiplicityIterator: IteratorProtocol {
    var base = 1
    // текущее значение base сохраняется в качестве результата выполнения функции

    public mutating func next() -> Int? {
        defer { base += base } // выполняется после функции
        // вместо дополнительной переменной для сохранения текущего значения base
        return base
    }
}


// ----------------------------- //
// Pattern Matching // Паттерн - структура простого или составного типа

// ---   I тип паттернов  --- //
// (1) Wildcard pattern - если результат выполнения функции не нужен (_)
// Совпадает с любыми значениями любых типов
func someCalculation() -> Int { return 5 }
_ =  someCalculation()

for _ in 1..<7 {
    // ..
}


// (2) Identifier pattern - для нахождения конкретных значений
// Совпадает с любым значением и связывает его с константой/переменной
let someString = "string"

// (3) Value binding pattern - состоит из let/var и шаблона после него
// Все идентификаторы в паттерне будут связываться с константой или переменной
let tuple = (1, 2)

if case (let a, let b) = tuple {
    print(a, b)
}

// более лаконичен
if case let (a, b) = tuple {
    print(a, b)
}

// (4) Tuple pattern - состоит из let/var и шаблона после него
let (a, b): (Int, Int) = (3, 4)

// ---   II тип паттернов  --- //
// (1) Enumeration case pattern - каждый паттерн ожидает конкретное значение
enum SomeType {
    case type1
    case type2
}

let type = SomeType.type2

switch type {
case .type1:
    print("type1")
case .type2:
    print("type2")
}

// (2) Optional pattern - получение значений из опционального типа
let optValue: Int? = 654

if case let value? = optValue {
    print("value = ", value)
}
if case let .some(value) = optValue {
    print(".some(value) = ", value)
}

// (3) Type casting pattern - (is / as) - используется в switch
let someValue: Any = 0.0

switch someValue {
case 0 as Double:
    print("as Double")
    break
case 0 as Int:
    print("as Int")
    break
default:
    print("default")
    break
}

// (4) Expression pattern - ( ~= ) - используется в switch
// Возвращает логическое значение, указывающее, совпадают ли два аргумента с равенством значений.
// func ~= <T>(a: T, b: T) -> Bool where T : Equatable

func ~=(pattern: Int, value: String) -> Bool {
    if let intValue = Int(value) {
        return intValue == pattern
    }
    return false
}

let weekday = 3
let lunch: String

switch weekday {
case 3:
    lunch = "Taco Tuesday!" // lunch == "Taco Tuesday!"
default:
    lunch = "Pizza again."
}

