//
//  RetryView.swift
//  ADPNews
//
//  Created by Matija Pavicic on 10.01.2024..
//

import SwiftUI

struct RetryView: View {
    
    let text: String

    // this is absolutely fine, but common practice is to do it like this:
    // => let retryAction: (Void) -> ()

    let retryAction: () -> ()
    
    var body: some View {
        VStack(spacing: 8) {
            Text(text)
                .font(.callout)
                .multilineTextAlignment(.center)
            
            Button(action: retryAction) {
                Text("Try again")
            }
        }
    }
}

struct RetryView_Previews: PreviewProvider {
    
    static var previews: some View {
        RetryView(text: "An error occured") {
            
        }
    }
}
