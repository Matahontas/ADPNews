//
//  ArticleRowView.swift
//  ADPNews
//
//  Created by Matija Pavicic on 10.01.2024..
//

import SwiftUI

struct ArticleRowView: View {
    
    @EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
    
    let article: Article

    // would be better to extract View components into separate Views
    // that way our body is much cleaner and easier to understand for someone who's looking at it for the first time (like me)
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // this can be articleImage
            // => var articleImage: some View { ... }
            AsyncImage(url: article.imageURL) { phase in
                switch phase {
                case .empty:
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }

                    // another way for centering content would be like this:
                    // => ProgressView()
                    //      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    // this is much cleaner than wrapping a single component into a VStack or HStack just to center it

                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    HStack {
                        Spacer()
                        Image(systemName: "photo")
                            .imageScale(.large)
                        Spacer()
                    }
                @unknown default:
                    fatalError()
                }
            }
            .frame(minHeight: 200, maxHeight: 300)
            .background(Color.gray.opacity(0.3))
            .clipped()
            
            // this can be articleDetails
            // => var articleDetails: some View { ... }
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(3)
                
                Text(article.descriptionText)
                    .font(.subheadline)
                    .lineLimit(2)
                
                // this can be articleCaption
                // => var articleCaption: some View { ... }
                HStack {
                    Text(article.captionText)
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    Spacer()
                    
                    // this can be bookmarkButton
                    // => var bookmarkButton: some View { ... }
                    Button{
                        toggleBookmark(for: article)
                    } label: {
                        Image(systemName: articleBookmarkVM.isBookmarked(for: article) ? "bookmark.fill" : "bookmark")
                    }
                    .buttonStyle(.bordered)

                    // this can be shareButton
                    // => var shareButton: some View { ... }
                    Button{
                        presentShareSheet(url: article.articleURL)
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding([.horizontal, .bottom])
            
        }
    }
    
    func toggleBookmark(for article: Article) {
        if articleBookmarkVM.isBookmarked(for: article){
            articleBookmarkVM.removeBookmark(for: article)
        } else {
            articleBookmarkVM.addBookmark(for: article)
        }
    }
}

extension View {
    func presentShareSheet(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .keyWindow?
            .rootViewController?
            .present(activityVC, animated: true)
    }
}

struct ArticleRowView_Previews: PreviewProvider {
    
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    static var previews: some View {
        NavigationStack {
            List {
                ArticleRowView(article: .previewData[0])
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listStyle(.plain)
        }
        .environmentObject(articleBookmarkVM)
    }
}
