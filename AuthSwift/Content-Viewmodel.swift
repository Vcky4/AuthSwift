//
//  Content-Viewmodel.swift
//  AuthSwift
//
//  Created by mac on 25/04/2023.
//

import Foundation
import SwiftUI

extension ContentView {
    class ViewModel: ObservableObject{
        @AppStorage("AUTH_KEY") var authenticated = false{
            willSet{ objectWillChange.send()}
        }
        @AppStorage("USER_KEY") var username = ""
        @Published var password = ""
        @Published var invalid: Bool = false
        
        private var sampleUser = "username"
        private var samplePassword = "password"
        
        init() {
         print("currently logged on: \(authenticated)")
         print("current user: \(username)")
        }
        
        func toogleAuthentication(){
            self.password = ""
            
            withAnimation {
                authenticated.toggle()
            }
        }
        
        func authenticate(){
            guard self.username.lowercased() == sampleUser else{
                self.invalid = true
                return
            }
            
            guard self.password.lowercased() == samplePassword else{
                self.invalid = true
                return
            }
            
            toogleAuthentication()
        }
        
        func logOut(){
            toogleAuthentication()
        }
        
        func logPress(){
            print("Button pressed")
        }
    }
}
