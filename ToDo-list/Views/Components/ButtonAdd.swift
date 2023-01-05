//
//  ButtonAdd.swift
//  ToDo-list
//
//  Created by Cynthia on 05/01/2023.
//

import SwiftUI

struct ButtonAdd: View {
    @State var isAddPresented = false
    var body: some View {
        Button {
            isAddPresented.toggle()
        } label: {
            LinearGradient(gradient: Gradient(colors: [.orange, .brown]), startPoint: .top, endPoint: .bottom)
                .mask(Image(systemName: "plus.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
            ).frame(width: 70, height: 70, alignment: .center)
        }
        .sheet(isPresented: $isAddPresented) {
            AddNoteView( isAddPresented: $isAddPresented)
        }
        .padding()
        Spacer()
    }
}

struct ButtonAdd_Previews: PreviewProvider {
    static var previews: some View {
        ButtonAdd()
    }
}
