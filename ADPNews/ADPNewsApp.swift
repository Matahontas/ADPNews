//
//  ADPNewsApp.swift
//  ADPNews
//
//  Created by Matija Pavicic on 08.01.2024..
//

import SwiftUI

@main
struct ADPNewsApp: App {
    
    // Good that it's a StateObject, but bad that it's a singleton
    @StateObject var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(articleBookmarkVM)
        }
    }
}
