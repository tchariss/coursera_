import UIKit

// Optionals / Опционалы - контейнер для значений (значение || nil)

// Объявление optionals
let short: Int? // Краткая запись // == nil
let long: Optional<Int> // Полная запись

// Как устроен / Что из себя представляет
enum Optional<T> {
    case none     // nil
    case some(T)  // какое-нибудь значение
}


// Force unwrap (Принудительное разворачивание)
let counter: Int? = nil
// counter! // nil -> аварийное завершение программы


// Optional binding (Привязка опционалов) -> if
if let nonOptionalCounter = counter {
    print(nonOptionalCounter)
}

let firstOptionalCounter: Int? = 5
let secondOptionalCounter: Int? = 10

if let firstCounter = firstOptionalCounter,
   let secondCounter = secondOptionalCounter,
   firstCounter < secondCounter {
    print("first(\(firstCounter)) < second(\(secondCounter))")
}
   
// ---- //
// Чтобы с переменной работать не только внутри выражения, можно использовать guard let
func checkOptional () {
    guard let nonOptional = counter else { return }
    print(nonOptional)
}


// Nil-coalescing operator (Оператор объединения по nil) - ??
// Тернарный оператор

let anotherCounter: Int? = 22
let nonOptionalCoalesing = counter ?? anotherCounter

let optional5: Int? = 5
let optionalNil: Int? = nil

var a = optional5 ?? 10 // 5 -> если левое = nil -> присваиваем правое
var b = optionalNil ?? 20 // 20


// Optinonal chaining (Опциональная цепочка/последовательность)
// Процесс вызова метода/свойства для optional-значения
// Если optional свойство = nil, то и вызов функции, получения свойства также вернет nil

class SomeClass {
    struct InnerStruct {
        var variable: Int
    }
    var innerStruct: InnerStruct?
}

let myClass = SomeClass()
// Попытка обращения к свойству проходит по цепочке, в которой присутствует optional-значение -> это и есть optional chaining
var anotherOptional = myClass.innerStruct?.variable
myClass.innerStruct?.variable = 55

func getSomeValue() -> Int { return 5 }
myClass.innerStruct?.variable = getSomeValue()

let initStruct = SomeClass.InnerStruct.init(variable: 24)
print(initStruct.variable)

// ------ //

class SomeClassTwo {
    struct InnerStruct {
        func printSomething() {
            print("Что-то!")
        }
    }
    var innerStruct: InnerStruct?
}

let myClassTwo = SomeClassTwo()
if myClassTwo.innerStruct?.printSomething() != nil {
    print("Функция выполнилась")
}

// При работе с сабскриптами/индексаторами вопросительный знак ставится до указания сабскрипта/индекса
class SomeClassThree {
    var arrayOfInts: [Int]?
}

let myClassThree = SomeClassThree()
//myClassThree.arrayOfInts = []
myClassThree.arrayOfInts?[1] = 6

if let value = myClassThree.arrayOfInts?[1] {
    print("value = ", value)
}

// --------------------------- //
// Проверка и приведение типов //
// as?(Условно -> Опциональный тип) и as!(Принудительно -> вернет тип) -> downcasting(оператор броска), то есть явное приведение объекта

class MediaItem {
    var name: String
    init(name: String) {
        self.name = name
    }
}

class Movie: MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}
 
class Song: MediaItem {
    var artist: String
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}

let library = [
    Movie(name: "Casablanca", director: "Michael Curtiz"),
    Movie(name: "Citizen Kane", director: "Orson Welles"),
]

// Условная форма оператора броска типа (as?)
for item in library {
    if let movie = item as? Movie {
        print("Movie: '\(movie.name)', dir. \(movie.director)")
    } else if let song = item as? Song {
        print("Song: '\(song.name)', by \(song.artist)")
    }
}


// Есть простой оператор as - когда на этапе компиляции известно, что результат будет успешным
// Виды преобразований :

// 1 - Upcasting(Преобразование) - привести производный тип к базовому (Во время наследования)
class Animal {}
class Dog: Animal {}
let d = Dog()
let cast = d as Animal // успешное преобразование
print("type cast is :", type(of: cast))

// 2 - Bridging - автоматическое преобразование типов
let str: String = "Hello, world!"
let nsStr = str as NSString
print("type nsStr is :",type(of: nsStr))
