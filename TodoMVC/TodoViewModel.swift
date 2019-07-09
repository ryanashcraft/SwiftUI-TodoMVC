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
    var didChange = PassthroughSubject<TodoViewModel, Never>()
    
    var areAllCompleted: Bool {
        self.items.count - self.incompleteCount == 0
    }
    var incompleteCount: Int = 0
    
    @Published var items: [TodoItem] = [] {
        didSet {
            self.incompleteCount = items.filter { !$0.isCompleted }.count
        }
    }
    
    func createTodo(title: String) {
        items.append(TodoItem(
            id: UUID(),
            isCompleted: false,
            title: title
        ))
        
        self.didChange.send(self)
    }
    
    func setIsCompleted(itemId: UUID, isCompleted: Bool) {
        items = items.map {
            if $0.id == itemId {
                return TodoItem(id: $0.id, isCompleted: isCompleted, title: $0.title)
            }
            
            return $0
        }
        
        self.didChange.send(self)
    }
    
    func setTitle(itemId: UUID, title: String) {
        items = items.map {
            if $0.id == itemId {
                return TodoItem(id: $0.id, isCompleted: $0.isCompleted, title: title)
            }
            
            return $0
        }
        
        self.didChange.send(self)
    }
    
    func toggleAllCompleted() {
        if areAllCompleted {
            items = items.map {
                return TodoItem(id: $0.id, isCompleted: false, title: $0.title)
            }
        } else {
            items = items.map {
                return TodoItem(id: $0.id, isCompleted: true, title: $0.title)
            }
        }
        
        self.didChange.send(self)
    }
    
    func removeItem(itemId: UUID) {
        items = items.filter { $0.id != itemId }
        
        self.didChange.send(self)
    }
    
    func clearCompleted() {
        items = items.filter { !$0.isCompleted }
        
        self.didChange.send(self)
    }
    
}
