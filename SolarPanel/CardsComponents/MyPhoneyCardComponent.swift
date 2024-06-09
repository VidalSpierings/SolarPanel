//
//  MyPhoneyCardComponent.swift
//  SolarPanel
//
//  Created by Vidal on 13/05/2024.
//

// See image 'cardscomponents_structure' for visual representation of inheritance structure
// (Documentation.docc/Resources/cardscomponents_structure)

import UIKit.UIView

class MyPhoneyCardComponent: UIView {
    
    init(background: UIColor) {
        
        super.init(frame: CGRect())
        
        self.layer.cornerRadius = 20
        
        self.translatesAutoresizingMaskIntoConstraints = false
                
        self.backgroundColor = background
        
        NSLayoutConstraint.activate([
            
            self.widthAnchor.constraint(equalToConstant: CGFloat(Constants.Dimensions.BigCard.size)),
            self.heightAnchor.constraint(equalToConstant: CGFloat(Constants.Dimensions.BigCard.size))
            
        ])
                
    }
    
    required init?(coder: NSCoder) {
        fatalError("NSCoding not supported from within this class")
    }
    
}
