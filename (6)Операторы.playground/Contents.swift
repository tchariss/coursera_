import UIKit

// Операторы
/*
Типы : инфиксный/infix , префиксный/prefix , постфиксный/postfix
 ⁃ инфиксный -> бинарный, между 2мя операндами (Пр: + - ) -> precedence group/ группа приоритета
 ⁃ префиксный -> унарный, перед операндом (Пр: !a ++a)
 ⁃ постфиксный -> унарный, после операнда (Пр: a! - Force unwrap)

Перегрузка оператора -  позволяет использовать один и тот же оператор для выполнения операций с разными типами
*/
// Перегрузка оператора

struct RGBcolor {
    var red = 0.0
    var green = 0.0
    var blue = 0.0
}

func + (left: RGBcolor, right: RGBcolor) -> RGBcolor {
    return RGBcolor(red: left.red + right.red,
                    green: left.green + right.green,
                    blue: left.blue + right.blue)
}

let blue = RGBcolor(red: 0, green: 0, blue: 1)
let red = RGBcolor(red: 1, green: 0, blue: 0)

let purple = blue + red

//——————————————————————————//

//Определение собственного оператора

infix operator **: MultiplicationPrecedence

extension Double {
    static func ** (left: Double, right: Double) -> Double {
        return pow(left, right)
    }
}

print(6**2)

// associativity : left/right/none 
