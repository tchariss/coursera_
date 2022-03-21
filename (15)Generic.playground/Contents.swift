import UIKit

// Generic <T>
// - Типы данных, независимые от типизации
// Дженерики позволяет создавать функции/типы, которые будут работать с любым типом данныхв зависимости от наших требований

func sumInt(_ arg1: Int, _ arg2: Int) -> Int {
    return arg1 + arg2
}

func sumDouble(_ arg1: Double, _ arg2: Double) -> Double  {
    return arg1 + arg2
}

// generic :
// func имяФункции<Заполнитель1, Заполнитель2>
// (параметр1: Заполнитель1, параметр2: Заполнитель2) -> Заполнитель2

func sumGeneric<T: Numeric>(_ arg1: T, _ arg2: T) -> T {
    return arg1 + arg2
}

print(sumGeneric(21, 66))
print(sumGeneric(3.38, 22.5))

// Дженерик-типы данных (классы, структуры, перечисления)
// Будут работать с любым типом данных аналогичным образов как массивы или словари
struct StackOfInteger { // Структура, реализующая стек
    var items = [Int]() // Int - работа только с одним типом данных
    
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
}

// Лучшее решение - создание структуры с дженерик-параметрами
struct StackOfGenerics<ContainedType> {
//    ContainedType - используемый тип данных (любой)
    var items: [ContainedType] = []
    
    @_specialize(where ContainedType == String)
    // @_specialize -> подсказывает оптимизатору какие типы данных будут использоваться чаще всего (Применяется только для функции)
    mutating func push(_ item: ContainedType) {
        items.append(item)
    }
    mutating func pop() -> ContainedType {
        return items.removeLast()
    }
}

let item = "Contained info"

var stackOfGenerics = StackOfGenerics(items: [item])
let popedGenericItem = stackOfGenerics.pop()
type(of: popedGenericItem)

// Использование дженериков , минусы
// - Снижение производительности во время исполнения (дополнительная обработка кода)

//  Помощь : @_specialize


// --------------- //
// Generic constraints (Дженерик - констреинты)
// constraints - ограничители, дополнительные условия вхождения в фун-ию/класс/перечисление
// - для ограничения дженерик-параметров различными условиями

struct stackOfGenericsConstraints<ContainedType: Equatable> {
    // ContainedType должен реализовывать протокол Equatable (ограничение)
    // ...
}

// Создаем расширение для структуры и описываем метод/функцию
// В этом коде "Equatable" является указанием, каким типом данных ограничивается наша фукнция
extension StackOfGenerics where ContainedType: Equatable {
    func isItemOnTop(_ item: ContainedType) -> Bool {
        return items.last == item
    }
}

// --------------- //
// Перегрузка функции с дженерик-параметрами

// При передачи UILabel в качестве параметра
// Сначала будет вызвана функция, получающая в качестве параметра тип UILabel
func log<PlaceHolderType: UIView>(_ view: PlaceHolderType) {}

func log(_ view: UILabel) {}


// --------------- //
// Ограничители для протоколов
// Associated Types (Связанные типы) - делают протоколы универсальными

// Для использования дженерик-кода в протоколах мы создаем associatedtype
protocol Printable {
    associatedtype PrintableType
    associatedtype OtherPrintableType
    
    // Типы данных мы определяем в подклассах
    func printValues(_ arg1: PrintableType, _ arg2: OtherPrintableType)
}

class Document: Printable {
    func printValues(_ arg1: Bool, _ arg2: Int) {
        print("1 - ", arg1, ", 2 - ", arg2)
    }
}

let instanceDocument = Document()
instanceDocument.printValues(true, 22)

// --------- //
// Typealias - псевдонима какого-то типа
// Позволяет вам предоставить новое имя для существующего типа данных
// typealias имя = существующий тип

// Явное определение типа данных, с которым будет работать объект, реализующий протокол
protocol ViewModel {
    associatedtype ContextType
    var context: ContextType? { get set }
    
    init(with context: ContextType?)
}

class ExampleViewModel: ViewModel {
    typealias ContextType = Int
    
    var context: ContextType?
    required init(with context: ContextType?) {
        self.context = context
    }
}



// -------------------- //
// Как устроены Дженерики
func min<T: Comparable>(_ x: T, _ y: T) -> T {
    // Есть только заполнитель Т, на него наложено 1 ограничение
    // Он должен поддерживать сравнение
    return y < x ? y : x
}


