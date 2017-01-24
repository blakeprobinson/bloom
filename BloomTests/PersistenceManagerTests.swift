//
//  PersistenceManagerTests.swift
//  BloomTests
//
//  Created by Blake Robinson on 1/24/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import XCTest

class PersistenceManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        //use file manager to clean documents folder and delete all cycles if need be...
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInsertDayWithoutCycle() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let persistenceManager = PersistenceManager()
        print(persistenceManager.getAllCyclesSorted())
        //let day =
        //XCTAssertNotNil(day.uuid)
        
    }
    
}
