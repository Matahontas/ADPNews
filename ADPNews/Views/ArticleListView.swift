//
//  ArticleListView.swift
//  ADPNews
//
//  Created by Matija Pavicic on 10.01.2024..
//

import SwiftUI

struct ArticleListView: View {
    
    let articles: [Article]
    @State private var selectedArticle: Article?
    var body: some View {
        List {
            ForEach(articles) {article in
                ArticleRowView(article: article)
                    .onTapGesture {
                        selectedArticle = article
                    }
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .sheet(item: $selectedArticle) {
            SafariView(url: $0.articleURL)
                .ignoresSafeArea(edges: .bottom)
        }
    }
}

struct ArticleListView_Previews: PreviewProvider {
    
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    static var previews: some View {
        NavigationStack {
            ArticleListView(articles: Article.previewData)
                .environmentObject(articleBookmarkVM)
        }
    }
}
