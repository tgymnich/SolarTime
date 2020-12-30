//
//  Extensions.swift
//  
//
//  Created by Tim Gymnich on 29.12.20.
//

import Foundation

extension Date {
    /// The Julian date (JD) of any instant is the Julian day number plus the fraction of a day since the preceding noon in Universal Time.
    /// Julian dates are expressed as a Julian day number with a decimal fraction added.
    var julianDate: Double {
        let referenceJulianDate = 2440587.5
        return referenceJulianDate + self.timeIntervalSince1970 / (24 * 60 * 60)
    }

    /// The Julian date (JD) of any instant is the Julian day number plus the fraction of a day since the preceding noon in Universal Time.
    /// Julian dates are expressed as a Julian day number with a decimal fraction added.
    init(julianDate: Double) {
        let referenceJulianDate = 2440587.5
        self.init(timeIntervalSince1970: (julianDate - referenceJulianDate) *  (24 * 60 * 60))
    }
}

func sin(_ angle: Angle) -> Double {
    return sin(angle.converted(to: .radians).value)
}

func cos(_ angle: Angle) -> Double {
    return cos(angle.converted(to: .radians).value)
}

func % (lhs: Angle, rhs: Double) -> Angle {
    return Angle(value: lhs.value.truncatingRemainder(dividingBy: rhs), unit: lhs.unit)
}
