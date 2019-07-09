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
        Button(action: self.action, label: {
            ZStack {
                Circle()
                    .stroke(isCompleted ? Color.green : Color.gray, lineWidth: 1.5)
                    .frame(width: 20, height: 20)
                Group {
                    if isCompleted {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 12.5, height: 12.5)
                    }
                }
            }
            .padding()
        })
    }
}

struct Item: View {
    @ObjectBinding var viewModel: TodoViewModel
    var item: TodoItem
    
    @State private var isShowingAlert = false
    
    var titleBinding: Binding<String> {
        Binding(
            getValue: {
                return self.item.title
        },
            setValue: {
                self.viewModel.setTitle(itemId: self.item.id, title: $0)
        }
        )
    }
    
    var body: some View {
        HStack(alignment: .center) {
            CompleteButton(isCompleted: self.item.isCompleted, action: {
                self.viewModel.setIsCompleted(itemId: self.item.id, isCompleted: !self.item.isCompleted)
            })
            TextField(titleBinding)
                .padding(.vertical)
                .background(Color.white)
                .foregroundColor(self.item.isCompleted ? Color.gray : Color.black)
                .layoutPriority(1)
            Spacer()
            Button(action: {
                self.viewModel.removeItem(itemId: self.item.id)
            }, label: {
                Image(systemName: "trash")
                    .padding()
            })
        }
        .background(Color.white)
            .frame(height: 60)
            .background(Color.white)
            .presentation($isShowingAlert) {
                Alert(title: Text("Important message"), message: Text("Wear sunscreen"), dismissButton: .default(Text("Got it!")))
        }
    }
}
