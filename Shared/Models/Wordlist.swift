//
//  Wordlist.swift
//  WordLists
//
//  Created by Floris Fredrikze on 22/11/2020.
//

import Foundation

class WordlistData: ObservableObject {
    @Published var dataIsLoaded: Bool = false
    @Published var wordlists: [Wordlist]? = nil

    init() {
        loadData()
    }

    func loadData() {
        let url = URL(string: "http://192.168.178.26:8080/wordlists")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard error == nil else {
                NSLog("error: \(error!)")
                return
            }

            guard let content = data else {
                NSLog("No data")
                return
            }

            DispatchQueue.main.async {
                do {
                    self.wordlists = try JSONDecoder().decode([Wordlist].self, from: content)
                    self.dataIsLoaded = true
                } catch {
                    fatalError("Couldn't decode")
                }
            }
            NSLog("Data loaded")
        }
        task.resume()
    }
}

struct Wordlist : Decodable, Identifiable {
    enum Language: String, Decodable {
        case english
        case russian
        case dutch
        case french
        case spanish
        case chinese
        case japanese
        case german
        case polish
        case finish
        case czech
        case portuguese
        case greek
        case latin
    }
    
    var id: UUID
    var title: String
    var langFrom: Language
    var langTo: Language
    var translations: [Translation]
}
