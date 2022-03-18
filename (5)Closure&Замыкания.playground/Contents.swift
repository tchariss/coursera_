import UIKit

// Closure & Замыкания - лямбды, блоки коды, могут завязвываться на перемнной
// Reference type
// Внешняя функция, которая вовзращает замыкание(принимающие Int и возвращающее String)
func counterFunc() -> (Int) -> String {
    var count =  0
    
    func innerFunc(i: Int) -> String {
        count += i // count захвачен в замыкании
        return "running total : \(count)"
    }
    
    return innerFunc
}

let closure = counterFunc()

closure(3)
closure(5)
closure(8)

// Внутрення функция обращается к переменной из внешней , + переменная не удаляется из памяти - это и есть замыкание


// Анонимное замыкание / Closure expression

let multiplier = 3

let anonymousClosure = { // : параметры -> тип возвращаемого значения in
    (anotherItemInArray: Int) -> Int in
    
    // Доступны переменные, объявленные во внешнем скоупе
    return anotherItemInArray * multiplier // код замыкания
}

func transform(value: Int, using transformator: (Int) -> Int) -> Int {
    return transformator(value)
}

/*
 Глобальные фун-ии -> это замыкания, которые ничего не захватывают
 Вложенные  фун-ии -> это замыкания, имеющие имя и захватывающий контекст, в котором они объявлены
 Анонимные замыкание -> захватывают контекст, но не имеют имени
 */


//transform(value: 6, using: (Int) -> Int) // (Int) - (anotherItemInArray: Int) -> in ...

transform(value: 6, using: {
    (anotherItem: Int) -> Int in
    return anotherItem * multiplier
})
 
// Тип возвращаемого значение Int, мы можем его опустить
transform(value: 7, using: {
    (anotherItem: Int) in
    return anotherItem * multiplier
})

// Swift неявно именует все параметры, передаваемые в замыкание, как $0, потому можем убрать все 1 строку
transform(value: 8, using: {
    return $0 * multiplier
})

// Поскольку замыкание состоит только из 1-го вычисления, можем удалить return
transform(value: 10, using: { $0 * multiplier })

// Начать описание замыкание на той же строке
// Замыкания передаются последним аргументом и можем вынести его за скобки фун-ии
transform(value: 12) { $0 * multiplier }

let firstCounter = counterFunc()
let anotherCounter = counterFunc()
anotherCounter(3)
firstCounter(4)

// ---------- //
/*
Переменная захватывается по ссылке
Можно использовать список захвата, расположить перед списком параметров замыкания , если его нет, перед ключевым словом in
В квадратных скобках через запятую перечисляются имена переменных и констант,
они будут скопированы в замыкание (Можно дать другое имя)
*/

var a = 0
var b = 0

let closure1 = {
    [newNameForA = a] in // а захвачено в состоянии = 0 -> неизменяется
    print("a = \(newNameForA), b = \(b)") // b захвачено по ссылке -> изменяется
}

a = 10
closure1()

a = 20
b = 10
closure1()

//@escaping -> говорит компилятору, что функция может быть исполнена, после выхода из скоуп
//——————————————————————————


//Autoclosure - это синтаксическая конструкция, облегчающая написание и чтение кода.

let someVar = false
let someVar2 = 26
 
and(someVar, someVar2 % 2 == 0) // false

// Для того, чтобы избавиться от ненужных вычислений можно передать второй аргумент в виде замыкания.

//and(someVar,  { someVar2 % 2 == 0  }) // false

func and(_ lhs: Bool, _ rhs: @autoclosure () -> Bool) -> Bool {
    guard lhs else {
        return false
    }
    
    return rhs()
}

//  @autoclosure - благодаря ему выражение, переданное в качестве второго аргумента не будет выполняться сразу, а обернется в замыкание.
// Внутри функции просто проверяется значение первого аргумента, и вызывается замыкание если оно true.

public func assert(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = default, file: StaticString = #file, line: UInt = #line) {}

//———-------------
