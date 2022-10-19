//
//  DBConverter.swift
//  Go London
//
//  Created by Tom Knighton on 18/10/2022.
//

import Foundation
import GoLondonSDK
import CoreData

public class GoLondonDB {
    
    private static var cache = PersistenceController.shared.container.viewContext
    
    /// Saves (overwriting if necessary) a timetable to CoreData
    /// - Parameter timetable: The timetable to save/update
    /// - Returns: Whether or not the save was succesful
    public static func DBSaveTimetable(_ timetable: StopPointTimetable) -> Bool {
        if DBIsTimetableCached(stopPointId: timetable.stopPointId, lineId: timetable.lineId, direction: timetable.lineId) {
            do {
                let dbEntry = try cache.fetch(DBTimetable.findOne(stopPointId: timetable.stopPointId, lineId: timetable.lineId, direction: timetable.direction)).first! as NSManagedObject
                
                cache.delete(dbEntry)
                
                return addTimetable()

            } catch {
                print("[GLCACHE]: Failed to save timetable, (\(timetable.stopPointId), \(timetable.lineId), \(timetable.direction)): \(error.localizedDescription)")
                return false
            }
        } else {
            return addTimetable()
        }
        
        
        func addTimetable() -> Bool {
            do {
                let newTimetable = DBTimetable(context: cache)
                newTimetable.stopPointId = timetable.stopPointId
                newTimetable.lineId = timetable.lineId
                newTimetable.direction = timetable.direction
                
                timetable.schedules.forEach { sched in
                    let newSchedule = DBTimetableSchedule(context: cache)
                    newSchedule.timetable = newTimetable
                    newSchedule.name = sched.name
                    newSchedule.towards = sched.towards
                    
                    sched.entries.forEach { entry in
                        let newEntry = DBScheduleEntry(context: cache)
                        newEntry.id = entry.id
                        newEntry.time = entry.time
                        newEntry.terminatingAt = entry.terminatingAt
                        newEntry.schedule = newSchedule
                        newSchedule.addToEntries(newEntry)
                    }
                    
                    newTimetable.addToSchedules(newSchedule)
                }
                
                cache.insert(newTimetable)
                try cache.save()
                
                return true
            } catch {
                print("[GLCACHE]: Failed to add timetable, (\(timetable.stopPointId), \(timetable.lineId), \(timetable.direction)): \(error.localizedDescription)")
                return false
            }
        }
    }
    
    public static func DBRemoveCachedTimetable(for stopPointId: String, lineId: String, direction: String) {
        if DBIsTimetableCached(stopPointId: stopPointId, lineId: lineId, direction: direction) {
            do {
                let dbEntry = try cache.fetch(DBTimetable.findOne(stopPointId: stopPointId, lineId: lineId, direction: direction)).first! as NSManagedObject
                cache.delete(dbEntry)
                try cache.save()
            } catch {
                print("[GLCACHE]: Failed to remove timetable, (\(stopPointId), \(lineId), \(direction)): \(error.localizedDescription)")
            }
        }
    }
    
    /// Returns a StopPointTimetable from the cache, if it is saved
    /// - Parameters:
    ///   - stopPointId: The id of the stop point the timetable is saved under
    ///   - lineId: The line id of the timetable
    ///   - direction: The direction, inbound or outbound, of the timetable
    public static func DBGetCachedTimetable(for stopPointId: String, lineId: String, direction: String) -> StopPointTimetable? {
        do {
            if !DBIsTimetableCached(stopPointId: stopPointId, lineId: lineId, direction: direction) {
                return nil
            }
            
            let dbEntry = try cache.fetch(DBTimetable.findOne(stopPointId: stopPointId, lineId: lineId, direction: direction)).first
            if let dbEntry {
                
                var schedules: [TimetableSchedule] = []
                dbEntry.schedules.forEach { dbSchedule in
                    var entries: [TimetableEntry] = []
                    dbSchedule.entries.forEach { dbEntry in
                        entries.append(TimetableEntry(terminatingAt: dbEntry.terminatingAt, id: dbEntry.id, time: dbEntry.time))
                    }
                    let schedule = TimetableSchedule(name: dbSchedule.name, towards: dbSchedule.towards, entries: entries)
                    schedules.append(schedule)
                }
                
                let timetable = StopPointTimetable(lineId: dbEntry.lineId, stopPointId: dbEntry.stopPointId, direction: dbEntry.direction, schedules: schedules)
                return timetable
                
            } else {
                print("[GLCACHE]: Failed to retrieve timetable, (\(stopPointId), \(lineId), \(direction)): does not exist after check")
                return nil
            }
        } catch {
            print("[GLCACHE]: Failed to retrieve timetable, (\(stopPointId), \(lineId), \(direction)): \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Whether or not the specified timetable exists in the cache
    /// - Parameters:
    ///   - stopPointId: The id of the stop point the timetable is saved under
    ///   - lineId: The line id of the timetable
    ///   - direction: The direction, inbound or outbound, of the timetable
    public static func DBIsTimetableCached(stopPointId: String, lineId: String, direction: String) -> Bool {
        do {
            return try cache.fetch(DBTimetable.findOne(stopPointId: stopPointId, lineId: lineId, direction: direction)).isEmpty == false
        } catch {
            print("[GLCACHE]: Failed to retrieve timetable existence, (\(stopPointId), \(lineId), \(direction)): \(error.localizedDescription)")
            return false
        }
    }
}
