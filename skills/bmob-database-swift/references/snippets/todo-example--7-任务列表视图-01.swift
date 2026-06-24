// Views/TodoListView.swift
import SwiftUI

struct TodoListView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject private var viewModel = TodoViewModel()
    
    @State private var selectedFilter: TaskStatus = .all
    @State private var showingAddSheet = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                // 筛选器
                Picker("筛选", selection: $selectedFilter) {
                    Text("全部").tag(TaskStatus.all)
                    Text("待完成").tag(TaskStatus.pending)
                    Text("已完成").tag(TaskStatus.completed)
                }
                .pickerStyle(.segmented)
                .padding()
                .onChange(of: selectedFilter) { _, newValue in
                    Task {
                        await viewModel.fetchTodos(status: newValue)
                    }
                }
                
                if viewModel.isLoading && viewModel.todos.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.todos.isEmpty {
                    ContentUnavailableView(
                        "暂无任务",
                        systemImage: "checkmark.circle",
                        description: Text("点击 + 按钮创建新任务")
                    )
                } else {
                    List {
                        ForEach(filteredTodos, id: \.objectId) { todo in
                            TodoRowView(todo: todo, viewModel: viewModel)
                        }
                        .onDelete(perform: deleteTodos)
                    }
                    .listStyle(.insetGrouped)
                    .refreshable {
                        await viewModel.fetchTodos(status: selectedFilter)
                    }
                }
            }
            .navigationTitle("任务清单")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("登出") {
                        authVM.logout()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                TodoEditorView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchTodos(status: selectedFilter)
            }
        }
    }
    
    private var filteredTodos: [TodoItem] {
        if searchText.isEmpty {
            return viewModel.todos
        }
        return viewModel.todos.filter {
            $0.title?.localizedCaseInsensitiveContains(searchText) == true
        }
    }
    
    private func deleteTodos(at offsets: IndexSet) {
        for index in offsets {
            let todo = filteredTodos[index]
            Task {
                await viewModel.deleteTodo(todo)
            }
        }
    }
}

// MARK: - 任务行视图

struct TodoRowView: View {
    let todo: TodoItem
    @ObservedObject var viewModel: TodoViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            // 完成状态按钮
            Button(action: {
                Task {
                    await viewModel.toggleComplete(todo)
                }
            }) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(todo.isCompleted ? .green : .gray)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title ?? "")
                    .font(.headline)
                    .strikethrough(todo.isCompleted)
                    .foregroundColor(todo.isCompleted ? .secondary : .primary)
                
                if let content = todo.content, !content.isEmpty {
                    Text(content)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                HStack(spacing: 8) {
                    // 优先级标签
                    priorityBadge
                    
                    // 截止日期
                    if let dueDate = todo.dueDate {
                        Text(dueDate, style: .date)
                            .font(.caption)
                            .foregroundColor(dueDate < Date() ? .red : .secondary)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private var priorityBadge: some View {
        let (text, color) = priorityInfo
        return Text(text)
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(4)
    }
    
    private var priorityInfo: (String, Color) {
        switch todo.priority {
        case 3: return ("高优", .red)
        case 2: return ("中优", .orange)
        default: return ("低优", .green)
        }
    }
}