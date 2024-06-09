//
//  FoldingCommand.swift
//  SolarPanel
//
//  Created by Vidal on 08/05/2024.
//

import Foundation

class FoldingCommand {
    
    func activate(foldingCommand: String) throws {
        
        // let command = "15"
        
        let command = foldingCommand
        
        // MARK: Change the above line to a String with the content "15" (including the "" symbols) when performing the system test
                
        guard let url = URL(string: Constants.Repository.SubmitToAPI.apiUrl + command) else {
            
            throw URLError(.unknown)
            
        }
                                        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            #if DEBUG
            print("button pressed")
            print(String(data: data, encoding: .utf8)!)
            #endif
        }

        task.resume()
        
    }
    
}
