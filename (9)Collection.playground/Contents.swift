import UIKit

// Коллекции / Collection
// 3 структуры данных : массив, словарь, множества
// Тип значение / Type value

var mutableArray: [Int] // массив Int
let immutableDictionary: [String: String] // словарь
var mutableSet: Set<Int> // Множество Int

var mutableArrayOther = [1, 2, 3] // массив Int
let immutableDictionaryOther = ["language": "swift", "version": "4.0"] // словарь
var mutableSetOther: Set<Int> = [0, 1, 1, 2, 3, 2] // можно использовать литерал массива(список, где каждый представлен элементов массива), повторяющиеся элементы будут отброшены

mutableArrayOther[1]
immutableDictionaryOther["language"]

//  Диапазон элементов
mutableArrayOther.append(contentsOf: [4, 5, 6])
let slice = mutableArrayOther[3..<mutableArrayOther.endIndex]
type(of: slice) // Он хранит указатель на оригинальный массив и начало/конец выбрранного диапазона
print(slice)

var indices = IndexSet()
indices.insert(integersIn: 0..<5)
indices.insert(integersIn: 8..<20)
print(indices)
// Фильтровать индесы
let filtered = indices.filter { $0 % 2 == 0}
filtered.contains(5) // contains -> содержит ли элемент -> bool
filtered.contains(6)
filtered.contains(10)

// Массив
// 1 - Пройтись по всем элементам - for in
// 2 - Получение первого или последнего элемента - first / last
// 3 - Для трансформации методы Map, Filter, Reduce и др.
// 4 - Prefix/Suffix возвращают первые и последние N элементов
// 5 - DropFirst/DropLast возвращают последовательность без первых или последних N элементов
// 6 - Split разделяет последовательность во разделителю и возвращает массив, состоящие из элементов

// Протоколы, на которых построены коллекции - Sequence (Метод makeIterator)
// iterator protocol -> next (или nil) (Итератор возвращает следующий элемент)

// Итератор генерирует числа
struct MultiplicityIterator : IteratorProtocol {
    var base = 1
    
    public mutating func next() -> Int? {
        defer { base += base }
        return base
    }
}

// ----------------------- //

var i = MultiplicityIterator()
i.base = 4

i.next()
i.next()
i.next()

// ----------------------- //

let sequence = stride(from: 1, to: 10, by: 4) // Последовательность чисел от 1 до 10 с шагом 6
var iterator = sequence.makeIterator()
var iterator2 = iterator
var anyIterator = AnyIterator(iterator)
var anyIterator2 = anyIterator

iterator.next()
iterator.next() // Iterator
iterator.next() // Iterator
iterator2.next() // Iterator2 -> разные итерируемые последовательности

anyIterator.next() // Iterator
anyIterator2.next() // Iterator2
anyIterator.next() // Iterator -> одинаковые итерируемые последовательности (общая )

// ----------------------- //

let randomIterator = AnyIterator() { arc4random_uniform(100)} // Создаем итератор, которые возвращает случайные значения
let randomSequence = AnySequence(randomIterator) // Создаем последовательность, в которую передаем итератор

let arrayOfRansomNumbers = Array(randomSequence.prefix(10)) // Присваем первые 10 элементов из данной последовательности

for number in randomSequence.prefix(5) {
    print("Another random number: - \(number)")
}

// ----------------------- //

struct MultiplicitySequence : Sequence {
    private let base: Int
    
    init(base: Int) {
        self.base = base
    }
    
    public func makeIterator() -> MultiplicityIterator {
        var iterator = MultiplicityIterator() // Создаем итератор
        iterator.base = base
        return iterator
    }
}

let multiSequence = MultiplicitySequence(base: 6)
Array(multiSequence.prefix(5))
Array(multiSequence.prefix(6))

// ----------------------- //
// Структура последовательности отсчета
struct CountDown: Sequence, IteratorProtocol {
    var count: Int // текущее значение
//    print("current count = \(count)")
    
    mutating func next() -> Int? {
        if count == 0 {
            return nil // возвращает nil, если счетчик достиг нуля
        } else {
            defer { count -= 1 } // уменьшает на один после return
            print("count = \(count)")
            return count
        }
    }
}

var a = CountDown(count: 3)
a.next()
a.next()
a.next()
a.next()

// Протокол Collection наследуется от Sequence,
// добавляя индексы, сабскрипты и обязательство не разрушать данные, при проходе итератора(стабильная послед-ть)
// Коллекция - стабильная последовательность элементов, кот. можно безопасно итерировать много раз

// Коллекция Стек
struct Stack {
    private var privateStorage: [String] = []
    
    mutating func push(_ element: String) { // Добавляет элемент в конец
        privateStorage.append(element)
    }
    
    mutating func pop() -> String? { // Возвращает последний элемент и удаляет его
        return privateStorage.popLast()
    }
}

var stack = Stack()
stack.push("Hello") // Закидываем элемент
stack.push("Vika")
stack.pop() // Забираем элемент
stack.push("World")
stack.push("!")

//stack.pop() // Забираем элемент
//stack.pop() // Забираем элемент
//stack.pop() // Забираем элемент

// Добавим нашему стеку поддержку протокола Collection
extension Stack: Collection {
    var startIndex: Int {
        return 0
    }
    
    var endIndex: Int {
        return privateStorage.count // элемент следующий за последним (кол-во)
    }
    
    func index(after i: Int) -> Int {
        return i + 1 // из индекса получить следующий за ним
    }
    
    subscript(position: Int) -> String { // subscript - "индекс"
        return privateStorage[position] // элемент по определенному индексу
    }
}

for element in stack {
    print("element = \(element)")
}

stack.count // Количество элементов
stack.isEmpty // Является ли он пустым

Array(stack[1...2]) // Составить массив из части элементов нашего stack

// ----------------------- //
// Индексы - может быть любого сравнимого типа (String index)

let str = "Simple string"

var indexStr = str.index(of: "s")! // Получаем  индекс элемента "s" (Тип string.index)
var indexStr2 = indexStr // Присваиваем индекс другой переменной
indexStr2 = str.index(after: indexStr2) // Находим индекс, следующий за данным индексом
str.formIndex(after: &indexStr2)

// Расстояние, между 2-мя переменными с индексами, которые у нас есть
var indexDistance = str.distance(from: indexStr, to: indexStr2)
str.endIndex
indexStr = str.index(indexStr, offsetBy: indexDistance) // Добавим расстояние к одну из индексов
indexStr == indexStr2 // Индексы равны
// .startIndex & .endIndex - специальные индексы, указывают на перрвый элемент коллекции и на следующий за последним

// Прокотолы для коллекция
// - BidirectionalCollection - добавляет в коллек-ию возможость получить предыдущий и ндекс
// - RandomAccessCollection - гарантирует доступ к любому индексу за константное время
// - MutableCollection - добавляет возможность изменять содержимое коллекции через сабскрипты(индексы)
// - RangeReplaceableCollection - позволяет заменить сразу диапазон индексов
