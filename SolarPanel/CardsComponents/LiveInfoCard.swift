//
//  LiveInfoCard.swift
//  SolarPanel
//
//  Created by Vidal on 07/05/2024.
//

// See image 'cardscomponents_structure' for visual representation of inheritance structure
// (Documentation.docc/Resources/cardscomponents_structure)

import UIKit.UIColor

class LiveInfoCard: TallCard {
    
    convenience init(iconSystemName: String, title: String, amount: String) {
        
        self.init()
        
        self.backgroundColor = UIColor(named: Constants.AppColors.secondary) ?? .red
        
        self.icon = MyIconCreator.createIcon(systemName: iconSystemName)
                
        self.textColor = UIColor(named: Constants.AppColors.textColorPrimary) ?? .white
        
        self.itemTitle = title
        
        self.title = amount
                
    }
    
}
