//
//  DetailNote.swift
//  ToDo-list
//
//  Created by Cynthia on 03/01/2023.
//

import SwiftUI

struct DetailNote: View {
//    private let photo : String
    @State var title: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
//            photo
//                .resizable()
//                .scaledToFit()
            Text(title)
            ShareLink(item: title, preview: SharePreview(title))
            
        }
        .padding(.horizontal)
        
    }
}

struct DetailNote_Previews: PreviewProvider {
    static var previews: some View {
        DetailNote(title: "")
    }
}
