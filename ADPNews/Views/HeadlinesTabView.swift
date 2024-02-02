//
//  HeadlinesTabView.swift
//  ADPNews
//
//  Created by Matija Pavicic on 10.01.2024..
//

import SwiftUI

struct HeadlinesTabView: View {
    
    // VM is StateObject which is good, here it's not a singleton - why?
    // It'd be better to inject VM into View, but this is ok
    @StateObject var articleNewsVM = ArticleNewsViewModel()
    
    // randomly using private
    @State private var isSortedAscending: Bool = false
    @State var searchText: String = ""
    
    var body: some View {

        // Kudos for using NavigationStack
        NavigationStack {
            ArticleListView(articles: sortedArticles)
                .overlay(overlayView)
                .task(id: articleNewsVM.fetchTaskToken.category, loadTaskCategory)
                .refreshable() {
                    refreshTask() // nice
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
    
    // Nice for using ViewBuilder here, but do you know what does it do and when do we use it?
    @ViewBuilder
    private var overlayView: some View {

        // => much better:
        //    switch articleNewsVM.phase {
        //    case .empty:
        //        ProgressView()
        //    case .success(let articles) where articles.isEmpty:
        //        EmptyPlaceholderView(text: "No Articles", image: nil)
        //    case .failure(let error):
        //        RetryView(text: error.localizedDescription, retryAction: refreshTask)
        //    default:
        //        EmptyView()
        //    }

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
    
    // What is Sendable, why do we use it?
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
    
    // Nicee!!
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
            
            // if searchText is '  ' it's still technically empty, but here it will not be treated as empty
            // in this situations it's best to use .trimmingCharacters(in: .whitespacesAndNewlines)
            // => if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { ... }

            if searchText.isEmpty {
                return isSortedAscending ? articles.sorted { $0.publishedAt < $1.publishedAt } : articles.sorted { $0.publishedAt > $1.publishedAt }
            }
            else {
                
                // here you completely repeat the logic for sorting, so maybe you can extract it out
                // this enables you to make changes only in one place instead of 2 or more
                // => let sorted = isSortedAscending ? articles.sorted { $0.publishedAt < $1.publishedAt } : articles.sorted { $0.publishedAt > $1.publishedAt }
                // => if searchText.isEmpty { return sorted } else { return sorted.filter { ... } }
                // => or even better: return searchText.isEmpty ? sorted : sorted.filter { ... }

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
