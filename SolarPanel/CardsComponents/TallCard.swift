//
//  TallCard.swift
//  SolarPanel
//
//  Created by Vidal on 02/05/2024.
//

// See image 'cardscomponents_structure' for visual representation of inheritance structure
// (Documentation.docc/Resources/cardscomponents_structure)

import Cards

class TallCard: MyCardComponent {
    
    override init(frame: CGRect) {
        super.init(frame: CGRect())
    }
    
    /*
    
    -  empty CGRect object:
       submitting a CGRect objects is required.
       Dimensions will be defined in the convenience intializer.
       Coordinates will also be defined later
    
    */
    
    convenience init (){
        
        self.init(frame: CGRect())
                                
        NSLayoutConstraint.activate([
            
            self.widthAnchor.constraint(equalToConstant: CGFloat(Constants.Dimensions.TallCard.width)),
            self.heightAnchor.constraint(equalToConstant: CGFloat(Constants.Dimensions.TallCard.height))
            
        ])
        
        /*
        
        - set width and height of item. The initial width and height is set to 0, because
          the 'CardComponent' class requires a CGRect object in it's parameters
        
        */
        
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("NSCoding not supported from within this class")
        
    }
    
}
