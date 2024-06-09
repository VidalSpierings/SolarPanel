//
//  MyIconCreator.swift
//  SolarPanel
//
//  Created by Vidal on 10/05/2024.
//

import UIKit

class MyIconCreator {
    
    private init(){}
    
    // private initialiser, so it is clear to developer that this class ought not to be instantiated
    
    static func createIcon(systemName: String) -> UIImage {
        
        return UIImage(systemName: systemName, withConfiguration: UIImage.SymbolConfiguration(weight: .bold))?.withTintColor(UIColor(named: Constants.AppColors.iconColorPrimary) ?? .white, renderingMode: .alwaysOriginal) ?? UIImage()
        
        /*
        
        - create image: get the build-in system icon,
          make icon bolt, and set icon color to project primary icon color.
          If image cannot be found, show empty image. If project primary icon color
          cannot be found, assign the color white
        
        */
        
    }
}
