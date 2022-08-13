#if canImport(Combine)

import class Combine.AnyCancellable
import class Combine.PassthroughSubject
import protocol Combine.Scheduler

/// An object that evaluates either the most-recent or first submitted block in a specified time interval.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct Throttle {

    private var token: AnyCancellable?
    private let subject: PassthroughSubject<() -> Void, Never> = .init()

    public init<S: Scheduler>(for interval: S.SchedulerTimeType.Stride, scheduler: S, latest: Bool) {
        self.token = subject
            .throttle(for: interval, scheduler: scheduler, latest: latest)
            .sink { $0() }
    }

    public init<S: Scheduler>(milliseconds: Int, scheduler: S, latest: Bool) {
        self.init(for: .milliseconds(milliseconds), scheduler: scheduler, latest: latest)
    }

    public func callAsFunction(_ newValue: @escaping () -> Void) {
        subject.send(newValue)
    }
}

#endif
