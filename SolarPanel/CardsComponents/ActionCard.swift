//
//  ActionCard.swift
//  SolarPanel
//
//  Created by Vidal on 13/05/2024.
//

// See image 'cardscomponents_structure' for visual representation of inheritance structure
// (Documentation.docc/Resources/cardscomponents_structure)

import Cards

class ActionCard: MyCardComponent {
    
    override init(frame: CGRect) {
        super.init(frame: CGRect())
    }
    
    /*
    
    -  empty CGRect object:
       submitting a CGRect objects is required.
       Dimensions will be defined in the convenience intializer.
       Coordinates will also be defined later
    
    */
    
    convenience init (systemName: String, buttonText: String, onCardTapped: MyGestureRecognizer){
        
        self.init(frame: CGRect())
                                
        NSLayoutConstraint.activate([
            
            self.widthAnchor.constraint(equalToConstant: CGFloat(Constants.Dimensions.SmallCard.width)),
            self.heightAnchor.constraint(equalToConstant: CGFloat(Constants.Dimensions.SmallCard.height))
            
        ])
        
        /*
        
        - set width and height of item. The initial width and height is set to 0, because
          the 'CardComponent' class requires a CGRect object in it's parameters
        
        */
        
        self.backgroundColor = UIColor(named: Constants.AppColors.secondary) ?? .red
                
        self.icon = MyIconCreator.createIcon(systemName: systemName)
        
        self.title = buttonText
        
        self.textColor = UIColor(named: Constants.AppColors.textColorPrimary) ?? .white
        
        self.buttonText = "👆"
        
        self.isUserInteractionEnabled = true
                        
        self.addGestureRecognizer(onCardTapped)
        
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("NSCoding not supported from within this class")
        
    }
    
}
