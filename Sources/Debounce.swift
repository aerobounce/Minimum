#if canImport(Combine)

import class Combine.AnyCancellable
import class Combine.PassthroughSubject
import protocol Combine.Scheduler

/// An object that evaluates submitted blocks only after a specified time interval elapses between events.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct Debounce {

    private var token: AnyCancellable?
    private let subject: PassthroughSubject<() -> Void, Never> = .init()

    public init<S: Scheduler>(for dueTime: S.SchedulerTimeType.Stride, scheduler: S, options: S.SchedulerOptions? = nil) {
        self.token = subject
            .debounce(for: dueTime, scheduler: scheduler)
            .sink { $0() }
    }

    public init<S: Scheduler>(milliseconds: Int, scheduler: S, options: S.SchedulerOptions? = nil) {
        self.init(for: .milliseconds(milliseconds), scheduler: scheduler)
    }

    public func callAsFunction(_ block: @escaping () -> Void) {
        subject.send(block)
    }
}

#endif
