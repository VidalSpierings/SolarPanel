//
//  Constants.swift
//  SolarPanel
//
//  Created by Vidal on 02/05/2024.
//

struct Constants{
    
    struct AppColors{
        
        static let primary = "Primary"
        static let secondary = "Secondary"
        static let tertiary = "Tertiary"
        static let textColorPrimary = "TextColorPrimary"
        static let textColorSecondary = "TextColorSecondary"
        static let iconColorPrimary = "IconColorPrimary"
        static let whiteCardColor = "WhiteCardColor"
        static let blackCardColor = "BlackCardColor"
        
        /*
        
        - string reference values of app colors. Storing the String reference values, instead of
          the UIColor objects directly, prevents the 'UIKit' libary from having to be imported.
    
        */
        
    }
    
    struct Dimensions{
        
        struct TallCard {
            
            static let height = 277
            static let width = 172
            
        }
        
        struct SmallCard {
            
            static let height = 172
            static let width = 172
            
        }
        
        struct BigCard {
            
            static let size = 450
            
        }
        
    }
    
    struct Repository {
        
        static let webSocketUrl = "ws://145.49.127.250:1880/ws/aaad2"
        
        struct SubmitToAPI {
            
            static let apiUrlTest = "http://145.49.127.250:1880/aaadlander/aaad2?vouw_configuratie="
            // MARK: - Use the above variable in the class 'MyViewModel' when performing the integration and system test, instead of the below variable
            static let apiUrl = "http://145.49.127.250:1880/aaadlander/aaad2?vouw_configuratie="
            static let id = "vouw_configuratie"
            static let fold = "fold"
            static let unfold = "unfold"
            
        }
        
    }
    
}
