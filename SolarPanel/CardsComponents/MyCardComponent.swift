//
//  MyCardComponent.swift
//  SolarPanel
//
//  Created by Vidal on 02/05/2024.
//

// See image 'cardscomponents_structure' for visual representation of inheritance structure
// (Documentation.docc/Resources/cardscomponents_structure)

import Cards

class MyCardComponent: CardHighlight {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        self.title = ""
        self.itemTitle = ""
        self.itemSubtitle = ""
        self.buttonText = ""
        self.shadowBlur = 0
        // these attributes need to be set, in order for an 'empty' Card View to be created
        self.isUserInteractionEnabled = false
        // standard defenition of the card object, is that it cannot be interacted with
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported within this class")
    }
}
