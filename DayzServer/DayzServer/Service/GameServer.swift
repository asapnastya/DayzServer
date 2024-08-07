//
//  GameServer.swift
//  DayzServer
//
//  Created by Анастасия Романова on 8/6/24.
//

import SwiftUI

final actor GameServer {
    
    private var clients: [Client] = .init()
    private var gameState: [String: String] = .init()
    
    // Подключение клиента
    func connect(client: Client) {
        clients.append(client)
        
        client.receiveNotification("Client \(client.id) logged in. Ready to play!")
    }
    
    // Отключение клиента
    func disconnect(client: Client) {
        if let index = clients.firstIndex(where: { $0.id == client.id }) {
            clients.remove(at: index)
        }
        
        client.receiveNotification("Client \(client.id) has been disconnected.")
    }
    
    // Попытка выполнить задачу для всех подключенных клиентов. Если не получается выполнить с 1 раза, метод повторяет попытку до 3 раз
    // Асинхронное распределение задачи между клиентами
    func runTaskForClients(_ task: String) async {
        await withTaskGroup(of: Void.self) { group in
            for client in clients {
                group.addTask {
                    let maxTry = 3
                    var currentTry = 0
                    
                    while currentTry < maxTry {
                        do {
                            let result = try await client.performTask(task) // попытка выполнить задачу
                            
                            await self.updateGameState(with: result) // обновляет состояние игры после успешного выполнения задачи клиентом
                            
                            break
                        } catch { // уведомления о сбоях и восстановлении / дисконнект при неуспешном восстановлении после 3 попытки
                            currentTry += 1
                            
                            print("❗️Error performing task: \(error). Try to fix - \(currentTry)❗️")
                            
                            switch currentTry {
                            case let currentTry where currentTry < maxTry:
                                client.receiveNotification("❓Error occurred. Retrying...❓")
                            default:
                                client.receiveNotification("❌ Failed after \(maxTry) try ❌")
                                await self.disconnect(client: client)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Получение текущего состояния игры
    private func getGameState() -> [String: String] {
        gameState
    }
    
    // Обновление состояния игры - сохраняет результат под ключом "lastResult" и выводит обновленное состояние игры в консоль
    private func updateGameState(with result: String) {
        gameState["lastResult"] = result
        
        print("Game state updated: \(gameState)")
    }
}
