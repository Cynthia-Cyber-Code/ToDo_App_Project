//
//  ListView.swift
//  ToDo-list
//
//  Created by Cynthia on 05/01/2023.
//

import SwiftUI

struct ListView: View {
    @State var title: String
    @State var date: Date
    @State var status: String
    @State var description: String
    @State var id: UUID
    @State var order: Int64
    var body: some View {
        ZStack {
            CardsView(title: title, date: date, status: status)
            NavigationLink {
                DetailNote(title: title, date: date, description: description, order: order, id: id)
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
        ListView(title: "", date: Date(), status: "", description: "", id: UUID(), order: Int64())
    }
}
