//
//  ArticleSearchViewModel.swift
//  ADPNews
//
//  Created by Matija Pavicic on 11.01.2024..
//

import SwiftUI

@MainActor
class ArticleSearchViewModel: ObservableObject {
    
    @Published var phase: DataFetchPhase<[Article]> = .empty
    @Published var searchQuery = ""
    @Published var history = [String]()
    private let historyDataStore = PlistDataStore<[String]>(filename: "history")
    private let historyMaxLimit = 10
    
    private let headlinesAPI = HeadlinesAPI.shared
    
    static let shared = ArticleSearchViewModel()
    
    private init() {
        load()
    }
    func addHistory(_ text: String){
        if let index = history.firstIndex(where: { text.lowercased() == $0.lowercased() }) {
            history.remove(at: index)
        } else if history.count == historyMaxLimit {
            history.remove(at: -1)
        }
        
        history.insert(text, at: 0)
        historyUpdated()
    }
    
    func removeHistory(_ text: String){
        guard let index = history.firstIndex(where: { text.lowercased() == $0.lowercased() }) 
            else {
            return
        }
        history.remove(at: index)
        historyUpdated()
    }
    
    func removeAllHistory() {
        history.removeAll()
        historyUpdated()
    }
    
    func searchArticle() async {
        if Task.isCancelled { return }
        let searchQuery = self.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        phase = .empty
        
        if searchQuery.isEmpty {
            return
        }
        
        do {
            let articles = try await headlinesAPI.search(for: searchQuery)
            if Task.isCancelled { return }
            if searchQuery != self.searchQuery {
                return
            }
            phase = .success(articles)
        } catch {
            if Task.isCancelled { return }
            if searchQuery != self.searchQuery {
                return
            }
            phase = .failure(error)
        }
    }
    
    private func load() {
        Task {
            self.history = await historyDataStore.load() ?? []
        }
    }
    
    private func historyUpdated() {
        let history = self.history
        Task {
            await historyDataStore.save(history)
        }
    }
}
