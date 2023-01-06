//
//  TabBarView.swift
//  ToDo-list
//
//  Created by Cynthia on 05/01/2023.
//

import SwiftUI
enum Tab: Int, Identifiable, CaseIterable, Comparable {
    static func < (lhs: Tab, rhs: Tab) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case all, wait, end, late
    
    internal var id: Int { rawValue }
    
    var icon: String {
        switch self {
        case .all:
            return "filemenu.and.selection"
        case .wait:
            return "playpause.fill"
        case .end:
            return "calendar.badge.minus"
        case .late:
            return "repeat"
        }
    }
    
    var title: String {
        switch self {
        case .all:
            return "ALL"
        case .wait:
            return "wait"
        case .end:
            return "End"
        case .late:
            return "Late"
        }
    }
    
    var color: Color {
        switch self {
        case .all:
            return .green
        case .wait:
            return .orange
        case .end:
            return .gray
        case .late:
            return .red
        }
    }

}


struct SelectButton: View {
    let tab: Tab
    @Binding var selectedTab: Tab
    var namespace: Namespace.ID
    @State private var selectedOffset: CGFloat = 0
    @State private var rotationAngle: CGFloat = 0
    
    var body: some View {
        Button {
            withAnimation(.easeInOut) {
                selectedTab = tab
            }
            
            selectedOffset = -60
            if tab < selectedTab {
                rotationAngle += 360
            } else {
                rotationAngle -= 360
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                selectedOffset = 0
                if tab < selectedTab {
                    rotationAngle += 720
                } else {
                    rotationAngle -= 720
                }
            }
        } label: {
            ZStack {
                if isSelected {
                    Capsule()
                        .fill(tab.color.opacity(0.2))
                        .matchedGeometryEffect(id: "Selected Tab", in: namespace)
                }
                HStack(spacing: 10) {
                    Image(systemName: tab.icon)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(isSelected ? tab.color : .black.opacity(0.6))
                        .rotationEffect(.degrees(rotationAngle))
                        .scaleEffect(isSelected ? 1 : 0.9)
                        .animation(.easeInOut, value: rotationAngle)
                        .opacity(isSelected ? 1 : 0.7)
                        .padding(.leading, isSelected ? 20 : 0)
                        .padding(.horizontal, selectedTab != tab ? 10 : 0)
                        .offset(y: selectedOffset)
                        .animation(.default, value: selectedOffset)
                    
                    if isSelected {
                        Text(tab.title)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(tab.color)
                    }
                }
                .padding(.vertical, 10)
            }
        }
        .buttonStyle(.plain)
    }
    
    private var isSelected: Bool {
        selectedTab == tab
    }
}

struct TabsLayoutView: View {
    @State var selectedTab: Tab
    @Namespace var namespace
    
    var body: some View {
        HStack {
            ForEach(Tab.allCases) { tab in
                SelectButton(tab: tab, selectedTab: $selectedTab, namespace: namespace)
                Text(selectedTab.title)
            }
        }
    }
}

struct SelectBarView: View {
    @State var page : Tab
    var body: some View {
        VStack {
            TabsLayoutView(selectedTab: page)
            
                .padding()
                .background(
                    Capsule()
                        .fill(.white)
                )
                .frame(height: 70)
                .shadow(radius: 30)
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        SelectBarView(page: .all)
    }
}
