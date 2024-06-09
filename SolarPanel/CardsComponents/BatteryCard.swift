//
//  BatteryCard.swift
//  SolarPanel
//
//  Created by Vidal on 07/05/2024.
//

// See image 'cardscomponents_structure' for visual representation of inheritance structure
// (Documentation.docc/Resources/cardscomponents_structure)

class BatteryCard: LiveInfoCard {
    
    convenience init(amount: String) {
        self.init(iconSystemName: "bolt.batteryblock.fill", title: "spanning batterij", amount: amount)
    }
}
