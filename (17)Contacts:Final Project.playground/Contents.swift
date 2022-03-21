import Cocoa
import Contacts

// Сontact book // Книга контактов
// ------------------------------ //

// Создание модели для хранения контактов
// Протокол, требующий наличие номера телефона и его типа
protocol PhoneNumberProtocol {
    var number: String { get }
    var type: PhoneType { get }
}

// Создадим тип для типа телефона
enum PhoneType: String { // rawValue = строки
    case IPhone
    case mobile
    case home
    case other
}

// Небольшие модели данных оптимальнее реализовывать в виде структур
struct PhoneNumber: PhoneNumberProtocol {
    var number: String
    var type: PhoneType
}

// Контакты будут иметь почтовый адрес ( улица/город/страна )
protocol AddressProtocol {
    var street: String { get }
    var city: String { get }
    var country: String { get }
}

struct Adsress: AddressProtocol { // Структура, для хранения адреса
    var street: String
    var city: String
    var country: String
}

// Контакт, данные
protocol ContactProtocol {
    var firstName: String? { get }
    var lastName: String? { get }
    var phones: [PhoneNumberProtocol] { get }
    var address: [AddressProtocol] { get }
    var emails: [String] { get }
    var birthday: DateComponents? { get }
}

struct Contact: ContactProtocol {
    var firstName: String?
    var lastName: String?
    var phones: [PhoneNumberProtocol]
    var address: [AddressProtocol]
    var emails: [String]
    var birthday: DateComponents?
}

// Calendar - вспомогательный класс, который может преобразовывать даты в компоненты и наоборот
let calendar = Calendar.current
let now = Date()
var dateComponents = calendar.dateComponents([.year, .month, .day], from: now)

// Функция для генерации контактов, создает контакт с переданной датой рождения
func generateContactWith(suffix: String, dateComponents: DateComponents?) -> Contact {
    return Contact(firstName: "firstName" + suffix,
                   lastName: "lastName" + suffix,
                   phones: [PhoneNumber(number: "+79997779977" + suffix,
                                        type: .IPhone)],
                   address: [Adsress(street: "Street" + suffix,
                                     city: "City" + suffix,
                                     country: "Country" + suffix)],
                   emails: ["firstName" + suffix + "lastName" + suffix + "@mail.com"],
                   birthday: dateComponents)
}

// Контейнер для хранения контактов (Коллекция)
let contact1 = generateContactWith(suffix: "1", dateComponents: dateComponents)

dateComponents.day = dateComponents.day! + 1
let contact2 = generateContactWith(suffix: "2", dateComponents: dateComponents)

let contact3 = generateContactWith(suffix: "3", dateComponents: dateComponents)

dateComponents.day = dateComponents.day! - 2
let contact4 = generateContactWith(suffix: "4", dateComponents: dateComponents)

dateComponents.day = 1
dateComponents.month = 1
let contact5 = generateContactWith(suffix: "5", dateComponents: dateComponents)

dateComponents.day = 31
dateComponents.month = 12
let contact6 = generateContactWith(suffix: "6", dateComponents: dateComponents)

let contact7 = generateContactWith(suffix: "7", dateComponents: nil)

// Псевдоним для кортежа, содержащий дату и массив именинников на этот день
typealias UpcomingBirthday = (Date, [ContactProtocol])

protocol ContactBookProtocol: RandomAccessCollection where Self.Element == ContactProtocol {
    mutating func add(_ contact: ContactProtocol)
    func upcomingBirthdayContacts() -> [UpcomingBirthday]
}

// Реализация записной книжки
struct ContactBook {
    private var privateStorage: [ContactProtocol] = []
    
    enum SortingType {
        case firstName
        case lastName
    }
    
    var sortType = SortingType.firstName {
        didSet {
            sortPrivateStorage()
        }
    }
    
    // Сортировка по имени или фамилии
    private mutating func sortPrivateStorage() {
        privateStorage.sort(by: sortingClosure(for: sortType))
    }
    
    
    // Возвращает замыкание, содержащего логику для соответствующего типа сортировки
    private func sortingClosure(for sortingType: SortingType) -> ((ContactProtocol, ContactProtocol) -> Bool) {
        switch sortingType {
        case .firstName:
            return { type(of: self).isLessThan($0.firstName, $1.firstName) }
        case .lastName:
            return { type(of: self).isLessThan($0.lastName, $1.lastName) }
        }
    }
    
