//
//  BarTitleView.swift
//  ToDo-list
//
//  Created by Cynthia on 05/01/2023.
//

import SwiftUI

struct BarTitleView: View {
    var body: some View {
        HStack {
            Spacer()
            Text("To-Do list").font(.title).fontWeight(.bold)
            Spacer()
            EditButton().fontWeight(.thin).foregroundColor(.black)
        }.padding()
    }
}

struct BarTitleView_Previews: PreviewProvider {
    static var previews: some View {
        BarTitleView()
    }
}
