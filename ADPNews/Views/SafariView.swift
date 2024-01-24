//
//  SafariView.swift
//  ADPNews
//
//  Created by Matija Pavicic on 10.01.2024..
//

import SwiftUI
import SafariServices

// great! apple didn't really do much about this SafariView
struct SafariView: UIViewControllerRepresentable {
    
    let url: URL
    
    func makeUIViewController(context: Context) -> some SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    
    
}
