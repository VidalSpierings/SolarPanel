//
//  MyViewModel.swift
//  SolarPanel
//
//  Created by Vidal on 13/05/2024.
//

import UIKit

protocol MyViewModelDelegate {
        
    func didFinishDataSubmission()
        
}

class MyViewModel {
    
    var snapshots: [DataSnapshots]?
    
    var myViewModelDelegate: MyViewModelDelegate?
    
    var dataSnapShotsModel: DataSnapshots
    
    private init(_: ()) throws{
        
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            
            throw UIDocumentBrowserError(.generic)
            
        }
        
        dataSnapShotsModel = DataSnapshots(context: context)
                
    }
    
    convenience init() throws {
        
        do {
            
            try self.init(())
            
        } catch {
            
            throw UIDocumentBrowserError(.generic)
            
        }
                                
    }

    func getDataSnapshots() throws -> [DataSnapshots] {
                
        do {
                        
            try snapshots = dataSnapShotsModel.getSensorDataHistoryFromSnapshots()
                        
            
            
            return snapshots ?? [DataSnapshots()]
            
        } catch {
            
            throw UIDocumentBrowserError(.generic)
            
        }
                
    }
    
    func addDataSnapshot(timestamp: String, spanningZonnepaneel: Double, spanningAccu: Double, stroomZonnepaneel: Int16) throws{
        
        do {
            
            try dataSnapShotsModel.addSnapshotToHistory(
                timestamp: timestamp,
                spanningZonnepaneel: spanningZonnepaneel,
                spanningAccu: spanningAccu,
                stroomZonnepaneel: stroomZonnepaneel
            )
            
            self.myViewModelDelegate?.didFinishDataSubmission()
            
        } catch {
            
            throw UIDocumentBrowserError(.generic)
            
        }
        
    }
    
    public func deleteSnapshotFromHistory(toBeRemovedDatasnapshot: DataSnapshots){
        
        dataSnapShotsModel.deleteSnapshotFromHistory(toBeRemovedDatasnapshot: toBeRemovedDatasnapshot)
                
    }
        
}


