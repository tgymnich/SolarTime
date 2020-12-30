import XCTest
@testable import SolarTime

final class SolarTimeTests: XCTestCase {

    let latitude = Angle(value: 48.137222, unit: .degrees)
    let longitude = Angle(value: 11.575556, unit: .degrees)

    let calendar = Calendar(identifier: .gregorian)
    lazy var date = DateComponents(calendar: calendar, year: 2020, month: 12, day: 30, hour: 12).date!

    func testSunrise() {
        let solar = SolarTime(latitude: latitude, longitude: longitude, for: date)

        XCTAssertEqual(solar.sunrise(), Date(timeIntervalSinceReferenceDate: 631004712.0185316))
    }

    func testSunset() {
        let solar = SolarTime(latitude: latitude, longitude: longitude, for: date)

        XCTAssertEqual(solar.sunset(), Date(timeIntervalSinceReferenceDate: 631034970.4229057))
    }

    func testZenith() {
        let solar = SolarTime(latitude: latitude, longitude: longitude, for: date)

        XCTAssertEqual(solar.zenith(), Date(timeIntervalSinceReferenceDate: 631019841.2207186))
    }
}
