import UIKit

// Decimal

var step = 0.01
var sum = 0.0
for _ in 1...100000 {
    sum += step
}
 
print(sum) // 999.9999999992356 // Double, дробные числа

// Чтобы число было округленным воспользуемся Decimal (без потери точности вычислений)
// Конвертируем в Decimal
guard var decimalStep = Decimal(string: "0.01") else { fatalError() }

guard var decimalSum = Decimal(string: "0") else { fatalError() }

for _ in 1...10000 {
    decimalSum += decimalStep
}

print(decimalSum) // 1000

//

guard var decimal = Decimal(string: "1003.07675") else { fatalError() }

decimal.exponent //  число, обозначающее степень
decimal.significand // мантисса
decimal.isInfinite // бесконечность

Decimal.pi // 3.14
Decimal.nan // Nan - не число

// Математические операции можно выполнять с указанием способа округления
// 4 типа округления

// Пример : 0.5
// (1) - plain - округляет число в ближайшую сторону: 1
// (2) - down - всегда округляет вниз: 0
// (3) - up - всегда округляет вверх: 1
// (4) - bankers - округляет в ближайшую сторону(если посередине - то где число четное): 0

var result = Decimal() // Переменная, для сохранения результата

guard var leftDecimal = Decimal(string: "2.3") else { fatalError() }

guard var rightDecimal = Decimal(string: "103.076") else { fatalError() }

let error = NSDecimalAdd(&result, &leftDecimal, &rightDecimal, .down)
if error != .noError { fatalError() } // CalculationError

print(result) // 105.376

// ---- //
guard var decimal = Decimal(string: "103.0764") else { fatalError() }
NSDecimalRound(&result, &decimal, 2, .bankers)
print(result) // 103.08


// ------------- //
// NumberFormatter - используется для вывода денежных сумм, процентов и прочего
guard var decimal1 = Decimal(string: "10002.08561") else { fatalError() }
let formatter = NumberFormatter()
formatter.numberStyle = .currency
print(formatter.string(for: decimal1)) // Optional("$10,002.09")

// Можно указать другую локализацию с помощью структуры Locale
// Поменять символ валюты и разделитель целой части
let otherFormatter = NumberFormatter()
otherFormatter.numberStyle = .currency

otherFormatter.locale = Locale(identifier: "ru_RU")
print(otherFormatter.string(for: decimal1)) // Optional("10 002,09 ₽")
