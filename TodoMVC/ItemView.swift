//
//  ItemView.swift
//  TodoMVC
//
//  Created by Ryan Ashcraft on 7/9/19.
//  Copyright © 2019 Ryan Ashcraft. All rights reserved.
//

import SwiftUI

struct CompleteButton: View {
    let isCompleted: Bool
    let action: () -> Void

    var body: some View {
        Button(action: self.action) {
            ZStack {
                Circle()
                    .stroke(isCompleted ? Color.green : Color.gray, lineWidth: 1.5)
                    .frame(width: 20, height: 20)

                if isCompleted {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 12.5, height: 12.5)
                }
            }
            .padding()
        }
    }
}

struct Item: View {
    @ObservedObject var viewModel: TodoViewModel
    var item: TodoItem

    var titleBinding: Binding<String> {
        Binding(
            get: {
                self.item.title
            },
            set: {
                self.viewModel.setTitle(itemId: self.item.id, title: $0)
            }
        )
    }

    var body: some View {
        HStack(alignment: .center) {
            CompleteButton(
                isCompleted: self.item.isCompleted,
                action: {
                    self.viewModel.setIsCompleted(itemId: self.item.id, isCompleted: !self.item.isCompleted)
                }
            )

            TextField("Title", text: titleBinding)
                .padding(.vertical)
                .background(Color.white)
                .foregroundColor(self.item.isCompleted ? Color.gray : Color.black)
                .layoutPriority(1)

            Spacer()

            Button(action: { self.viewModel.removeItem(itemId: self.item.id) }) {
                Image(systemName: "trash")
                    .padding()
            }
        }
        .frame(height: 60)
        .background(Color.white)
    }
}
