//
//  ContentView.swift
//  Shared
//
//  Created by Floris Fredrikze on 22/11/2020.
//

import SwiftUI

struct WordSetView: View {
    var translation: Translation
    
    var buttonAction: (() -> Void)?
    
    @State var showPopoverOriginal: Bool = false
    @State var showPopoverTranslation: Bool = false
    
    
    @ScaledMetric var size: CGFloat = 1
    
    @ViewBuilder var body: some View {
        HStack {
            Text("\(translation.original)")
                .font(.system(size: 18 * size, weight: .bold, design: .rounded))
                .popover(isPresented: self.$showPopoverOriginal) {
                    Text("This is the original text! \(translation.original)")
                        .padding()
                }.onTapGesture {
                    showPopoverOriginal = true
                }
            Spacer()
            Text("\(translation.translation)")
                .font(.system(size: 18 * size, weight: .bold, design: .rounded))
                .popover(isPresented: self.$showPopoverTranslation) {
                    Text("This is the translation! \(translation.translation)")
                        .padding()
                }.onTapGesture {
                    showPopoverTranslation = true
                }
        }.padding()
    }
}

struct TranslationGameView: View {
    var wordlist: Wordlist
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Dismiss view!")
            }
        }
    }
}

struct TranslationListView: View {
    var wordlist: Wordlist
    
    @ScaledMetric var size: CGFloat = 1
    @State private var showPopover: Bool = false
    
    enum ViewType {
        case list
        case game
    }
    
    @State private var viewType: ViewType = .list
    
    var body: some View {
        if viewType == .list {
            List(wordlist.translations) { translation in
                GroupBox {
                    WordSetView(translation: translation)
                }
            }
            .listStyle(InsetListStyle())
            .navigationTitle("\(wordlist.title)")
            .toolbar {
                ToolbarItem {
                    HStack {
                        #if os(macOS)
                        Text("\(wordlist.langFrom.rawValue.capitalized) to \(wordlist.langTo.rawValue.capitalized)")
                            .font(.system(size: 24 * size, weight: .bold, design: .rounded))
                            .padding()
                        #endif
                        Button(action: {
                            viewType = .game
                        }) {
                            Label("Play", systemImage: "play.fill")
                                .frame(width: 24)
                        }
                    }
                }
            }
        } else {
            List(wordlist.translations) { translation in
                GroupBox {
                    WordSetView(translation: translation).foregroundColor(.red)
                }
            }
            .listStyle(InsetListStyle())
            .navigationTitle("\(wordlist.title)")
            .toolbar {
                ToolbarItem {
                    HStack {
                        #if os(macOS)
                        Text("\(wordlist.langFrom.rawValue.capitalized) to \(wordlist.langTo.rawValue.capitalized)")
                            .font(.system(size: 24 * size, weight: .bold, design: .rounded))
                            .padding()
                        #endif
                        Button(action: {
                            viewType = .list
                        }) {
                            Label("Play", systemImage: "stop.fill")
                                .frame(width: 24)
                        }
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var wordlistData = WordlistData()
    
    @State var selection: Int?
    
    @ScaledMetric var size: CGFloat = 1
    
    init() {
        #if os(macOS)
        #else
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.red]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.orange]
        #endif
    }
    
    var body: some View {
        NavigationView {
            if let wordlists = wordlistData.wordlists, wordlistData.dataIsLoaded {
                #if os(macOS)
                // Mac OS
                List(wordlists) { wordlist in
                    NavigationLink(destination: TranslationListView(wordlist: wordlist)) {
                        Text("\(wordlist.title)")
                    }
                }
                .toolbar {
                    Spacer()
                }
                .listStyle(SidebarListStyle())
                Text("No Wordlist Selected")
                    .font(.system(size: 16 * size, weight: .regular, design: .default))
                    .foregroundColor(Color.gray)
                    .padding()
                #else
                List(wordlists) { wordlist in
                    NavigationLink(destination: TranslationListView(wordlist: wordlist)) {
                        Text("\(wordlist.title)")
                    }
                }
                .navigationTitle(Text("WordLists"))
                .toolbar {
                    Button {
                        
                    } label: {
                        Text("Edit me")
                    }
                }
                #endif
            }
            else
            {
                #if os(macOS)
                Text("No Wordlists Loaded")
                    .font(.system(size: 16 * size, weight: .regular, design: .default))
                    .foregroundColor(Color.gray)
                Text("No Wordlist Selected")
                    .font(.system(size: 16 * size, weight: .regular, design: .default))
                    .foregroundColor(Color.gray)
                #else
                Text("No Wordlists Loaded")
                    .font(.system(size: 16 * size, weight: .regular, design: .default))
                    .foregroundColor(Color.gray)
                #endif
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
