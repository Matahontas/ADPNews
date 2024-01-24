//
//  ArticleBookmarkViewModel.swift
//  ADPNews
//
//  Created by Matija Pavicic on 10.01.2024..
//

import SwiftUI

@MainActor
class ArticleBookmarkViewModel: ObservableObject {
    
    @Published private(set) var bookmarks: [Article] = []
    
    // Use native UserDefaults
    private let bookmarkStore = PlistDataStore<[Article]>(filename: "bookmarks")

    // Never should VM be a singleton
    static let shared = ArticleBookmarkViewModel()
    
    private init() {
        Task {
            await load()
        }
    }
    
    private func load() async {
        bookmarks = await bookmarkStore.load() ?? []
    }
    
    func isBookmarked(for article: Article) -> Bool {
        bookmarks.first { article.id == $0.id } != nil
    }
    
    func addBookmark(for article: Article) {
        guard !isBookmarked(for: article) else {
            return
        }
        
        bookmarks.insert(article, at: 0)
        bookmarkUpdated()
    }
    
    func removeBookmark(for article: Article) {
        guard let index = bookmarks.firstIndex(where: { $0.id == article.id }) else {
            return
        }
        bookmarks.remove(at: index)
        bookmarkUpdated()
    }
    
    private func bookmarkUpdated() {
        // I understand this, but naming should never be like this: variable1, variable2...
        // => let updatedBookmarks = self.bookmarks
        let bookmarks2 = self.bookmarks
        Task {
            await bookmarkStore.save(bookmarks2)
        }
    }
}
