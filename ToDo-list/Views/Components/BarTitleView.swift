//
//  BarTitleView.swift
//  ToDo-list
//
//  Created by Cynthia on 05/01/2023.
//

import SwiftUI

struct BarTitleView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            Spacer()
            Text(" To-Do list").font(.title).fontWeight(.bold)
            Spacer()
            if (colorScheme == .dark) {
                EditButton().foregroundColor(.white).font(.title)
            } else {
                EditButton().foregroundColor(.black).font(.title)
            }
        }.padding()
    }
}

struct BarTitleView_Previews: PreviewProvider {
    static var previews: some View {
        BarTitleView()
        BarTitleView().preferredColorScheme(.dark)
    }
}
