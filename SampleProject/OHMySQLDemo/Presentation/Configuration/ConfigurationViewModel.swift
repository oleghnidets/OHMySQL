//
//  Copyright (c) 2022-Present Oleg Hnidets
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import Combine

@propertyWrapper
struct Storage<T> {
    private let key: String
    
    init(key: String) {
        self.key = key
    }
    
    var wrappedValue: T? {
        get {
            UserDefaults.standard.value(forKey: key) as? T
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

struct SettingsData {
    @Storage(key: "port")
    static var port: String?
    
    @Storage(key: "username")
    static var username: String?
    
    @Storage(key: "password")
    static var password: String?
    
    @Storage(key: "serverName")
    static var serverName: String?
    
    @Storage(key: "database")
    static var database: String?
    
    @Storage(key: "socket")
    static var socket: String?
}

final class ConfigurationViewModel: ObservableObject {
    @Published var port = SettingsData.port ?? ""
    @Published var username = SettingsData.username ?? ""
    @Published var password = SettingsData.password ?? ""
    @Published var serverName = SettingsData.serverName ?? ""
    @Published var database = SettingsData.database ?? ""
    @Published var socket = SettingsData.socket ?? ""
    
    private var cancellables: Set<AnyCancellable> = []

    func save() {
//        SettingsData.port
//
//            SettingsData.username = $0
//        }.store(in: &cancellables)
        $password.sink { SettingsData.password = $0 }.store(in: &cancellables)
        $serverName.sink { SettingsData.serverName = $0 }.store(in: &cancellables)
        $database.sink { SettingsData.database = $0 }.store(in: &cancellables)
        $socket.sink { SettingsData.socket = $0 }.store(in: &cancellables)
    }
    
    func viewLoaded() {
        $port.sink { SettingsData.port = $0 }.store(in: &cancellables)
        $username.sink {
            SettingsData.username = $0
        }.store(in: &cancellables)
        $password.sink { SettingsData.password = $0 }.store(in: &cancellables)
        $serverName.sink { SettingsData.serverName = $0 }.store(in: &cancellables)
        $database.sink { SettingsData.database = $0 }.store(in: &cancellables)
        $socket.sink { SettingsData.socket = $0 }.store(in: &cancellables)
    }
}
