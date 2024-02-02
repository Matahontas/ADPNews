//
//  BookmarkTabView.swift
//  ADPNews
//
//  Created by Matija Pavicic on 11.01.2024..
//

import SwiftUI

struct BookmarkTabView: View {

    // why EnvironmentObject?
    @EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
    
    @State var searchText: String = ""

    // very nice UI, clean and simple
    var body: some View {
        let articles = self.articles
        
        // I see that you're always putting ArticleListView inside NavigationStack
        // maybe it'd be better to put this NavigationStack inside the ArticleListView itself?
        // that way you wouldn't have to do it every time you want to use ArticleListView
        NavigationStack {
            ArticleListView(articles: articles)
                .overlay(overlayView(isEmpty: articles.isEmpty))
                .navigationTitle("Saved articles")
        }
        .searchable(text: $searchText)
    }
    
    private var articles: [Article] {
        if searchText.isEmpty {
            return articleBookmarkVM.bookmarks
        }
        return articleBookmarkVM.bookmarks
            .filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                $0.descriptionText.lowercased().contains(searchText.lowercased())
            }
    }
    
    @ViewBuilder
    func overlayView(isEmpty: Bool) -> some View {
        if isEmpty {
            EmptyPlaceholderView(text: "No saved articles", image: Image(systemName: "bookmark"))
        }
    }
}

struct BookmarkTabView_Previews: PreviewProvider {
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    static var previews: some View {
        BookmarkTabView()
            .environmentObject(articleBookmarkVM)
    }
}
