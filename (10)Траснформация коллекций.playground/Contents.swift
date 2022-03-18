import UIKit

// Траснформация коллекций
// Преобразование

var arrayOfInts = [1, 3, 4, 6, 8]
// Пробежимся по массиву и преобразyем все значения в другой массив

var newArray: [Int] = []
for value in arrayOfInts {
    newArray.append(value * 3)
}
newArray

// Лучше использовать map
// Он получает на вход замыкание , которое преобразует каждый элемент(* 3) по очереди
let sameNewArray = arrayOfInts.map { $0 * 3 }
sameNewArray

let arrayOfOptionalInts = [10, 2, nil, 6, 5]
var newOptionalArray = arrayOfOptionalInts.map {
    // Явно указываем возвращаемый тип (Optional Int)
    (newValue) -> Int? in
    if let value = newValue {
        return value * 3
    } else {
        return nil
    }
}
newOptionalArray

// ------------------------ //
// Трансформируем массив массивов

let arrayOfArray: [[Int]] = [[1, 4, 2], [6, 3], [8, 5, 9]]

arrayOfArray.map {
    // Каждый элемент является массивом
    type(of: $0) // [Int]
}

// Изменяем элемент вложенного массива
let increasedArrayOfArray = arrayOfArray.map { $0.map { $0 * 2 } }
increasedArrayOfArray // Измененный двумерный массив

// Используем map на массиве optional массивов Int
let arrayOfArrayOptionals = [[4, 1, 5], nil, [8, 7, 2]]
let changedArrayOfArrayOptionals = arrayOfArrayOptionals.map {$0?.map { $0 * 2 } } // Optional chaining
changedArrayOfArrayOptionals

// Уберем все полученные nil из нового массива
let arrayOptionalInt = [nil, 5, 10, nil, 3, nil, 6]
let newChangedArrayOfArrayOptionals = arrayOptionalInt.compactMap { // Откидывает nil значения
    (newValue) -> Int? in
    
    if let value = newValue {
        return value * 3
    } else {
        return nil
    }
}
newChangedArrayOfArrayOptionals

// var arrayOfInts = [1, 3, 4, 6, 8]
let newChangedArrayInt = arrayOfInts.compactMap { $0 * 3 }
newChangedArrayInt

let arrayOfArrayInt : [[Int]] = [[1, 4, 2], [6, 3], [7, 5, 9]]
let newArrayInt = arrayOfArrayInt.flatMap { $0.map { $0 + 3 } }
// flatMap развернет вложенные массивы и без nil, вернет sequence(последовательность)
newArrayInt

// ---------------------------------- //
// Функция(Метод) filter - фильтрация
var arrayInts = [1, 2, 34, 6, 8, 3, 10, 22, 4, 3]
let arrayOfEvents = arrayInts.filter { $0 % 2 == 0 }
arrayOfEvents
// ---------------------------------- //

// Сортировка массива
// - Sorted by - вернет отсортированный массив как копию
// - Sort by - изменит сам массив (Изменяет сам объект = Название метода в повелительной форме)

// Сортировка массива в порядке убывания

let decreaseSortedArrayInt = arrayInts.sorted {
    $0 > $1 // return true || false
}
decreaseSortedArrayInt

// Вместо передачи closure мы можем передать саму фун-ию для сравнения как параметр
// Операторы - тоже функция, то есть вызов можно сократить до 1-го символа
let sameSortedArray = arrayInts.sorted(by: >) // { $0 > $1 }
sameSortedArray

// По умолчанию sorted использует метод сравнения меньше < (0..100)
// default: Сортировка по возрастанию
[3, 4, 1, 9, 7].sorted()

// ---------------------------------- //
// Функция(Метод) reduce
// Принимает 2 параметра : (1)начальное/промежуточное значение и (2)замыкание
// Сложение всех элементов в массиве
var arrayElementInt = [4, 6, 10, 1, 4, 5]
let sumOfArrayElements = arrayElementInt.reduce(4) { // Начальное значение 4
    intermediateResult, Element in
    // 1 - intermediateResult(начальное/промежуточное значение, сохраняет результат вычисления)
    // 2 - element(каждый элемент)
    return intermediateResult + Element
}
sumOfArrayElements

// Мы можем просто передать функцию, вместо значение (Оператор тоже функция)
let sumOfArrayElements2 = arrayElementInt.reduce(2, +) // Начальное значение: 2, Операция: Сложение
sumOfArrayElements2

// ---------------------------------- //
// В качестве начального значения пустой массив
// Проверяем четный ли элемент(% 2)
// 1 - Если четный, добавляем его с помощью конкатенации массивов
// 2 - Нечетный -> возвращаем полученный промежуточный массив
let sameArray = arrayElementInt.reduce([]) { $1 % 2 == 0 ? $0 + [$1] : $0 }
sameArray

let sameArray2 = arrayElementInt.reduce(into: 0) { $0 += $1 }
sameArray2

// ---------------------------------- //
// Функция(Метод) swap at -> поменять местами

var mutableArrayInt = [1, 4, 3, 2]
mutableArrayInt.swapAt(0, 2)
mutableArrayInt
