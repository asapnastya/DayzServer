//
//  ContentView.swift
//  DayzServer
//
//  Created by Анастасия Романова on 8/6/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var gameServer = GameServer()
    
    var body: some View {
        VStack {
            Image(.dayzImg)
                .resizable()
                .frame(width: 200, height: 100)
            
            Button("Connect Clients") {
                connectClients()
            }
            .buttonStyle(.borderedProminent)
            .tint(.black)
            
            Button("Run Task") {
                runTaskForClients()
            }
            .buttonStyle(.borderedProminent)
            .tint(.black)
        }
    }
    
    // Подключение двух клиентов
    private func connectClients() {
        Task {
            let client1 = Client(id: UUID())
            let client2 = Client(id: UUID())
            
            await gameServer.connect(client: client1)
            await gameServer.connect(client: client2)
        }
    }
    
    // Запуск задачи для всех клиентов
    private func runTaskForClients() {
        Task {
            await gameServer.runTaskForClients("Change weather")
        }
    }
}
// MARK: - Preview
#Preview {
    ContentView()
}
