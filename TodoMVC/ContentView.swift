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

    @ObservedObject private var viewModel = TodoViewModel()
    @State private var newTitle = ""
    @State private var view: ItemStatusFilter = .all

    func shouldShowItem(item: TodoItem) -> Bool {
        switch view {
        case .all: return true
        case .active: return !item.isCompleted
        case .completed: return item.isCompleted
        }
    }

    var title: some View {
        Text("todos")
            .foregroundColor(Color(hue: 0, saturation: 0.57, brightness: 0.43, opacity: 0.15))
            .font(Font.system(size: 80).weight(.thin))
            .padding(.top)
    }

    var createItemBar: some View {
        HStack {
            if !self.viewModel.items.isEmpty {
                Button(action: { self.viewModel.toggleAllCompleted() }, label: {
                    Image(systemName: "chevron.down")
                        .foregroundColor(self.viewModel.areAllCompleted ? Color.gray : Color.gray.opacity(0.5))
                        .frame(width: 20, height: 20)
                        .padding()
                })
            }

            TextField(
                "What needs to be done?",
                text: self.$newTitle,
                onEditingChanged: { _ in },
                onCommit: {
                    if !self.newTitle.isEmpty {
                        self.viewModel.createTodo(title: self.newTitle)
                        self.newTitle = ""
                    }
                }
            )
            .padding(self.viewModel.items.isEmpty ? .horizontal : .trailing)
            .font(self.newTitle.isEmpty ? Font.body.italic() : Font.body)
            .frame(height: 60)
        }
    }

    var itemDivider: some View {
        Rectangle()
            .fill(Color(white: 0.9))
            .frame(height: 0.5)
    }

    var filterControls: some View {
        VStack(alignment: .center, spacing: 16) {
            Picker(selection: self.$view, label: Text("Status")) {
                Text("All").tag(ItemStatusFilter.all)
                Text("Active").tag(ItemStatusFilter.active)
                Text("Completed").tag(ItemStatusFilter.completed)
            }
            .pickerStyle(SegmentedPickerStyle())

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
            .animation(nil)
        }
        .padding(.horizontal)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 0) {
                title

                VStack(alignment: .leading, spacing: 0) {
                    createItemBar

                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(self.viewModel.items.filter(self.shouldShowItem)) {
                            self.itemDivider
                            Item(viewModel: self.viewModel, item: $0)
                        }
                    }
                }
                .background(
                    Color.white
                        .shadow(
                            color: Color(hue: 0, saturation: 0, brightness: 0, opacity: 0.1),
                            radius: 4,
                            x: 0,
                            y: 2
                        )
                )
                .padding()

                if !self.viewModel.items.isEmpty {
                    filterControls
                }
            }
            .frame(maxWidth: 550, alignment: .center)
        }
        .frame(maxWidth: .infinity)
        .background(
            Color(white: 0.96)
                .edgesIgnoringSafeArea(.all)
        )
    }
}
