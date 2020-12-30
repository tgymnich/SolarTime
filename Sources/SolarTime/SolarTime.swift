import Foundation

public typealias Angle = Measurement<UnitAngle>
public typealias Height = Measurement<UnitLength>

public class SolarTime {
    public let latitude: Angle
    public let longitude: Angle
    public let elevation: Height
    public let date: Date

    /// Declination of the Sun
    public lazy var solarDeclination = Angle(value: asin(sin(λ) * sin(Angle(value: 23.44, unit: .degrees))), unit: .radians)

    /// Julian days since 1.1.2000 12:00
    private lazy var n: Double = date.julianDate.rounded() - 2451545.0 + 0.0008
    /// Mean solar noon
    private lazy var J: Double = n - longitude.converted(to: .degrees).value / Angle(value: 360, unit: .degrees).value
    /// Solar mean anomaly
    private lazy var M: Angle = Angle(value: (357.5291 + 0.98560028 * J), unit: .degrees) % 360
    /// Equation of the center
    private lazy var C: Double = 1.9148 * sin(M) + 0.0200 * sin(2*M) + 0.0003 * sin(3*M)
    /// Ecliptic longitude
    private lazy var λ: Angle = Angle(value: (M.converted(to: .degrees).value + C + 180 + 102.9372), unit: .degrees) % 360
    /// Solar transit (noon)
    private lazy var Jtransit = 2451545.0 + J + 0.0053 * sin(M) - 0.0069 * sin(2*λ)
    /// Hour angle
    private lazy var hourAngle: Angle = {
        let elevationOffset = Angle(value: -2.076, unit: .degrees) * sqrt(elevation.converted(to: .meters).value) / 60
        let ex1 = sin(Angle(value: -0.83, unit: .degrees) + elevationOffset) - sin(latitude) * sin(solarDeclination)
        let ex2 = cos(latitude) * cos(solarDeclination)
        return Angle(value: acos(ex1 / ex2), unit: .radians)
    }()

    public init(latitude: Angle, longitude: Angle, elevation: Height = .init(value: 0, unit: .meters), for date: Date = Date()) {
        self.latitude = latitude
        self.longitude = longitude
        self.elevation = elevation
        self.date = date
    }

    public enum Event {
        case official
//        case civil
//        case nautical
//        case astronimical
    }

    func sunrise(kind: Event = .official) -> Date? {
        let result = Jtransit - hourAngle.converted(to: .degrees).value / Angle(value: 360, unit: .degrees).value
        return Date(julianDate: result)
    }

    func sunset(kind: Event = .official) -> Date? {
        let result = Jtransit + hourAngle.converted(to: .degrees).value / Angle(value: 360, unit: .degrees).value
        return Date(julianDate: result)
    }

    func zenith(kind: Event = .official) -> Date? {
        return Date(julianDate: Jtransit)
    }

}
