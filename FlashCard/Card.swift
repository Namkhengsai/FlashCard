//
//  Card.swift
//  FlashCard
//
//  Created by k.patrick on 11/10/2567 BE.
//

import Foundation

struct Card: Codable {
    var prompt : String
    var answer : String
    
    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
