//
//  HeadlinesTabView.swift
//  ADPNews
//
//  Created by Matija Pavicic on 10.01.2024..
//

import SwiftUI

struct HeadlinesTabView: View {
    
    @StateObject var articleNewsVM = ArticleNewsViewModel()
    @State private var isSortedAscending: Bool = false
    @State var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            ArticleListView(articles: sortedArticles)
                .overlay(overlayView)
                .task(id: articleNewsVM.fetchTaskToken.category, loadTaskCategory)
                .refreshable(){
                    refreshTask()
                }
                .navigationTitle(articleNewsVM.fetchTaskToken.category.text)
                .toolbar() {
                    ToolbarItem(placement: .topBarTrailing){
                        menu
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Sort"){
                            isSortedAscending.toggle()
                        }
                    }
                }
        }
        .searchable(text: $searchText)
    }
    
    @ViewBuilder
    private var overlayView: some View {
        
        switch articleNewsVM.phase {
        case .empty: ProgressView()
        case .success(let articles) where articles.isEmpty: EmptyPlaceholderView(text: "No Articles", image: nil)
        case .failure(let error): RetryView(text: error.localizedDescription, retryAction: refreshTask)
        default: EmptyView()
        }
    }
    
    private var articles: [Article] {
        if case let .success(articles) = articleNewsVM.phase {
            return articles
        } else {
            return []
        }
    }
    
    @Sendable
    private func loadTask() async {
       await articleNewsVM.loadArticles()
     
    }
    
    @Sendable
    private func loadTaskCategory() async {
        articleNewsVM.isDataLoaded = false
        await articleNewsVM.loadArticles()
     
    }
    
    private func refreshTask() {
        articleNewsVM.isDataLoaded = false
        articleNewsVM.fetchTaskToken = FetchTaskToken(category: articleNewsVM.fetchTaskToken.category, token: Date())
    }
    
    private var menu: some View {
        Menu {
            Picker("Category", selection: $articleNewsVM.fetchTaskToken.category) {
                ForEach(Category.allCases) {
                    Text($0.text).tag($0)
                }
            }
        } label: {
            Image(systemName: "fiberchannel")
                .imageScale(.large)
        }
    }
    
    private var sortedArticles: [Article] {
        if case let .success(articles) = articleNewsVM.phase {
            if searchText.isEmpty {
                return isSortedAscending ? articles.sorted { $0.publishedAt < $1.publishedAt } : articles.sorted { $0.publishedAt > $1.publishedAt }
            }
            else {
                return isSortedAscending ? articles.sorted { $0.publishedAt < $1.publishedAt } : articles.sorted { $0.publishedAt > $1.publishedAt }
                    .filter {
                        $0.title.lowercased().contains(searchText.lowercased()) ||
                        $0.descriptionText.lowercased().contains(searchText.lowercased())
                    }
            }
        } else {
            return []
        }
    }
}

struct HeadlinesTabView_Previews: PreviewProvider {
    
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    static var previews: some View {
        HeadlinesTabView(articleNewsVM: ArticleNewsViewModel(articles: Article.previewData))
            .environmentObject(articleBookmarkVM)
    }
}
