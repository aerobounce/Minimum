import Foundation

@discardableResult
func diffedUpdate<Value: Equatable>(to value: Value,
                                    transform: (inout Value) -> Void,
                                    update: (Value) -> Void) -> Bool {
    /// A value type passed to the `inout` parameter will call `willSet` & `didSet` even if no changes were made.
    /// So take it as a normal value, make a copy, then run `transform`.
    /// - https://docs.swift.org/swift-book/LanguageGuide/Properties.html#ID262
    var copy: Value = value
    transform(&copy)
    if case copy = value {
        return false
    }
    update(copy)
    return true
}

@discardableResult
func assignDiff<Value: Equatable>(oldValue: Value,
                                  newValue: Value,
                                  update: (Value) -> Void) -> Bool {
    if case oldValue = newValue {
        return false
    }
    update(newValue)
    return true
}

/// As soon as a value is passed to the `value` parameter, it calls `didSet`.

// func performBatchUpdates<Value: Equatable>(_ value: inout Value, _ newValue: Value) {
//     if case value = newValue { return }
//     value = newValue
// }

// func performBatchUpdates<Value: Equatable>(_ value: inout Value, _ transform: (inout Value) -> Void) {
//     var valueCopy: Value = value
//     transform(&valueCopy)
//     if case value = valueCopy { return }
//     value = valueCopy
// }
