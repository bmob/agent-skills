// Views/TodoEditorView.swift
import SwiftUI

struct TodoEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TodoViewModel
    
    @State private var title = ""
    @State private var content = ""
    @State private var priority = 1
    @State private var hasDueDate = false
    @State private var dueDate = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("任务信息") {
                    TextField("标题", text: $title)
                    
                    TextField("描述（可选）", text: $content, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("优先级") {
                    Picker("优先级", selection: $priority) {
                        Text("低").tag(1)
                        Text("中").tag(2)
                        Text("高").tag(3)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("截止日期") {
                    Toggle("设置截止日期", isOn: $hasDueDate)
                    
                    if hasDueDate {
                        DatePicker("日期", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }
            }
            .navigationTitle("新建任务")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        Task {
                            let success = await viewModel.createTodo(
                                title: title,
                                content: content.isEmpty ? nil : content,
                                priority: priority,
                                dueDate: hasDueDate ? dueDate : nil
                            )
                            if success {
                                dismiss()
                            }
                        }
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}