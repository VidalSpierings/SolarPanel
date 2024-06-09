//
//  VoltageCard.swift
//  SolarPanel
//
//  Created by Vidal on 10/05/2024.
//

// See image 'cardscomponents_structure' for visual representation of inheritance structure
// (Documentation.docc/Resources/cardscomponents_structure)

class VoltageCard: LiveInfoCard {
    
    convenience init(amount: String) {
        self.init(iconSystemName: "bolt.horizontal.fill", title: "Spanning zonnepaneel", amount: amount)
    }
}
