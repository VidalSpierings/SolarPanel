//
//  RefreshHistoryCard.swift
//  SolarPanel
//
//  Created by Vidal on 13/05/2024.
//

// See image 'cardscomponents_structure' for visual representation of inheritance structure
// (Documentation.docc/Resources/cardscomponents_structure)

class RefreshHistoryCard: ActionCard {
    
    convenience init(onCardTapped: MyGestureRecognizer) {
        self.init(systemName: "externaldrive.fill.badge.timemachine", buttonText: "Ververs historie", onCardTapped: onCardTapped)
    }
    
}
