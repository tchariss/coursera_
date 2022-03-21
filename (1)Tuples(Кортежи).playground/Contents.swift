import UIKit


// MARK: - Tuples
// Составной тип данных, группируют типы данных

/*
let simpleTuple : (Int, String, Bool, Double) = (1, "Hello", true, 2.4)
//let simpleTuple = (1, "Hello", true, 2.4)
// .0 1
// .1 "Hello"
// .2 true
// .3 2.4

let (number, greatings, check, decimal) = simpleTuple
// Можно получить доступ через константы , декомпозиция(разбиение) tuple
number
greatings
check
decimal

let (_, _, check2, _) = simpleTuple
check2

simpleTuple.0
simpleTuple.1
simpleTuple.2
simpleTuple.3

var namedTuple = (index: 3, phrase: "hello world!", registred: true, latency: 5.6)

namedTuple.phrase
namedTuple.registred

namedTuple.index = 5

*/

let multiLine = """
This is
    my name
string
"""

print(multiLine)
print("\u{1F40E}")

let str = "Котик"
for char in str {
    print(char)
}

let cat: [Character]

print("-------//-------//-------")
// Работа со стрингой

var word = "Какое-то слово тут!"

print(word[word.startIndex]) // К
print(word[word.index(word.startIndex, offsetBy: 3)]) // о

word.remove(at: word.startIndex)
print(word)

word.insert("Д", at: word.startIndex)
print(word) // Дакое-то

print("-------//-------//-------")

let text = "ООО \"Рога и копыта 777\" \nГен. директор: Иванов"
print(text)

print("-------//-------//-------")
//Создание строки из SubString
let string = "Hello word!"
let subString = string.suffix(5)
let stringFromSubString = String(subString)


print("-------//-------//-------")

let run = "прибежать"
let prefix = "при"
let suffix = "ать"
if run.hasPrefix(prefix) && run.hasSuffix(suffix) {
 print("Начинается на \"при\", заканчивается на \"ать\"")
} // Начинается на "при", оканчивается на "ать"
