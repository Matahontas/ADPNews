//
//  ContentView.swift
//  ADPNews
//
//  Created by Matija Pavicic on 10.01.2024..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HeadlinesTabView()
                .tabItem { 
                    Label("Headlines", systemImage: "newspaper")
                }
            
            SearchTabView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            BookmarkTabView()
                .tabItem {
                    Label("Saved", systemImage: "bookmark")
                }
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    static var previews: some View {
        ContentView()
            .environmentObject(articleBookmarkVM)
    }
    
}
