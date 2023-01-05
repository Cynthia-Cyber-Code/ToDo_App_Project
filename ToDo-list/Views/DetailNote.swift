//
//  DetailNote.swift
//  ToDo-list
//
//  Created by Cynthia on 03/01/2023.
//

import SwiftUI

struct DetailNote: View {
    @State var title: String
    @State var date: Date
    @State var description: String
    @State var order: Int64
    @State var isAddPresented = false
    @State var id : UUID
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                isAddPresented.toggle()
            } label: {
                Image(systemName: "pencil").font(.largeTitle).foregroundColor(.black)
            }.sheet(isPresented: $isAddPresented) {
                ModifyView(isAddPresented: $isAddPresented, title: title, description: description, date: date, order: order, id: id)
            }
            Text(title)
            ShareLink(item: title, preview: SharePreview(title))
            VStack {
                Text("Notification will appear in \(date.formatted(date: .abbreviated, time: .standard))")
                Button {
                    scheduleNotification(title: title, date: date)
                } label: {
                    Text("Schedule notification")
                }
                .padding()
            }
            
        }
        .padding(.horizontal)
        
    }
}

struct DetailNote_Previews: PreviewProvider {
    static var previews: some View {
        DetailNote( title: "", date: Date.now, description: "", order: 0, id: UUID())
    }
}
