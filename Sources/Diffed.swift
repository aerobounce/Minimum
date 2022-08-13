import Foundation

/// A propertyWrapper that updates the stored property
/// only if the assigned value is different from the current value.
@propertyWrapper
struct Diffed<Value> where Value: Equatable {

    private var underlyingValue: Value

    init(wrappedValue value: Value) {
        self.underlyingValue = value
    }

    var wrappedValue: Value {
        nonmutating get { underlyingValue }
        mutating set {
            if case underlyingValue = newValue {
                return
            }
            underlyingValue = newValue
        }
    }

    @discardableResult
    mutating
    func batchUpdate(_ update: (inout Value) -> Void) -> Bool {
        var copy: Value = wrappedValue
        update(&copy)
        wrappedValue = copy
        return true
    }
}
