//
//  ButtonAjout.swift
//  ToDo-list
//
//  Created by Cynthia on 03/03/2023.
//

import SwiftUI

struct ButtonAjout: View {
    @Environment(\.managedObjectContext) var viewContext
    @State private var clickCount: Double = 0
    let action: () -> ()
    let isDisabled: Bool
    
    @ObservedObject var noteVM = TaskViewModel()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: true), NSSortDescriptor(keyPath: \Note.order, ascending: true), NSSortDescriptor(keyPath: \Note.title, ascending: true), NSSortDescriptor(keyPath: \Note.descriptif, ascending: true), NSSortDescriptor(keyPath: \Note.status, ascending: true), NSSortDescriptor(keyPath: \Note.favoris, ascending: true)],
        animation: .default)
    
    var notes: FetchedResults<Note>

    @Binding var isAddPresented: Bool
    @State var title: String
    @State var description: String
    @State private var content: String
    @State var date: Date
    @State var color: Color
    @State var status: Status
    @State var agreedToTerms: Bool

    var body: some View {
        Button {
            if (title == "" || description == "" || date == Date() || status.rawValue == ""){
                color = .gray
            } else {
                agreedToTerms = true
                if (agreedToTerms == true) {
                    color = .orange
                }
                noteVM.note = noteVM.addTask(title: title, notes: notes, status: status, date: date, description: description, vc: viewContext)
                isAddPresented.toggle()
            }
        } label: {
            HStack{
                Spacer()
                Text("Ajouter")
                    .bold()
                    .padding()
                    .frame(width: 300)
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: 20).foregroundColor(color))
                Spacer()
            }.padding()
        }.disabled(isDisabled)
    }
}

//struct ButtonAjout_Previews: PreviewProvider {
//    static var previews: some View {
//        ButtonAjout(action: () -> (), isDisabled: true, isAddPresented: .constant(true), title: "", description: "", content: "", date: Date.now, color: Color.gray, status: Status.priority, agreedToTerms: true)
//    }
//}
