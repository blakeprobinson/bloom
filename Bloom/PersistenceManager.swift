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
    
    static let cache = NSCache<NSString, Cycle>()
    
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
        
        if let cachedCycle = PersistenceManager.cache.object(forKey: uuid.uuidString as NSString) {
            return cachedCycle
        } else {
            let archiveURL = saveDirectory.appendingPathComponent(uuid.uuidString + ".bplist")
            guard FileManager.default.fileExists(atPath: archiveURL.path) else {
                return nil
            }
            guard let cycle = NSKeyedUnarchiver.unarchiveObject(withFile: archiveURL.path) as? Cycle else {
                return nil
            }
            PersistenceManager.cache.setObject(cycle, forKey: uuid.uuidString as NSString)
            return cycle
        }
    }
    
    func getEarlierCycle(uuid: UUID) -> Cycle? {
        return getAdjacentCycle(uuid: uuid, earlier: true)
    }
    
    func getLaterCycle(uuid: UUID) -> Cycle? {
        return getAdjacentCycle(uuid: uuid, earlier: false)
    }
    
    private func getAdjacentCycle(uuid: UUID, earlier: Bool) -> Cycle? {
        var cycles = getAllCyclesSorted()
        if earlier {
            cycles.reverse()
        }
        for (index, cycle) in cycles.enumerated() {
            if cycle.uuid == uuid {
                if index + 1 < cycles.count {
                    return cycles[index + 1]
                } else {
                    return nil
                }
            }
        }
        return nil
    }
    
    func saveCycle(cycle: Cycle) -> UUID {
        PersistenceManager.cache.removeObject(forKey: cycle.uuid.uuidString as NSString)
        let archiveURL = saveDirectory.appendingPathComponent(cycle.uuid.uuidString + ".bplist")
        let _ = NSKeyedArchiver.archiveRootObject(cycle, toFile: archiveURL.path)
        sendCyclesUpdatedNotification(cycle)
        return cycle.uuid
    }
    
    func saveDay(day: Day) -> UUID {
        let cycleToSave:Cycle!
        if let cycle = getAllCyclesSorted().first(where: { $0.uuid == day.uuid }) {
            cycleToSave = cycle
            //check to see if previous dates
        } else {
            let uuid = UUID()
            day.uuid = uuid
            cycleToSave = Cycle(days: [], uuid: uuid)
        }
        day.calibrateDate()
        cycleToSave.attach(day)
        
        return saveCycle(cycle: cycleToSave)
    }
    
    func moveDays(from cycle1: Cycle, to nextCycle: Cycle) {
        
    }
    //two cases...day and maybe subsequent days start brand new cycle
    //or day and maybe subsequent days get added onto next cycle
    //thereby changing the start date of the next cycle.
    
    func removeCycle(_ cycle: Cycle) {
        let deleteURL = saveDirectory.appendingPathComponent(cycle.uuid.uuidString + ".bplist")
        do {
            try FileManager().removeItem(at: deleteURL)
            PersistenceManager.cache.removeObject(forKey: cycle.uuid.uuidString as NSString)
            sendCyclesUpdatedNotification(cycle)
        } catch {
            NSLog("error deleting cycle: \(error)")
        }
    }
    
    func shouldDayStartCycle(_ day: Day) -> Bool {
        
        return false
    }
    
    private func sendCyclesUpdatedNotification(_ cycle: Cycle) {
        var userInfo = [String : UUID]()
        //if cycle exists in cache or file system
        if let cycle = getCycle(uuid: cycle.uuid) {
            let cycleJustSaved = "cycleJustSaved"
            userInfo[cycleJustSaved] = cycle.uuid
        }
        let notification = Notification(name: Notification.Name(rawValue: "cycles updated"), object: self, userInfo: userInfo)
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
