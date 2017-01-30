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
    
    func testInsertDayWithoutCycle() {
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
        
        let uuid = persistenceManager.saveDay(day: day)
        let cycle = persistenceManager.getCycle(uuid: uuid)!
        XCTAssertTrue(cycle.days.contains(day))
    }
    
    func testInsertDayWithCycle() {
        let cycle = Cycle(days: [], uuid: UUID())
        let cycleUuid = persistenceManager.saveCycle(cycle: cycle)
        let day = Day(date: Date(), uuid: cycle.uuid)
        let dayUuid = persistenceManager.saveDay(day: day)
        
        let retrievedCycle = persistenceManager.getCycle(uuid: dayUuid)!
        XCTAssertTrue(retrievedCycle.days.contains(day))
    }
}
