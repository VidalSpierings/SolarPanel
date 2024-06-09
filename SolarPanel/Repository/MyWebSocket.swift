//
//  MyWebSocket.swift
//  SolarPanel
//
//  Created by Vidal on 06/05/2024.
//

import Foundation

protocol MyWebSocketDelegate {
    
    func didFinishServerDataRetrieval(data: Zonnepaneel)
    
}

class MyWebSocket: NSObject, URLSessionWebSocketDelegate {
    
    private var webSocket: URLSessionWebSocketTask?
    
    var myWebSocketDelegate: MyWebSocketDelegate?
            
    func activate() throws {
                
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        
        if let url = URL(string: Constants.Repository.webSocketUrl) {
            
            webSocket = session.webSocketTask(with: url)
            
            webSocket?.resume()
            
        } else {
                                    
            throw URLError(.badURL)
                        
        }
        
    }
    
    #if DEBUG
    func ping(){
        
        webSocket?.sendPing(pongReceiveHandler: { error in
        
            if let error = error {
                
                print("error with pinging: \(error)")
                
                // No need to show this info to user (only developer): This is a 'debug-only' method
                
            }
            
        })
        
    }
    
    #endif
    
    // only run the above code in debug build: No need to call method in final version of the app
    
    func read(){
                      
        webSocket?.receive(completionHandler: { [weak self] result in
                    
            switch result {
                                
            case .success(let message):
                switch message {
                    
                case .data(let data):
                    
                    print("retrieved data: \(data)")
                    
                case .string(let message):
                    
                    let result: Zonnepaneel?
                    
                    let decoder = JSONDecoder()
                    
                    result = try? decoder.decode(Zonnepaneel.self, from: message.data(using: .utf8) ?? Data())
                                                                        
                            self?.myWebSocketDelegate?.didFinishServerDataRetrieval(data: result ?? Zonnepaneel(stroom_zonnepaneel: 0, spanning_zonnepaneel: 0, spanning_batterij: 0, positie: 0, timestamp: "1970-01-01T00:00:00Z"))
                        //print("retrieved string: \(result?.timestamp)")
                        
                    
                                        
                @unknown default:
                    print("unknown retrieval")
                    break
                    
                }
                
            case .failure(let error): print("websocket failure error: \(error)")
                
            }
            
            self?.read()
            
        })
        
    }
    
    func close(){
        
        webSocket?.cancel(with: .goingAway, reason: "iPadOS app afgesloten / op de achtergrond | Vidal Spierings | groep 15".data(using: .utf8))
        
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
                
        print("websocket connection opened")
        
        #if DEBUG
        ping()
        #endif
        
        read()
        
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        
        print("websocket connection closed")
        
    }
    
}
