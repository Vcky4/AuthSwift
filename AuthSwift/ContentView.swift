//
//  ContentView.swift
//  AuthSwift
//
//  Created by mac on 25/04/2023.
//

import SwiftUI

struct Response: Codable{
    var results: [Result]
}

struct Result: Codable{
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct ContentView: View {
    @StateObject var vm = ViewModel()
    @StateObject var locationManager = LocationManager()
    @State private var results = [Result]()
    var userLatitude: String {
           return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
       }
       
       var userLongitude: String {
           return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
       }
    var body: some View {
        if vm.authenticated{
            VStack(spacing: 20) {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Welcome back **\(vm.username)**!")
                Text("Today is **\(Date().formatted(.dateTime))**")
                Text("location status: \(locationManager.statusString)")
                            HStack {
                                Text("latitude: \(userLatitude)")
                                Text("longitude: \(userLongitude)")
                            }
                Button("Log out", action: vm.logOut)
                    .tint(.red)
                    .buttonStyle(.bordered)
            }
            .padding()
            List(results, id: \.trackId){
                item in
                VStack(alignment: .leading){
                    Text(item.trackName)
                        .font(.headline)
                    Text(item.collectionName )
                        .font(.headline)
                }
            }.task {
                await loadData()
            }
            
        }else{
            ZStack{
                Image("sky")
                    .resizable()
                    .cornerRadius(20)
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 20){
                    Spacer()
                    Text("Log in")
                        .foregroundColor(.white)
                        .font(.system(size:  50, weight: .medium, design: .rounded))
                    TextField("Username", text:$vm.username)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization( .never)
                    SecureField("Password", text: $vm.password)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .privacySensitive()
                    HStack{
                        Spacer()
                        Button("Forgot password?", action: vm.logPress)
                            .tint(.red.opacity(0.8))
                        Spacer()
                        Button("Log in", action: vm.authenticate)
                            .buttonStyle(.bordered)
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
                .frame(width: 300)
                .alert("Access Denied", isPresented: $vm.invalid){
                    Button("Dismiss", action: vm.logPress)
                }
            }.transition(.offset(x:0,y:850))
                
        }
    }
    func loadData() async{
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else{
            print("Invalod URL")
            return
        }
        
        do{
            let(data,_) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data){
                results = decodedResponse.results
            }
        }catch{
            print("Invalid data")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
