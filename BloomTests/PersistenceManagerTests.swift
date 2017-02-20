//
//  PersistenceManagerTests.swift
//  BloomTests
//
//  Created by Blake Robinson on 1/24/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import XCTest

class PersistenceManagerTests: XCTestCase {
    
    let persistenceManager = PersistenceManager()
    let day = Day(
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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        //use file manager to clean documents folder and delete all cycles if need be...
        do {
            let FM = FileManager()
            let urls = try FM.contentsOfDirectory(at: persistenceManager.saveDirectory, includingPropertiesForKeys: nil, options: [])
            urls.forEach({
                do {
                    try FM.removeItem(at: $0)
                } catch {
                    NSLog("error removing file: \(error)")
                }
            })
        } catch {
            NSLog("error getting list of url's: \(error)")
        }
        
    }
    
    func testGetIDs() {
        let cycleUUID = UUID()
        let cycle = Cycle(days: [day], uuid: cycleUUID)
        let uuid = persistenceManager.saveCycle(cycle: cycle)
        
        XCTAssertEqual([uuid.uuidString], persistenceManager.getIDs(), "getIDs result is not equal to the expected result")
    }
    
    func testGetIDsWhenNoneExist() {
        XCTAssertEqual([], persistenceManager.getIDs(), "getIDs result is not equal to empty array")
    }
    
    func testGetAllCyclesSorted() {
        let cycleUUID = UUID()
        let laterCycle = Cycle(days: [day], uuid: cycleUUID)
        let _ = persistenceManager.saveCycle(cycle: laterCycle)
        
        let calendar = Calendar(identifier: .gregorian)
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: Date())!
        let day2 = Day(date: twoDaysAgo, uuid: UUID())
        let earlierCycle = Cycle(days: [day2], uuid: day2.uuid!)
        let _ = persistenceManager.saveCycle(cycle: earlierCycle)
        
        let expectedResult = [earlierCycle, laterCycle]
        let actualResult = persistenceManager.getAllCyclesSorted()
        
        XCTAssertEqual(expectedResult, actualResult, "The expected result of getAllCyclesSorted does not match the actual result")
        
        
    }
    
    func testGetCycle() {
        let cycleUUID = UUID()
        let cycle = Cycle(days: [day], uuid: cycleUUID)
        let uuid = persistenceManager.saveCycle(cycle: cycle)
        let retrievedCycle = persistenceManager.getCycle(uuid: uuid)!
        
        XCTAssertTrue(cycle == retrievedCycle, "the retrieved cycle is not the same as the saved cycle")
        XCTAssertTrue(PersistenceManager.cache.object(forKey: uuid.uuidString as NSString) == cycle, "The retreived cycle is not in the Persistence Manager Cache")
    }
    
    func testGetCycleForNilParam() {
        XCTAssertNil(persistenceManager.getCycle(uuid: nil), "getCycle does not return nil when nil is passed as a parameter")
    }
    
    func testGetCycleForCycleWithNoDays() {
        let cycleUUID = UUID()
        let cycle = Cycle(days: [], uuid: cycleUUID)
        let uuid = persistenceManager.saveCycle(cycle: cycle)
        
        XCTAssertNil(persistenceManager.getCycle(uuid: uuid), "getCycle did not return nil when retrieving a cycle with no days")
    }
    
    func testGetEarlierCycle() {
        let laterCycleUUID = UUID()
        let laterCycle = Cycle(days: [day], uuid: laterCycleUUID)
        let _ = persistenceManager.saveCycle(cycle: laterCycle)
        
        let calendar = Calendar(identifier: .gregorian)
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: Date())!
        let day2 = Day(date: twoDaysAgo, uuid: UUID())
        let earlierCycle = Cycle(days: [day2], uuid: day2.uuid!)
        let _ = persistenceManager.saveCycle(cycle: earlierCycle)
        
        let retrievedEarlierCycle = persistenceManager.getEarlierCycle(uuid: laterCycleUUID)
        
        XCTAssertTrue(earlierCycle == retrievedEarlierCycle, "Earlier cycle does not equal retrieved cycle from earlierAdjacentCycle")
    }
    
    func testGetLaterCycle() {
        let laterCycleUUID = UUID()
        let laterCycle = Cycle(days: [day], uuid: laterCycleUUID)
        let _ = persistenceManager.saveCycle(cycle: laterCycle)
        
        let calendar = Calendar(identifier: .gregorian)
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: Date())!
        let day2 = Day(date: twoDaysAgo, uuid: UUID())
        let earlierCycle = Cycle(days: [day2], uuid: day2.uuid!)
        let earlierCycleUUID = persistenceManager.saveCycle(cycle: earlierCycle)
        
        let retrievedLaterCycle = persistenceManager.getLaterCycle(uuid: earlierCycleUUID)
        
        XCTAssertTrue(laterCycle == retrievedLaterCycle, "Later cycle does not equal retrieved cycle from getLaterCycle")
    }
    
    func testSaveDayWithoutCycle() {
        let uuid = persistenceManager.saveDay(day: day)
        let cycle = persistenceManager.getCycle(uuid: uuid)!
        
        XCTAssertTrue(cycle.days.contains(day), "The retreived cycle does not contain the saved day")
    }
    
    func testSaveDayWithCycle() {
        let cycle = Cycle(days: [], uuid: UUID())
        let _ = persistenceManager.saveCycle(cycle: cycle)
        let day = Day(date: Date(), uuid: cycle.uuid)
        let dayUuid = persistenceManager.saveDay(day: day)
        let retrievedCycle = persistenceManager.getCycle(uuid: dayUuid)!
        
        XCTAssertTrue(retrievedCycle.days.contains(day), "The retreived cycle does not contain the saved day")
    }
    
    func testSaveCycle() {
        let cycleUUID = UUID()
        let cycle = Cycle(days: [day], uuid: cycleUUID)
        let uuid = persistenceManager.saveCycle(cycle: cycle)
        let retrievedCycle = persistenceManager.getCycle(uuid: uuid)!
        
        XCTAssertTrue(cycle == retrievedCycle, "The saved cycle and the retrieved cycle are not equal")
        
    }
}
