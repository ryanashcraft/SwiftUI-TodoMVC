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

final class TodoViewModel: BindableObject {
    var willChange = PassthroughSubject<TodoViewModel, Never>()
    
    var areAllCompleted: Bool {
        self.items.count - self.incompleteCount == self.items.count
    }

    var incompleteCount: Int = 0
    
    var completeCount: Int = 0
    
    var items: [TodoItem] = [] {
        didSet {
            incompleteCount = items.filter { !$0.isCompleted }.count
            completeCount = items.count - incompleteCount
        }
    }
    
    func createTodo(title: String) {
        willChange.send(self)

        items.append(TodoItem(
            id: UUID(),
            isCompleted: false,
            title: title
        ))
    }
    
    func setIsCompleted(itemId: UUID, isCompleted: Bool) {
        willChange.send(self)

        items = items.map {
            if $0.id == itemId {
                return TodoItem(id: $0.id, isCompleted: isCompleted, title: $0.title)
            }
            
            return $0
        }
    }
    
    func setTitle(itemId: UUID, title: String) {
        willChange.send(self)

        items = items.map {
            if $0.id == itemId {
                return TodoItem(id: $0.id, isCompleted: $0.isCompleted, title: title)
            }
            
            return $0
        }
    }
    
    func toggleAllCompleted() {
        willChange.send(self)

        if areAllCompleted {
            items = items.map {
                return TodoItem(id: $0.id, isCompleted: false, title: $0.title)
            }
        } else {
            items = items.map {
                return TodoItem(id: $0.id, isCompleted: true, title: $0.title)
            }
        }
    }
    
    func removeItem(itemId: UUID) {
        willChange.send(self)

        items = items.filter { $0.id != itemId }
    }
    
    func clearCompleted() {
        willChange.send(self)

        items = items.filter { !$0.isCompleted }
    }
}
