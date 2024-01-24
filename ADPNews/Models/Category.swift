//
//  Category.swift
//  ADPNews
//
//  Created by Matija Pavicic on 10.01.2024..
//

import Foundation

enum Category: String, CaseIterable {
    case general
    case business
    case technology
    case entertainment
    case sport
    case science
    case health
    
    var text: String {
        if self == .general {
            return "Top headlines"
        }
        return rawValue.capitalized

        // muche cleaner:
        // => return self == .general ? "Top headlines" : rawValue.capitalized
    }
    
}

extension Category: Identifiable {
    var id: Self { self }
}
