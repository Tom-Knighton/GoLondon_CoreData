//
//  DBScheduleEntry+CoreDataProperties.swift
//  Go London
//
//  Created by Tom Knighton on 18/10/2022.
//
//

import Foundation
import CoreData


extension DBScheduleEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBScheduleEntry> {
        return NSFetchRequest<DBScheduleEntry>(entityName: "DBScheduleEntry")
    }

    @NSManaged public var terminatingAt: String?
    @NSManaged public var id: Int
    @NSManaged public var time: Date?
    @NSManaged public var schedule: DBTimetableSchedule?

}

extension DBScheduleEntry : Identifiable {

}
