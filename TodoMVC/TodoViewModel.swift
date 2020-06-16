//
//  ViewModel.swift
//  TodoMVC
//
//  Created by Ryan Ashcraft on 7/9/19.
//  Copyright © 2019 Ryan Ashcraft. All rights reserved.
//

import Combine
import SwiftUI

struct TodoItem: Identifiable {
    let id: UUID
    var isCompleted: Bool
    var title: String
}

final class TodoViewModel: ObservableObject {
    var areAllCompleted: Bool {
        items.count - incompleteCount == items.count
    }

    var incompleteCount: Int = 0
    var completeCount: Int = 0

    @Published var items: [TodoItem] = [] {
        didSet {
            incompleteCount = items.filter { !$0.isCompleted }.count
            completeCount = items.count - incompleteCount
        }
    }

    func createTodo(title: String) {
        items.append(TodoItem(
            id: UUID(),
            isCompleted: false,
            title: title
        ))
    }

    func setIsCompleted(itemId: UUID, isCompleted: Bool) {
        items = items.map {
            if $0.id == itemId {
                return TodoItem(id: $0.id, isCompleted: isCompleted, title: $0.title)
            }

            return $0
        }
    }

    func setTitle(itemId: UUID, title: String) {
        items = items.map {
            if $0.id == itemId {
                return TodoItem(id: $0.id, isCompleted: $0.isCompleted, title: title)
            }

            return $0
        }
    }

    func toggleAllCompleted() {
        if areAllCompleted {
            items = items.map {
                TodoItem(id: $0.id, isCompleted: false, title: $0.title)
            }
        } else {
            items = items.map {
                TodoItem(id: $0.id, isCompleted: true, title: $0.title)
            }
        }
    }

    func removeItem(itemId: UUID) {
        items = items.filter { $0.id != itemId }
    }

    func clearCompleted() {
        items = items.filter { !$0.isCompleted }
    }
}
