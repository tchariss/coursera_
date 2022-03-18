import UIKit

// Функции и методы

@discardableResult // Атрибут, чтобы можно было выполнение функции не присваивать ничему
func usefulFunc(firsrPar: Int = 0, secondPar: String = "", thitdPar: String) -> (firstRes: Int, SecondRes: String) {
    
    return (firsrPar, secondPar)
}

//let variable = usefulFunc(firsrPar: 1, secondPar: "Simple", thitdPar: "Just")
usefulFunc(firsrPar: 1, secondPar: "Simple", thitdPar: "Just")


// Функции с переменным числом параметров
func sum(numbers: Int...) -> Int {
    var result = 0
    
    for number in numbers {
        result += number
    }
    
    return result
}

sum(numbers: 1, 3, 5, 6)

// Возможность менять аргумент внутри функции (inout)
func swap(_ a: inout Int, _ b: inout Int) {
    let tempA = a
    a = b
    b = tempA
}

var first = 1
var second = 5
// Передаются параметры через &
swap(&first, &second)

print("first is \(first), second is \(second)")

// Функции могут храниться в переменных и быть переданы в другие функции
func summ(_ a: Int, _ b: Int) -> Int {
    return a + b
}

func multi(_ a: Int, _ b: Int) -> Int {
    return a * b
}

type(of: summ)

var value: (Int, Int) -> Int = summ // переменаая для хранения функции
value = multi

value(3, 5)

// Функция внутри функции, вложенная функция
func transf() -> (Int) -> (Int) {
    func square(value: Int) -> Int {
        return value * value
    }
    
    return square
}

func transForm(_ value: Int, using clousure: (Int) -> Int) -> Int {
    return clousure(value)
}

let transformer = transf()
let res = transForm(5, using: transformer)

// Методы - функции, ассоциируемые с каким-либо типом
class Counter {
    private var count = 0
    
    func increment() {
        count += 1
    }
    
    func isGreat(_ count: Int) -> Bool {
        return self.count > count
    }
}

/* По умолчанию методы типов не могут модифицировать свой объект,
 нужно добавить mutating (тогда он будет меняться) */

/* Для добавления методов самому типу нужно использовать static */

// typeOf -> возвращает тип переданного экземпляра
struct MyStruct {
    static var sharedValue = 0
    
    func increment() {
        type(of: self).sharedValue += 1
    }
}

let myStruct = MyStruct()

MyStruct.sharedValue
myStruct.increment()
MyStruct.sharedValue
