//
//  foculasticsApp.swift
//  foculastics
//
//  Created by Adil on 25.09.2023.
//

import SwiftUI

@main
struct foculasticsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
