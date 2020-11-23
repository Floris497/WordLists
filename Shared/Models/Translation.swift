//
//  Translation.swift
//  WordLists
//
//  Created by Floris Fredrikze on 22/11/2020.
//

import Foundation

struct Translation : Decodable, Identifiable, Hashable {
    var id: UUID
    var original: String
    var translation: String
}
