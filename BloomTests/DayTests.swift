//
//  DayTests.swift
//  Bloom
//
//  Created by Blake Robinson on 2/21/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import XCTest

class DayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAssignCategory() {
        let day1 = Day(
            bleeding: Day.Bleeding.init(intensity: "Moderate"),
            dry: nil,
            mucus: nil,
            observation: 1,
            intercourse: true,
            lubrication: true,
            pasty: false,
            date: Date(),
            notes: nil,
            isFirstDayOfCycle: false)
        
        let expected1 = Day.InternalCategory.mucus
        let actual1 = day1.internalCategory
        
        XCTAssertEqual(expected1, actual1, "When a day's lubrication property is true, the day's internal category should be mucus")
        
        let day2 = Day(
            bleeding: Day.Bleeding.init(intensity: "Moderate"),
            dry: nil,
            mucus: nil,
            observation: 1,
            intercourse: true,
            lubrication: false,
            pasty: false,
            date: Date(),
            notes: nil,
            isFirstDayOfCycle: false)
        
        let expected2 = Day.InternalCategory.bleeding
        let actual2 = day2.internalCategory
        
        XCTAssertEqual(expected2, actual2, "When a day's lubrication property is false, bleeding is not nil and dry and mucus are nil, the day's internal category should be bleeding")
        
        let day3 = Day(
            bleeding: nil,
            dry: Day.Dry.init(observation: "Dry"),
            mucus: nil,
            observation: 1,
            intercourse: true,
            lubrication: false,
            pasty: false,
            date: Date(),
            notes: nil,
            isFirstDayOfCycle: false)
        
        let expected3 = Day.InternalCategory.dry
        let actual3 = day3.internalCategory
        
        XCTAssertEqual(expected3, actual3, "When a day's lubrication property is false, dry is not nil and bleeding and mucus are nil, the day's internal category should be dry")
        
        let day4 = Day(
            bleeding: nil,
            dry: nil,
            mucus: Day.Mucus.init(length: "1/4", color: "Clear", consistency: nil),
            observation: 1,
            intercourse: true,
            lubrication: false,
            pasty: false,
            date: Date(),
            notes: nil,
            isFirstDayOfCycle: false)
        
        let expected4 = Day.InternalCategory.mucus
        let actual4 = day4.internalCategory
        
        XCTAssertEqual(expected4, actual4, "When a day's lubrication property is false, mucus is not nil and dry and bleeding are nil, the day's internal category should be dry")
        
        let day5 = Day(
            bleeding: nil,
            dry: nil,
            mucus: Day.Mucus.init(length: nil, color: nil, consistency: nil),
            observation: 1,
            intercourse: true,
            lubrication: false,
            pasty: false,
            date: Date(),
            notes: nil,
            isFirstDayOfCycle: false)
        
        let actual5 = day5.internalCategory
        
        XCTAssertNil(actual5, "When a day's lubrication property is false, mucus is not nil but its propertiesare nil and dry and bleeding are nil, the day's internal category should be nil")
        
        let day6 = Day(
            bleeding: nil,
            dry: nil,
            mucus:nil,
            observation: 1,
            intercourse: true,
            lubrication: false,
            pasty: false,
            date: Date(),
            notes: nil,
            isFirstDayOfCycle: false)
        
        let actual6 = day6.internalCategory
        
        XCTAssertNil(actual6, "When a day's lubrication property is false and bleeding, dry and mucus are nil, the day's internal category should be nil")
        
    }
    
    func testShortDescription() {
        let dry = Day.Dry.init(observation: "Dry")
        let day1 = Day(
            bleeding: nil,
            dry: dry,
            mucus: nil,
            observation: 1,
            intercourse: true,
            lubrication: true,
            pasty: false,
            date: Date(),
            notes: nil,
            isFirstDayOfCycle: false)
        
        let expected1 = dry?.observation.rawValue
        let actual1 = day1.shortDescription
        
        XCTAssertEqual(expected1, actual1, "Day with internalCategory of mucus and a dry observation does not match the description that it should")
        
        let bleeding = Day.Bleeding.init(intensity: "Heavy")
        let day2 = Day(
            bleeding: bleeding,
            dry: nil,
            mucus: nil,
            observation: 1,
            intercourse: true,
            lubrication: true,
            pasty: false,
            date: Date(),
            notes: nil,
            isFirstDayOfCycle: false)
        
        let expected2 = bleeding?.intensity.rawValue
        let actual2 = day2.shortDescription
        
        XCTAssertEqual(expected2, actual2, "Day with internalCategory of mucus and a bleeding observation does not match the description that it should")
        
        let mucus3 = Day.Mucus.init(length: "1/4", color: "Clear", consistency: nil)
        let day3 = Day(
            bleeding: nil,
            dry: nil,
            mucus: mucus3,
            observation: 1,
            intercourse: true,
            lubrication: false,
            pasty: false,
            date: Date(),
            notes: nil,
            isFirstDayOfCycle: false)
        
        let expected3 = "\(mucus3!.length!.rawValue) in. \(mucus3!.color!.rawValue)"
        let actual3 = day3.shortDescription
        
        XCTAssertEqual(expected3, actual3, "Day with internalCategory of mucus where length and color properties are populated does not match the description that it should")
        
        let mucus4 = Day.Mucus.init(length: "1/4", color: "Clear", consistency: "Pasty")
        let day4 = Day(
            bleeding: nil,
            dry: nil,
            mucus: mucus4,
            observation: 1,
            intercourse: true,
            lubrication: false,
            pasty: false,
            date: Date(),
            notes: nil,
            isFirstDayOfCycle: false)
        
        let expected4 = "\(mucus4!.length!.rawValue) in. \(mucus4!.color!.rawValue) \(mucus4!.consistency!.rawValue)"
        let actual4 = day4.shortDescription
        
        XCTAssertEqual(expected4, actual4, "Day with internalCategory of mucus where length, color and consistency properties are populated does not match the description that it should")
        
        let day5 = Day(
            bleeding: nil,
            dry: nil,
            mucus:nil,
            observation: 1,
            intercourse: true,
            lubrication: false,
            pasty: false,
            date: Date(),
            notes: nil,
            isFirstDayOfCycle: false)
        
        XCTAssertNil(day5.internalCategory)
        XCTAssertNil(day5.shortDescription, "When an internal category for a day is nil, short description property should be nil")
    }
    
}
