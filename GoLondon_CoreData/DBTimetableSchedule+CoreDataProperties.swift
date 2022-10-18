//
//  DBTimetableSchedule+CoreDataProperties.swift
//  Go London
//
//  Created by Tom Knighton on 18/10/2022.
//
//

import Foundation
import CoreData


extension DBTimetableSchedule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBTimetableSchedule> {
        return NSFetchRequest<DBTimetableSchedule>(entityName: "DBTimetableSchedule")
    }

    @NSManaged public var name: String?
    @NSManaged public var towards: [String]?
    @NSManaged public var timetable: DBTimetable?
    @NSManaged public var entries: Set<DBScheduleEntry>?

}

// MARK: Generated accessors for entries
extension DBTimetableSchedule {

    @objc(addEntriesObject:)
    @NSManaged public func addToEntries(_ value: DBScheduleEntry)

    @objc(removeEntriesObject:)
    @NSManaged public func removeFromEntries(_ value: DBScheduleEntry)

    @objc(addEntries:)
    @NSManaged public func addToEntries(_ values: NSSet)

    @objc(removeEntries:)
    @NSManaged public func removeFromEntries(_ values: NSSet)

}

extension DBTimetableSchedule : Identifiable {

}
