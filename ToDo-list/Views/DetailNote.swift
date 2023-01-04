//
//  DetailNote.swift
//  ToDo-list
//
//  Created by Cynthia on 03/01/2023.
//

import SwiftUI

struct DetailNote: View {
    @State var title: String
    var body: some View {
        Text(title)
    }
}

struct DetailNote_Previews: PreviewProvider {
    static var previews: some View {
        DetailNote(title: "")
    }
}
