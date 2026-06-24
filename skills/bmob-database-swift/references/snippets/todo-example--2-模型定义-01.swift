// Models/TodoItem.swift
import Foundation
import BmobData

/// 任务数据模型
class TodoItem: BmobObject {
    /// 任务标题
    var title: String? {
        get { self["title"] as? String }
        set { self["title"] = newValue }
    }
    
    /// 任务描述
    var content: String? {
        get { self["content"] as? String }
        set { self["content"] = newValue }
    }
    
    /// 是否完成
    var isCompleted: Bool {
        get { self["isCompleted"] as? Bool ?? false }
        set { self["isCompleted"] = newValue }
    }
    
    /// 截止日期
    var dueDate: Date? {
        get { self["dueDate"] as? Date }
        set { self["dueDate"] = newValue }
    }
    
    /// 优先级（1: 低, 2: 中, 3: 高）
    var priority: Int {
        get { self["priority"] as? Int ?? 1 }
        set { self["priority"] = newValue }
    }
    
    /// 创建者
    var author: BmobPointer? {
        get { self["author"] as? BmobPointer }
        set { self["author"] = newValue }
    }
    
    /// 标签
    var tags: [String]? {
        get { self["tags"] as? [String] }
        set { self["tags"] = newValue }
    }
    
    override init() {
        super.init(className: "TodoItem")
    }
    
    init(title: String, content: String? = nil, priority: Int = 1) {
        super.init(className: "TodoItem")
        self.title = title
        self.content = content
        self.priority = priority
        self.isCompleted = false
    }
}