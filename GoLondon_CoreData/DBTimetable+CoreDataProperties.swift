//
//  DBTimetable+CoreDataProperties.swift
//  Go London
//
//  Created by Tom Knighton on 18/10/2022.
//
//

import Foundation
import CoreData


extension DBTimetable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBTimetable> {
        return NSFetchRequest<DBTimetable>(entityName: "DBTimetable")
    }

    @NSManaged public var lineId: String?
    @NSManaged public var stopPointId: String?
    @NSManaged public var direction: String?
    @NSManaged public var schedules: Set<DBTimetableSchedule>?

}

// MARK: Generated accessors for schedules
extension DBTimetable {

    @objc(addSchedulesObject:)
    @NSManaged public func addToSchedules(_ value: DBTimetableSchedule)

    @objc(removeSchedulesObject:)
    @NSManaged public func removeFromSchedules(_ value: DBTimetableSchedule)

    @objc(addSchedules:)
    @NSManaged public func addToSchedules(_ values: NSSet)

    @objc(removeSchedules:)
    @NSManaged public func removeFromSchedules(_ values: NSSet)

}

extension DBTimetable : Identifiable {

}
