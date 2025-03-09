//
//  DateUtilsTest.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 7/2/25.
//

import XCTest
import SwiftData
@testable import SimpleMoneyTracker

final class DateUtilsTest: XCTestCase {
    
    func testDayRange() {
        let calendar = Calendar.current
        let components = DateComponents(year: 2024, month: 2, day: 7, hour: 12, minute: 30)
        let date = calendar.date(from: components)!
        
        let result = DateUtils.getFisrtAndLastDate(for: date, with: .day)
        
        // Verificar inicio del día
        let expectedStartComponents = DateComponents(year: 2024, month: 2, day: 7, hour: 0, minute: 0, second: 0)
        let expectedStart = calendar.date(from: expectedStartComponents)!
        XCTAssertTrue(calendar.isDate(result.0, equalTo: expectedStart, toGranularity: .second))
        
        // Verificar fin del día
        let expectedEndComponents = DateComponents(year: 2024, month: 2, day: 7, hour: 23, minute: 59, second: 59)
        let expectedEnd = calendar.date(from: expectedEndComponents)!
        XCTAssertTrue(calendar.isDate(result.1, equalTo: expectedEnd, toGranularity: .second))
    }
    
    func testWeekRange() {
        let calendar = Calendar.current
        let components = DateComponents(year: 2024, month: 2, day: 7) // Un miércoles
        let date = calendar.date(from: components)!
        
        let result = DateUtils.getFisrtAndLastDate(for: date, with: .week)
        
        // Verificar inicio de la semana (domingo)
        let expectedStartComponents = DateComponents(year: 2024, month: 2, day: 4, hour: 0, minute: 0, second: 0)
        let expectedStart = calendar.date(from: expectedStartComponents)!
        XCTAssertTrue(calendar.isDate(result.0, equalTo: expectedStart, toGranularity: .second))
        
        // Verificar fin de la semana (sábado)
        let expectedEndComponents = DateComponents(year: 2024, month: 2, day: 10, hour: 23, minute: 59, second: 59)
        let expectedEnd = calendar.date(from: expectedEndComponents)!
        XCTAssertTrue(calendar.isDate(result.1, equalTo: expectedEnd, toGranularity: .second))
    }
    
    func testYearRange() {
        let calendar = Calendar.current
        let components = DateComponents(year: 2024, month: 2, day: 7)
        let date = calendar.date(from: components)!
        
        let result = DateUtils.getFisrtAndLastDate(for: date, with: .year)
        
        // Verificar inicio del año
        let expectedStartComponents = DateComponents(year: 2024, month: 1, day: 1, hour: 0, minute: 0, second: 0)
        let expectedStart = calendar.date(from: expectedStartComponents)!
        XCTAssertTrue(calendar.isDate(result.0, equalTo: expectedStart, toGranularity: .second))
        
        // Verificar fin del año
        let expectedEndComponents = DateComponents(year: 2024, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        let expectedEnd = calendar.date(from: expectedEndComponents)!
        XCTAssertTrue(calendar.isDate(result.1, equalTo: expectedEnd, toGranularity: .second))
    }
}
