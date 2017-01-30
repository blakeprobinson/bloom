//
//  PersistenceManager.swift
//  Bloom
//
//  Created by Blake Robinson on 1/3/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import Foundation

class PersistenceManager {
    
    var saveDirectory: URL = {
        return FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    }()
    
    func getIDs() -> [String] {
        let result: [String]
        do {
            result = try FileManager().contentsOfDirectory(atPath: saveDirectory.path)
                .filter({ $0.contains(".bplist") && !$0.contains("_") })
                .map({ $0.replacingOccurrences(of: ".bplist", with: "")})
        } catch {
            NSLog("error getting list of id's: \(error)")
            result = []
        }
        return result
    }
    
    func getAllCyclesSorted() -> [Cycle] {
        //eventually may want to create a file with a sorted list of the cycle uuid's to query.
        return getIDs().flatMap({ uuid in getCycle(uuid: UUID(uuidString: uuid)) }).sorted(by: { $0.startDate < $1.startDate })
    }
    
    func getCycle(uuid: UUID?) -> Cycle? {
        guard let uuid = uuid else {
            return nil
        }
        let archiveURL = saveDirectory.appendingPathComponent(uuid.uuidString + ".bplist")
        print("getCycle path " + archiveURL.absoluteString)
        guard FileManager.default.fileExists(atPath: archiveURL.path) else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(withFile: archiveURL.path) as? Cycle
        
    }
    
    func getEarlierCycle(uuid: UUID) -> Cycle? {
        return getAdjacentCycle(uuid: uuid, earlier: true)
    }
    
    func getLaterCycle(uuid: UUID) -> Cycle? {
        return getAdjacentCycle(uuid: uuid, earlier: false)
    }
    
    private func getAdjacentCycle(uuid: UUID, earlier: Bool) -> Cycle? {
        var cycles = getAllCyclesSorted()
        if !earlier {
            cycles = cycles.reversed()
        }
        for (index, cycle) in cycles.enumerated() {
            if cycle.uuid == uuid {
                if index + 1 < cycles.count {
                    return cycles[index + 1]
                }
            }
        }
        return nil
    }
    
    func saveCycle(cycle: Cycle) {
        let archiveURL = saveDirectory.appendingPathComponent(cycle.uuid.uuidString + ".bplist")
        print("saveCycle path " + archiveURL.path)
        let didSave = NSKeyedArchiver.archiveRootObject(cycle, toFile: archiveURL.path)
        print("did save cycle \(didSave)")
        sendCycleSavedNotification()
    }
    
    func saveDay(day: Day) {
        let cycleToSave:Cycle!
        if let cycle = getAllCyclesSorted().first(where: { $0.uuid == day.uuid }) {
            cycleToSave = cycle
        } else {
            cycleToSave = Cycle(days: [day], uuid: UUID())
        }
        day.calibrateDate()
        cycleToSave.attach(day)
        
        saveCycle(cycle: cycleToSave)
    }
    
    func shouldDayStartCycle(_ day: Day) -> Bool {
        
        return false
    }
    
    private func sendCyclesUpdatedNotification() {
        let notification = Notification(name: Notification.Name(rawValue: "cycles updated"))
        NotificationCenter.default.post(notification)
    }
}

fileprivate extension Cycle {
    func attach(_ day: Day) {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        if let sameDay = days.first(where: { calendar.isDate($0.date, inSameDayAs: day.date) }) {
            let index = days.index(of: sameDay)!
            days.replaceSubrange(index..<(index + 1), with: [day])
        } else {
            if let index = days.index(where: { $0.date > day.date }) {
                days.insert(day, at: index)
            } else {
                days.append(day)
            }
        }
    }
}
