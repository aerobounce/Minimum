import Combine
import Foundation

@propertyWrapper
struct DiffedPublished<Value> where Value: Equatable {

    private let underlyingSubject: CurrentValueSubject<Value, Never>

    init(wrappedValue value: Value) {
        self.underlyingSubject = CurrentValueSubject(value)
    }

    var wrappedValue: Value {
        nonmutating get { underlyingSubject.value }
        nonmutating set {
            if case underlyingSubject.value = newValue {
                return
            }
            underlyingSubject.send(newValue)
        }
    }

    var projectedValue: AnyPublisher<Value, Never> {
        underlyingSubject.removeDuplicates().eraseToAnyPublisher()
    }

    @discardableResult
    nonmutating
    func batchUpdate(_ update: (inout Value) -> Void) -> Bool {
        var copy: Value = wrappedValue
        update(&copy)
        wrappedValue = copy
        return true
    }
}
