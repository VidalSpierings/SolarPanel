//
//  SolarPanelInfo.swift
//  SolarPanel
//
//  Created by Vidal on 08/05/2024.
//

struct Zonnepaneel: Decodable {
    
    let stroom_zonnepaneel: Int16 // used to be UInt8
    let spanning_zonnepaneel: Double
    let spanning_batterij: Double
    let positie: Int16 // used to be UInt8
    let timestamp: String
    
}
