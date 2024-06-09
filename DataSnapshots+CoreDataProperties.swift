//
//  DataSnapshots+CoreDataProperties.swift
//  SolarPanel
//
//  Created by Vidal on 01/06/2024.
//
//

import CoreData

extension DataSnapshots {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataSnapshots> {
        return NSFetchRequest<DataSnapshots>(entityName: "DataSnapshots")
    }

    @NSManaged public var positie: Int16
    @NSManaged public var spanning_batterij: Double
    @NSManaged public var spanning_zonnepaneel: Double
    @NSManaged public var stroom_zonnepaneel: Int16
    @NSManaged public var timestamp: String?
    
    // Note: Core Data does not support the datatype UInt8

}

extension DataSnapshots : Identifiable {

}
