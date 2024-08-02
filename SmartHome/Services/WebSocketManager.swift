//
//  WebSocketManager.swift
//  SmartHome
//
//  Created by 吉田龍生 on 2024/5/22.
//

import Foundation

class WebSocketManager: NSObject, ObservableObject {
    static let shared = WebSocketManager()
    private var webSocketTask: URLSessionWebSocketTask?
    private var isConnected = false
    
    private override init() {
        super.init()
    }
    
    private func connect() {
        //        guard !isConnected else { return }
        let url = URL(string: "socket-url")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        //        isConnected = true
        
        print("WebSocket connected to \(url)")
    }
    
    private func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        isConnected = false
    }
    
    private func reconnect() {
        disconnect()
        connect()
    }
    
    func sendRequest<T: Decodable>(request: String, action: String, data: [String: Any], completion: @escaping (T?) -> Void) {
        connect()
        
        let requestData: [String: Any] = [
            "request": request,
            "action": action,
            "data": data
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestData) else { return }
        let jsonString = String(data: jsonData, encoding: .utf8)!
        
        let message = URLSessionWebSocketTask.Message.string(jsonString)
        
        print("發送到WebSocket的消息： \(jsonString)")
        
        webSocketTask?.send(message) { error in
            if let error = error {
                print("WebSocket sending error: \(error)")
            }
        }
        
        receiveResponse(completion: completion)
    }
    
    private func receiveResponse<T: Decodable>(completion: @escaping (T?) -> Void) {
        webSocketTask?.receive { result in
            
            print("接收到WebSocket的消息： \(result)")
            
            switch result {
            case .failure(let error):
                print("WebSocket receiving error: \(error)")
                self.disconnect()
                completion(nil)
            case .success(let message):
                switch message {
                case .string(let text):
                    print("WebSocket received message: \(text)")
                    if let data = text.data(using: .utf8) {
                        do {
                            let responseObject = try JSONDecoder().decode(T.self, from: data)
                            DispatchQueue.main.async {
                                self.disconnect()
                                completion(responseObject)
                            }
                        } catch {
                            print("Decoding error: \(error)")
                            if let decodingError = error as? DecodingError {
                                switch decodingError {
                                case .typeMismatch(let key, let context):
                                    print("Type mismatch for key \(key): \(context.debugDescription)")
                                case .valueNotFound(let key, let context):
                                    print("Value not found for key \(key): \(context.debugDescription)")
                                case .keyNotFound(let key, let context):
                                    print("Key not found \(key): \(context.debugDescription)")
                                case .dataCorrupted(let context):
                                    print("Data corrupted: \(context.debugDescription)")
                                @unknown default:
                                    print("Unknown decoding error: \(error)")
                                }
                            }
                            completion(nil)
                        }
                    } else {
                        completion(nil)
                    }
                case .data(let data):
                    
                    let responseString = String(data: data, encoding: .utf8) ?? "Invalid data"
                    print("WebSocket received data: \(responseString)")
                    
                    let responseObject = try? JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        self.disconnect()
                        completion(responseObject)
                    }
                @unknown default:
                    fatalError()
                }
            }
        }
    }
}
