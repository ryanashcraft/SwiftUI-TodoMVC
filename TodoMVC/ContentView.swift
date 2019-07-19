//
//  ContentView.swift
//  TodoMVC
//
//  Created by Ryan Ashcraft on 7/9/19.
//  Copyright © 2019 Ryan Ashcraft. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    private enum ItemStatusFilter {
        case all
        case active
        case completed
    }
    
    @ObjectBinding private var viewModel = TodoViewModel()
    @State private var newTitle = ""
    @State private var view: ItemStatusFilter = .all
    
    func shouldShowItem(item: TodoItem) -> Bool {
        switch self.view {
        case .all: return true
        case .active: return !item.isCompleted
        case .completed: return item.isCompleted
        }
    }
    
    var body: some View {
        ZStack {
            Color(white: 0.96)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    Text("todos")
                        .foregroundColor(Color(hue: 0, saturation: 0.57, brightness: 0.43, opacity: 0.15))
                        .font(Font.system(size: 80).weight(.thin))
                        .padding(.top)
                    ZStack {
                        Color.white
                            .shadow(color: Color(hue: 0, saturation: 0, brightness: 0, opacity: 0.1), radius: 4, x: 0, y: 2)
                            .padding()
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                if !self.viewModel.items.isEmpty {
                                    Button(action: { self.viewModel.toggleAllCompleted() }, label: {
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(self.viewModel.areAllCompleted ? Color.gray : Color.gray.opacity(0.5))
                                            .frame(width: 20, height: 20)
                                            .padding()
                                    })
                                }
                                TextField(self.$newTitle, placeholder: Text("What needs to be done?"), onEditingChanged: { _ in }, onCommit: {
                                    if !self.newTitle.isEmpty {
                                        self.viewModel.createTodo(title: self.newTitle)
                                        self.newTitle = ""
                                    }
                                })
                                    .padding(self.viewModel.items.isEmpty ? .horizontal : .trailing)
                                    .font(self.newTitle.isEmpty ? Font.body.italic() : Font.body)
                                    .frame(height: 60)
                            }
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(self.viewModel.items.filter(self.shouldShowItem)) {
                                    Rectangle()
                                        .fill(Color(white: 0.9))
                                        .frame(height: 0.5)
                                    Item(viewModel: self.viewModel, item: $0)
                                }
                            }
                        }
                        .padding()
                    }
                }
                Group {
                    if !self.viewModel.items.isEmpty {
                        VStack(alignment: .center, spacing: 16) {
                            SegmentedControl(selection: self.$view) {
                                Text("All").tag(ItemStatusFilter.all)
                                Text("Active").tag(ItemStatusFilter.active)
                                Text("Completed").tag(ItemStatusFilter.completed)
                            }
                            HStack {
                                Text("\(self.viewModel.incompleteCount) item\(self.viewModel.incompleteCount == 1 ? "" : "s") left\(self.viewModel.completeCount > 0 ? "." : "")")
                                    .foregroundColor(Color.gray)
                                if self.viewModel.completeCount > 0 {
                                    Button("Clear completed.", action: {
                                        self.viewModel.clearCompleted()
                                    })
                                }
                            }
                            .font(Font.caption)
                                .animation(Animation.empty)
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}
