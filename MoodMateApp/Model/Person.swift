//
//  Person.swift
//  MoodMateApp
//
//  Created by Rıdvan Karslı on 7.08.2024.
//

import Foundation

class Person{
    var name : String?
    var birthDate : Date?
    var email : String?
    var userName : String?
    var password : Data?
    var interests : [String]
    
    init(name: String? = nil, birthDate: Date? = nil, email: String? = nil, userName: String? = nil, password: Data? = nil, interests: [String]) {
        self.name = name
        self.birthDate = birthDate
        self.email = email
        self.userName = userName
        self.password = password
        self.interests = interests
    }
}
