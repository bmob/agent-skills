// ViewModels/TodoViewModel.swift
import Foundation
import BmobSDK

@MainActor
class TodoViewModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let className = "TodoItem"
    
    // MARK: - 查询任务
    
    func fetchTodos() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let query = BmobQuery(className: className)
                .order(byDescending: "createdAt")
                .limit(50)
            
            todos = try await query.find()
        } catch {
            errorMessage = "获取任务失败: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - 按状态筛选
    
    func fetchTodos(status: TaskStatus) async {
        isLoading = true
        
        do {
            let query = BmobQuery(className: className)
            
            switch status {
            case .pending:
                query.whereKey("isCompleted", equalTo: false)
            case .completed:
                query.whereKey("isCompleted", equalTo: true)
            case .all:
                break
            }
            
            todos = try await query.find()
        } catch {
            errorMessage = "获取任务失败"
        }
        
        isLoading = false
    }
    
    // MARK: - 按优先级筛选
    
    func fetchTodos(priority: Int) async {
        isLoading = true
        
        do {
            let query = BmobQuery(className: className)
                .whereKey("priority", equalTo: priority)
                .order(byDescending: "createdAt")
            
            todos = try await query.find()
        } catch {
            errorMessage = "获取任务失败"
        }
        
        isLoading = false
    }
    
    // MARK: - 创建任务
    
    func createTodo(title: String, content: String?, priority: Int, dueDate: Date?) async -> Bool {
        let todo = TodoItem(title: title, content: content, priority: priority)
        todo.dueDate = dueDate
        todo.isCompleted = false
        
        // 关联当前用户
        if let user = BmobUser.current {
            todo.author = BmobPointer(className: "_User", objectId: user.objectId ?? "")
        }
        
        do {
            try await todo.save()
            todos.insert(todo, at: 0)
            return true
        } catch {
            errorMessage = "创建任务失败"
            return false
        }
    }
    
    // MARK: - 更新任务
    
    func updateTodo(_ todo: TodoItem, title: String? = nil, content: String? = nil, isCompleted: Bool? = nil) async -> Bool {
        if let title = title { todo.title = title }
        if let content = content { todo.content = content }
        if let completed = isCompleted { todo.isCompleted = completed }
        
        do {
            try await todo.update()
            // 刷新列表
            await fetchTodos()
            return true
        } catch {
            errorMessage = "更新任务失败"
            return false
        }
    }
    
    // MARK: - 切换完成状态
    
    func toggleComplete(_ todo: TodoItem) async {
        todo.isCompleted.toggle()
        
        do {
            try await todo.update()
            if let index = todos.firstIndex(where: { $0.objectId == todo.objectId }) {
                todos[index] = todo
            }
        } catch {
            todo.isCompleted.toggle() // 回滚
            errorMessage = "更新失败"
        }
    }
    
    // MARK: - 删除任务
    
    func deleteTodo(_ todo: TodoItem) async -> Bool {
        do {
            try await todo.delete()
            todos.removeAll { $0.objectId == todo.objectId }
            return true
        } catch {
            errorMessage = "删除失败"
            return false
        }
    }
    
    // MARK: - 批量删除已完成
    
    func deleteCompleted() async {
        let completed = todos.filter { $0.isCompleted }
        
        for todo in completed {
            do {
                try await todo.delete()
            } catch {
                continue
            }
        }
        
        todos.removeAll { $0.isCompleted }
    }
    
    // MARK: - 搜索任务
    
    func searchTodos(keyword: String) async {
        isLoading = true
        
        do {
            let query = BmobQuery(className: className)
                .whereKey("title", matchesRegex: keyword)
                .order(byDescending: "createdAt")
            
            todos = try await query.find()
        } catch {
            errorMessage = "搜索失败"
        }
        
        isLoading = false
    }
    
    // MARK: - 获取计数
    
    func getCount() async -> (total: Int, completed: Int) {
        do {
            let allQuery = BmobQuery(className: className)
            let total = try await allQuery.count()
            
            let completedQuery = BmobQuery(className: className)
                .whereKey("isCompleted", equalTo: true)
            let completed = try await completedQuery.count()
            
            return (total, completed)
        } catch {
            return (0, 0)
        }
    }
}

// MARK: - 任务状态枚举

enum TaskStatus {
    case all
    case pending
    case completed
}