    // Метод для сравнения 2х опциональных строк
    private static func isLessThan(_ lhs: String?, _ rhs: String?) -> Bool {
        switch (lhs, rhs) {
        case let (l?, r?): // сравниваются без учета регистра
            return l.caseInsensitiveCompare(r) == .orderedAscending
        case (nil, _?):
            return true
        default:
            return false
        }
    }
}

// Кастомный вывод в консоль
extension ContactBook: CustomDebugStringConvertible {
    var debugDescription: String {
        return self.reduce(into: "ContactBook: \n") {
            result, anotherContact in
            
            let birthdayString: String
            if let birthday = anotherContact.birthday {
                birthdayString = String(describing: birthday)
            } else {
                birthdayString = ""
            }
            
            if anotherContact.firstName == "" && anotherContact.lastName == "" {
                result += "\tunnamed contact \(birthdayString)\n"
            } else {
                result += "\t\(anotherContact.firstName ?? "") \(anotherContact.lastName ?? "") \(birthdayString)\n"
            }
        }
    }
}

// Делаем ContactBook коллекцией и определяем 4 метода
extension ContactBook: RandomAccessCollection {
    var startIndex: Int {
        return 0
    }
    
    var endIndex: Int {
        return privateStorage.count
    }
    
    func index(after i: Int) -> Int {
        return i + 1
    }
    
    subscript(position: Int) -> ContactProtocol {
        return privateStorage[position]
    }
}

// grouped by // возврат массива кортежей
extension Collection {
    func grouped<Key: Equatable>(by getKey:(_ element: Self.Element) -> Key?) -> [(Key, [Self.Element])] {
        
        var result: [(Key, [Self.Element])] = [] // Создаем пустой массив
        
        for element in self { // Получаем ключ для очередного элемента
            guard let keyForElement = getKey(element) else { continue }
            
            // Ищем есть ли в нашем массиве элемент по данному ключу
            //            let index = result.index // depricated
            let index = result.firstIndex {
                (key: Key, element: [Self.Element]) in
                keyForElement == key
            }
            
            if let index = index { // Если есть, добавляем в него  новый элемент
                result[index].1.append(element)
            } else { // Если нет, то добавляем новый массив с данным ключом
                result.append((keyForElement, [element]))
            }
        }
        return result
    }
}

// Метод нахождения именинников
extension ContactBook: ContactBookProtocol {
    mutating func add(_ contact: ContactProtocol) {
        let index = privateStorage.firstIndex { sortingClosure(for: sortType)(contact, $0) }
        
        privateStorage.insert(contact, at: index ?? privateStorage.endIndex)
    }
    
    func upcomingBirthdayContacts() -> [UpcomingBirthday] {
        let todayComponents = Calendar.current.dateComponents([.day, .month], from: Date())
        guard let todayDayMonthDate = Calendar.current.date(from: todayComponents) else {
            return [UpcomingBirthday]()
        }
        
        let sortedBirthdays = grouped {
            (anotherContact: ContactProtocol) -> Date? in
            
            guard let birthday = anotherContact.birthday else {
                return nil
            }
            
            let dayMonthComponents = DateComponents(month: birthday.month, day: birthday.day)
            
            return Calendar.current.date(from: dayMonthComponents)
        }.sorted {
            $0.0 < $1.0
        }
        
        // Берем тех, у кого уже был день рождения и добавляем в конец
        let previousBirthdays = sortedBirthdays.prefix(while: {
            $0.0 < todayDayMonthDate
        })
        
        let result = sortedBirthdays.dropFirst(previousBirthdays.count) + previousBirthdays
        
        // берем первые 3 элемента
        return [UpcomingBirthday](result.prefix(3))
    }
}

var contactBook = ContactBook()

contactBook.add(contact7)
contactBook.add(contact6)
contactBook.add(contact5)
contactBook.add(contact4)
contactBook.add(contact3)
contactBook.add(contact2)
contactBook.add(contact1)

