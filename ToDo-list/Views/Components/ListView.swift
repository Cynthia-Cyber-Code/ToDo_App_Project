//
//  ListView.swift
//  ToDo-list
//
//  Created by Cynthia on 05/01/2023.
//

import SwiftUI

struct ListView: View {
    @State var note: Note
    
    @State var isAddPresented = false
    var body: some View {
        ZStack {
            CardsView(title: note.title!, date: note.date!, status: note.status!)
            NavigationLink {
                DetailNote(note: note, showGreeting: note.notif, showFinish: note.favoris)
        } label: {
            EmptyView()
        }.frame(width: 0, height: 0)
                .opacity(0)
        }
        .listRowSeparator(.hidden)
        .listRowBackground(
            LinearGradient(gradient: Gradient(colors: [ Color("Color"), Color("Color1")]), startPoint: .top, endPoint: .bottomTrailing)
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding(.vertical, 8)
        )
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(note: Note())
    }
}
