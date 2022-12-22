//
//  SetApp.swift
//  Set
//
//  Created by Christophe Beaulieu on 2022-12-13.
//

import SwiftUI

@main
struct SetApp: App {
    let gameViewModel = SetGameViewModel()
    
    var body: some Scene {
//        WindowGroup {
//
//        }
        WindowGroup {
            SetGameView(model: gameViewModel)
        }
//        WindowGroup {
//
//        }
    }
}
