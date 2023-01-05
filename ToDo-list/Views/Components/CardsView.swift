//
//  CardsView.swift
//  ToDo-list
//
//  Created by Cynthia on 05/01/2023.
//

import SwiftUI

struct CardsView: View {
    @State var title: String
    @State var date: Date
    @State var status: String
    var body: some View {
        VStack{
            Text(title)
                .font(.title)
                .shadow(radius: 20)
                .bold()
                .padding(.vertical,20)
            HStack {
                Text("\(date.formatted(date: .abbreviated, time: .shortened))")
                    .font(.title2)
                    .frame(width: 135)
                Spacer()
                if status == "clock.badge.exclamationmark.fill"
                {
                    Image(systemName: "hourglass.circle.fill").font(.title).bold().foregroundColor(.red).opacity(0.7)
                }
            }.padding()
        }.foregroundColor(.black)
            .padding()
    }
}

struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        CardsView(title: "", date: Date(), status: "clock.badge.exclamationmark.fill")
    }
}
