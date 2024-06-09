//
//  FoldOutCard.swift
//  SolarPanel
//
//  Created by Vidal on 10/05/2024.
//

// See image 'cardscomponents_structure' for visual representation of inheritance structure
// (Documentation.docc/Resources/cardscomponents_structure)

class FoldOutCard: ActionCard {
    
    convenience init(onCardTapped: MyGestureRecognizer) {
        self.init(systemName: "arrow.down.backward.and.arrow.up.forward.square.fill", buttonText: "Klap uit", onCardTapped: onCardTapped)
    }
        
}
