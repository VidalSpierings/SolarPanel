//
//  VouwConfiguratie.swift
//  SolarPanel
//
//  Created by Vidal on 29/05/2024.
//

import Foundation

class VouwConfiguratie {
    
    public func sendFoldingState (command: String) throws {
        
        do {
            
            try FoldingCommand().activate(foldingCommand: command)
            
        } catch {
            
            throw URLError(.unknown)

        }
                
    }
    
}