// Выводятся отсортированно
print("\(contactBook)")

// Число контактов , размер коллекции
contactBook.count

/*
 Системное API, предоставляющая доступ к записной книге на девайсе
 Так как это личная информация нужно запросить доступ и получить его
 
 Запрос разрешения является асинхронной операцией, но получение самих контактов будет ждать ответа (проблем с многопоточностью не возникнет)
 */

// Сначала проверяем текущий статус
// Делать запрос необходимо, если он == not determined (не определено)
let authStatus = CNContactStore.authorizationStatus(for: .contacts)
if .notDetermined == authStatus {
    let store = CNContactStore() // Запрос на доступ к контактам
    store.requestAccess(for: .contacts) {
        (access, accessError) in
        
        if access {
            print("Access granted") // Когда разрешили
        } else {
            print("Access denied. Reason: \(String(describing: accessError))")
        }
    }
} else if .denied == authStatus { // denied(отклонен)
    print("Access has already denied") // Доступ уже запрещен
} else {
    print("Access has already granted") // Доступ уже предоставлен
}

// Адреса и телефоны хранятся в системной адресной книге как классы CNLabeledValue
// Адрес
struct CNPostalAddressWrapper: AddressProtocol {
    // Переменная, которая содержит дженерик-тип CNLabeledValue
    private let address: CNLabeledValue<CNPostalAddress>
    
    init(_ address: CNLabeledValue<CNPostalAddress>) {
        self.address = address
    }
    
    // Добавляем все методы из протокола AddressProtocol
    var street: String {
        return self.address.value.street
    }
    
    var city: String {
        return self.address.value.city
    }
    
    var country: String {
        return self.address.value.country
    }
}

// Пытаемся инициализировать нашу структуру с тем значением, которое получили от системно-адресной книги
struct CNPhoneNumberWrapper: PhoneNumberProtocol {
    private let phone: CNLabeledValue<CNPhoneNumber>
    
    init(_ phone: CNLabeledValue<CNPhoneNumber>) {
        self.phone = phone
    }
    
    var number: String {
        return phone.value.stringValue
    }
    
    var type: PhoneType {
        guard let label = self.phone.label else {
            return .other
        }
        // Если инициализация удалась, вернем наш тип, иначе .other
        return PhoneType(rawValue: label) ?? .other
    }
}

// Чтобы можно было запросить контакты
extension CNContact: ContactProtocol {
    var address: [AddressProtocol] {
        return postalAddresses.map(CNPostalAddressWrapper.init)
    }
    
    var firstName: String? {
        return givenName
    }
    
    var lastName: String? {
        return familyName
    }
    
    var phones: [PhoneNumberProtocol] {
        return phoneNumbers.map(CNPhoneNumberWrapper.init)
    }
    
    var emails: [String] {
        return emailAddresses.map{ $0.value as String }
    }
}

// Экземпляр хранилища
let store = CNContactStore()

// Список интересующих нас полей
let keys = [CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactPostalAddressesKey,
            CNContactBirthdayKey] as [CNKeyDescriptor]

// Запрос
let request = CNContactFetchRequest(keysToFetch: keys)

// Для выполнения запросы передадим замыкание
// Где добавляем все контакты в нашу книгу
try? store.enumerateContacts(with: request, usingBlock: {
    (contact: CNContact, _: UnsafeMutablePointer<ObjCBool>) in
    contactBook.add(contact as ContactProtocol)
})

// Все контакты грузятся в нашу книгу
print("\(contactBook)")

// Запрос ближайших именинников
let birthdays = contactBook.upcomingBirthdayContacts()
let dateFormatter = DateFormatter()
// d - день, M - месяц, кол-во букв влияет на детаоизированность компонентов
dateFormatter.dateFormat = "dd MMMM"

// Проитерируемся по дням рождениям и выведем именя всех контактов в них
for (date, contacts) in birthdays {
    print(dateFormatter.string(from: date))
    
    for contact in contacts {
        print("\t\(contact.firstName ?? "") \(contact.lastName ?? "")")
    }
}
