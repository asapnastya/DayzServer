//
//  Client.swift
//  DayzServer
//
//  Created by Анастасия Романова on 8/6/24.
//

import SwiftUI

struct Client {
    
    let id: UUID
    
    // Получение уведомления
    func receiveNotification(_ message: String) {
        print("Client \(id) received notification: \(message)")
    }
    
    // Выполнение задачи с возможной ошибкой
    func performTask(_ task: String) async throws -> String {
        if Bool.random() {
            throw NSError(domain: "Error", code: 999)
        }
        
        return "Action: \(task) - by client \(id)"
    }
}
