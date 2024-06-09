//
//  DataSnapshots+CoreDataClass.swift
//  SolarPanel
//
//  Created by Vidal on 01/06/2024.
//
//

import CoreData
import UIKit

@objc(DataSnapshots)
public class DataSnapshots: NSManagedObject {
    
    private var snapshots: [DataSnapshots]?
            
    public func getSensorDataHistoryFromSnapshots() throws -> [DataSnapshots] {
                        
        do {
            
            let request = DataSnapshots.fetchRequest() as NSFetchRequest<DataSnapshots>
            
            let myPredicate = NSPredicate(format: "timestamp!=nil")
            
            let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
            
            // For workings of NSPredicate, see: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/AdditionalChapters/Introduction.html
            
            request.predicate = myPredicate
            
            request.sortDescriptors = [sortDescriptor]
                        
            snapshots = try self.managedObjectContext?.fetch(request)
                        
            print(snapshots ?? "defaulted")
                                                
        } catch {
            
            throw UIDocumentBrowserError(.generic)
            
            // likely the closest thing to a build-in CoreData-related Error
            
        }
                
        return snapshots ?? [DataSnapshots()]
            
    }
        
        public func addSnapshotToHistory(timestamp: String,
                                    spanningZonnepaneel: Double,
                                    spanningAccu: Double,
                                    stroomZonnepaneel: Int16) throws{
                                    
            do {
                
                guard let internalContext = self.managedObjectContext else {
                    
                    throw UIDocumentBrowserError(.generic)
                    
                }
                
                let newDataSnapshotEntry = DataSnapshots(context: internalContext)
                
                newDataSnapshotEntry.timestamp = timestamp
                newDataSnapshotEntry.spanning_zonnepaneel = spanningZonnepaneel
                newDataSnapshotEntry.spanning_batterij = spanningAccu
                newDataSnapshotEntry.stroom_zonnepaneel = stroomZonnepaneel
                
                try self.managedObjectContext?.save()
                
            } catch {
                
                throw UIDocumentBrowserError(.generic)
                
            }
            
        }
    
    public func deleteSnapshotFromHistory(toBeRemovedDatasnapshot: DataSnapshots){

      let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

      context?.delete(toBeRemovedDatasnapshot)

      try? context?.save()

      // Do nothing if fails (for now)
        
      }
    
}
