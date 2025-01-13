//
//  GolgalaksisiApp.swift
//  Golgalaksisi
//
//  Created by İsmail Emir Tiryaki on 13.01.2025.
//

import SwiftUI

@main
struct GolgalaksisiApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
