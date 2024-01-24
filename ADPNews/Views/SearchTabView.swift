//
//  SearchTabView.swift
//  ADPNews
//
//  Created by Matija Pavicic on 11.01.2024..
//

import SwiftUI

struct SearchTabView: View {
    
    // bad using VM as singletons
    // why? VMs represent a state of the view, meaning each view will have it's own state
    // if you had multiple SearchTabViews (for some weird reason 😅) every single one of them would be represented by the same state since your VM is a singleton
    @StateObject var searchVM = ArticleSearchViewModel.shared
    
    var body: some View {
        NavigationStack {
            ArticleListView(articles: articles)
                .overlay(overlayView)
                .navigationTitle("Search")
        }
        .searchable(text: $searchVM.searchQuery)

        // very nice
        .onChange(of: searchVM.searchQuery) { newValue in
            if newValue.isEmpty {
                searchVM.phase = .empty
            }
        }
        .onSubmit(of: .search, search)
    }
    
    private var articles: [Article] {
        if case .success(let articles) = searchVM.phase {
            return articles
        } else {
            return []
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch searchVM.phase {
        case .empty:
            if !searchVM.searchQuery.isEmpty {
                ProgressView()
            } else if !searchVM.history.isEmpty {
                SearchHistoryListView(searchVM: searchVM) { newValue in
                    searchVM.searchQuery = newValue
                    search()
                }
            } else {
                EmptyPlaceholderView(text: "Type your query to search from NewsAPI", image: Image(systemName: "magnifyingglass"))
            }
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No search results found", image: Image(systemName: "magnifyingglass"))
        case .failure(let error):
            RetryView(text: error.localizedDescription, retryAction: search)
        default: EmptyView()
        }
    }
    
    // all logic should be moved into VM (view should just have to render itself and the data from VM)
    // when search method is called you'd just have to call VM.search(), and the VM should take care of trimming, checking if empty, calling API etc...
    private func search() {
        let searchQuery = searchVM.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if !searchQuery.isEmpty {
            searchVM.addHistory(searchQuery)
        }

        // here a much cleaner syntax would be smth like this:
        // let searchQuery = searchVM.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        // guard !searchQuery.isEmpty else { return }

        Task {
            await searchVM.searchArticle()
        }
    }
}

struct SearchTabView_Previews: PreviewProvider {
    
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
    static var previews: some View {
        SearchTabView()
            .environmentObject(articleBookmarkVM)
    }
}
