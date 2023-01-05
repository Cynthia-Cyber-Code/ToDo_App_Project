//
//  SeachView.swift
//  ToDo-list
//
//  Created by Cynthia on 04/01/2023.
//

import SwiftUI

struct SeachView: View {
    var body: some View {
        List {
            ForEach(0...2, id: \.self) { index in
                ZStack(alignment: .leading) {
                    NavigationLink(
                        destination: Text("Item #\(index)")) {
                            EmptyView()
                        }
                        .opacity(0)
                Text("Item #\(index)")
                                }
//            HStack(spacing: 0) {
//              Text("Something")
//
//              NavigationLink(destination: ListView()) {
//                EmptyView()
//              }
//              .frame(width: 0)
//              .opacity(0)
//            }
          }
        }
    }
}

struct SeachView_Previews: PreviewProvider {
    static var previews: some View {
        SeachView()
    }
}
