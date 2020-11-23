//
//  ContentView.swift
//  Shared
//
//  Created by Floris Fredrikze on 22/11/2020.
//

import SwiftUI

struct TranslationList: View {
    var wordlist: Wordlist

    @ScaledMetric var size: CGFloat = 1
    @State private var showPopover: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 50) {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(wordlist.translations) { translation in
                        HStack {
                            Text("\(translation.original)")
                                .font(.system(size: 15 * size, weight: .bold, design: .default))
                            Spacer()
                            Text("\(translation.translation)")
                                .font(.system(size: 15 * size, weight: .bold, design: .default))
                        }
                        .padding()
                        Divider()
                    }
                }
            }
        }
        .navigationTitle("\(wordlist.title)")
        .toolbar {
            Text("\(wordlist.langFrom.rawValue.capitalized) to \(wordlist.langTo.rawValue.capitalized)")
                .font(.system(size: 24 * size, weight: .bold, design: .default))
                .padding()
        }
    }
}

struct ContentView: View {
    @ObservedObject var wordlistData = WordlistData()

    @State var selection: Int?

    @ScaledMetric var size: CGFloat = 1

    var body: some View {

        GeometryReader { geometry in
            NavigationView
            {
                List
                {
                    if wordlistData.dataIsLoaded {
                        if let wordlists = wordlistData.wordlists
                        {
                            ForEach(wordlists) { wordlist in
                                NavigationLink(destination: TranslationList(wordlist: wordlist), tag: wordlist.id.hashValue, selection: self.$selection) {
                                    Text("\(wordlist.title)")
                                }
                            }
                        }
                    }
                    else {
                        HStack(alignment: .center) {
                            Text("No Wordlists")
                                .font(.system(size: 16 * size, weight: .regular, design: .default))
                                .frame(minHeight: geometry.size.height - 20)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .listStyle(SidebarListStyle())
                .toolbar {
                    Spacer()
                }
                Text("No Wordlist Selected")
                    .font(.system(size: 16 * size, weight: .regular, design: .default))
                    .padding()
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
