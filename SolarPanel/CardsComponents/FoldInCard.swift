//
//  FoldInCard.swift
//  SolarPanel
//
//  Created by Vidal on 10/05/2024.
//

// See image 'cardscomponents_structure' for visual representation of inheritance structure
// (Documentation.docc/Resources/cardscomponents_structure)

class FoldInCard: ActionCard {
    
    convenience init(onCardTapped: MyGestureRecognizer) {
        self.init(systemName: "arrow.up.forward.and.arrow.down.backward.square.fill", buttonText: "Klap in", onCardTapped: onCardTapped)
    }
        
}
