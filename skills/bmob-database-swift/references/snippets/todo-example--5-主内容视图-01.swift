// Views/ContentView.swift
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        Group {
            if authVM.currentUser != nil {
                TodoListView()
            } else {
                LoginView()
            }
        }
    }
}