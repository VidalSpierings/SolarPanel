//
//  SnapshotsCard.swift
//  SolarPanel
//
//  Created by Vidal on 13/05/2024.
//

// See image 'cardscomponents_structure' for visual representation of inheritance structure
// (Documentation.docc/Resources/cardscomponents_structure)

import Foundation
import UIKit
import CoreData

protocol SnapshotsCardDelegate {
    
    func didSelectCell(solarPanel: Zonnepaneel)
            
}

class SnapshotsCard: MyPhoneyCardComponent {
    
    var myTableView: MyTableView?
                
    // initialisers in this class created in accordance with "Initializer Chaining" rules in Swift
    
    private override init (background: UIColor) {
        
        //try? myTableView = MyTableView(())
                
        super.init(background: background)
                                
    }
    
    /*
    
    - private initialiser, because this initialiser ought only to be called in the convenience initialiser,
      and not when making an instance of this class.
    
    */
    
    convenience init(list: [DataSnapshots]) throws {
                
        self.init(background: UIColor(named: Constants.AppColors.blackCardColor) ?? .black)
        
        do {
            
            try myTableView = MyTableView(list: list)
                        
        } catch {
            
            throw UIDocumentBrowserError(.generic)
            
        }
                    
        self.addSubview(myTableView ?? UITableView(frame: CGRect(x: 0, y: 0, width: Constants.Dimensions.BigCard.size, height: Constants.Dimensions.BigCard.size)))
                
    }
    
    required init?(coder: NSCoder) {
        fatalError("NSCoding not supported from within this class")
    }
    
}

class MyTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var list: [DataSnapshots]?
    
    var context: NSManagedObjectContext?
    
    var myViewModel: MyViewModel?
    
    var snapshotsCardDelegate: SnapshotsCardDelegate?
            
    convenience init(list: [DataSnapshots]) throws {
                        
        self.init(frame: CGRect(x: 0, y: 0, width: Constants.Dimensions.BigCard.size, height: Constants.Dimensions.BigCard.size))
                       
        do {
            
            try myViewModel = MyViewModel()
            
        } catch {
                        
            throw UIDocumentBrowserError(.generic)
            
        }
        
        self.list = list
        
        self.backgroundColor = .black
        
        self.layer.cornerRadius = 20
        
        self.delegate = self
        self.dataSource = self
        
        // MARK: - ViewController codes

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        #if DEBUG
        print("Selected Table View item: \(String(describing: list?[indexPath.row]))")
        #endif
        
        snapshotsCardDelegate?.didSelectCell(solarPanel: Zonnepaneel(
            stroom_zonnepaneel: list?[indexPath.row].stroom_zonnepaneel ?? 0,
            spanning_zonnepaneel: list?[indexPath.row].spanning_zonnepaneel ?? 0,
            spanning_batterij: list?[indexPath.row].spanning_batterij ?? 0,
            positie: list?[indexPath.row].positie ?? 0,
            timestamp: list?[indexPath.row].timestamp ?? "1970-01-01T00:00:00Z"
        )
        )
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
        return list?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "MyCell")
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        
        let cellText = list?[indexPath.row].timestamp ?? ""
        cell.textLabel?.text = cellText
        
        return cell
                
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
        // allow for table view items to be editable. This is required for the "swipe to delete" functionality to work
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
                        
            guard let toBeRemovedDatasnapshot = self.list?[indexPath.row] else {
                                                
                return
                
                // Do nothing
                
            }
            
            myViewModel?.deleteSnapshotFromHistory(toBeRemovedDatasnapshot: toBeRemovedDatasnapshot)
            
            list?.remove(at: indexPath.row)
                                                                            
            self.beginUpdates()
            
            self.deleteRows(at: [indexPath], with: .top)
            
            self.endUpdates()
                                                            
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        // create one section in the tableView, so a title can be displayed for the tableView as a whole,
        // In accordance with the Apple human interface design guidelines
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Momentopnames"
        
    }
    
}
