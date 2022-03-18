import UIKit


// Сабскрипты (Subscripts) - это простой способ доступа к элементам сущности (Некий инит)
let array = ["one", "two", "three"]
array[1] // "two"

let string = "VikolettA"
let index = string.index(after: string.startIndex)
string[index]

//  для получения элементов, так и для записи
//subscript(index: Int) -> Int {
//    get { //возвращает надлежащее значение скрипта
//        return 0
//    }
//    set(newValue) {
//        //проводит надлежащие установки
//    }
//}

struct TimesTable {
    let multiplier: Int
    
    subscript(index: Int) -> Int {
        return multiplier * index
    }
}

// только для чтения
//subscript(index: String) -> Double {
//    return 0.0
//}

let threeTimesTable = TimesTable(multiplier: 6)

struct Collection {
    let x, y, z: Int
    
    subscript(x: Int, y: Int, z: Int) -> String {
        return "XYZ"
      }
}

let otherCollection = Collection(x: 1, y: 5, z: 6)
otherCollection.x

