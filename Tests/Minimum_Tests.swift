@testable import Minimum
import XCTest

final class Minimum_Tests: XCTestCase {

    static let queue: DispatchQueue = .init(label: "")

    let throttle: Throttle = .init(milliseconds: 500, scheduler: queue, latest: false)
    let debounce: Debounce = .init(milliseconds: 100, scheduler: queue, options: nil)

    func testThrottle() throws {
        let expectation: XCTestExpectation = expectation(description: #function)
        var value: Int = 0

        throttle { value = 1 }
        throttle { value = 2 }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) { [self] in
            throttle { value = 3 }
            throttle { value = 4 }
            throttle { value = 5 }
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            // `latest` is false so the first element in the async block expected
            XCTAssertEqual(value, 3)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testDebounce() throws {
        let expectation: XCTestExpectation = expectation(description: #function)
        var value: Int = 0

        debounce { value = 1 }
        debounce { value = 2 }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) { [self] in
            debounce { value = 3 }
            debounce { value = 4 }
            debounce { value = 5 }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) { [self] in
            debounce { value = 5 }
            debounce { value = 4 }
            debounce { value = 3 }
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            // debounce always evaluates the latest element after the interval
            XCTAssertEqual(value, 3)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}
