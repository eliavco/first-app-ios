//
//  ContentView.swift
//  first-app
//
//  Created by Eliav Cohen on 01/05/2021.
//

import SwiftUI
import RxSwift

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}

class User {
    var id: String = UUID().uuidString
    var name: String = ""
    var color: Color
    
    private var _nameChanged: BehaviorSubject<String> = BehaviorSubject<String>(value: "")
    var nameChanged: Observable<String>
    func changeUser(text: String) {
        self._nameChanged.onNext(text)
        self.name = text
    }
    
    init(color: Color) {
        self.color = color
        self.nameChanged = self._nameChanged.asObservable()
        self.nameChanged.subscribe(onNext: { val in
            print("New name for \(self.color) is: \(val)")
        })
    }
}

struct MyView: View {
    private var user: User
    private var index: Int
    @State private var text: String = ""
    
    init(i: Int, user: User) {
        self.user = user
        self.index = i
        print(i)
    }

    func changedText(to value: String) {
        self.user.changeUser(text: text)
    }
    
    var body: some View {
        TextField("Username", text: $text.onChange(changedText))
            .accentColor(self.user.color)
            .padding(5)
            .border(self.user.color, width: 1)
        if !text.isEmpty {
            Text("Welcome \(text)!")
                .bold()
                .italic()
                .underline()
                .padding(5)
                .foregroundColor(self.user.color)
                .shadow(color: .black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                .border(self.user.color, width: 5)
        }
        Button("Autofill") {
            text = "Autofilled"
        }
        .foregroundColor(self.user.color)
    }
}

struct ContentView: View {
    let users: [User] = [User(color: .blue), User(color: .red), User(color: .green)];
    
    var body: some View {
        ScrollView {
            ForEach(users.indices, id: \.self) { i in
                MyView(i: i, user: users[i])
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
