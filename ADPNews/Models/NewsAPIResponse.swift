//
//  NewsAPIResponse.swift
//  ADPNews
//
//  Created by Matija Pavicic on 10.01.2024..
//

import Foundation

struct NewsAPIResponse: Codable {
    
    let status: String
    let totalResults: Int?
    let articles: [Article]?
    
    let code: String?
    let message: String?
    
}
