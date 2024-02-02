//
//  HeadlinesAPI.swift
//  ADPNews
//
//  Created by Matija Pavicic on 10.01.2024..
//

import Foundation

// generally ok, it does what it's meant to do
// Hardcoding API Key: Storing API keys directly in the codebase, especially in a publicly accessible repository, is not secure.
// Consider storing the API key in a separate configuration file or using environment variables, and ensure this file is included in .gitignore.
// Use of Structs: Using a struct for a singleton pattern is generally bad practice in Swift. You use it only if you want immutable singleton. (which is rare)
struct HeadlinesAPI {
    
    static let shared = HeadlinesAPI()
    private init() {}
    
    // ok for now, but API key should never be here, it should be stored in some secret file which won't be pushed to git (.gitignore)
    private let apiKey = "3eef49c01a8941b3b737f12ac5b3a075"

    // Dependency Injection for URLSession: Hardcoding URLSession.shared can make unit testing difficult.
    // Consider injecting URLSession as a dependency, which can be easily mocked during tests.
    private let session = URLSession.shared

    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }( )
    
    func fetch(from category: Category) async throws -> [Article] {
        try await fetchArticles(from: generateNewsURL(from: category))
    }
    
    func search(for query: String) async throws -> [Article] {
        try await fetchArticles(from: generateSearchURL(from: query))
    }
    
    private func fetchArticles(from url: URL) async throws -> [Article] {
        let (data, response) = try await session.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw generateError(description: "Bad response")
        }
        
        // Error Handling: The error handling can be improved.
        // Instead of using generic error messages, it would be beneficial to provide more specific error information, especially in network requests and JSON parsing.
        switch response.statusCode {

        // HTTP Status Code Handling: The switch-case for handling HTTP status codes is unusual.
        // Generally, the range 200-299 indicates success, and anything beyond should be treated as an error.
        // Grouping 400-499 with 200-299 is unconventional and might lead to mishandling of client-side errors.
        case (200...299), (400...499):
            let apiResponse = try jsonDecoder.decode(NewsAPIResponse.self, from: data)
            if apiResponse.status == "ok" {
                return apiResponse.articles ?? []
            } else {
                throw generateError(description: apiResponse.message ?? "An error occured")
            }
            
        default:
            throw generateError(description: "A server error occured")
        }
    }
    
    private func generateError(code: Int = 1, description: String) -> Error{
        NSError(domain: "NewsAPI", code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
    
    // Force Unwrapping URLs: The use of force unwrapping (URL(string: url)!) is generally discouraged because it can lead to crashes if the URL is not valid.
    // Instead, handle this gracefully with optional binding or a guard statement.
    private func generateSearchURL(from query: String) -> URL {
        let percentEncodedString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        var url = "https://newsapi.org/v2/everything?"
        url += "language=en"
        url += "&q=\(percentEncodedString)"
        url += "&apiKey=\(apiKey)"
        return URL(string: url)!
    }
    
    private func generateNewsURL(from category: Category) -> URL {
        var url = "https://newsapi.org/v2/top-headlines?"
        url += "language=en"
        url += "&category=\(category.rawValue)"
        url += "&apiKey=\(apiKey)"
        return URL(string: url)!
    }
}
