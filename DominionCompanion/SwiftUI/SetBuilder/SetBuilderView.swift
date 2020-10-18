//
//  SetBuilderView.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/30/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct SetBuilderView: View {
    @EnvironmentObject var setBuilder: SetBuilderModel
    
    @AppStorage(Constants.SaveKeys.settingsSortMode) var sortMode: SortMode = .cost
    
    @AppStorage(Constants.SaveKeys.settingsShowExpansionsWhenBuilding) var showExpansion: Bool = false

    @State var setup = false
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button("Shuffle") {
                        setBuilder.shuffle()
                    }.frame(maxWidth: .infinity)
                    NavigationLink(destination: ExpansionSelection()) {
                        Image(systemName: "cube.box")
                        Text("Expansions")
                    }.frame(maxWidth: .infinity)
                    NavigationLink(destination: RulesView()) {
                        Image(systemName: "list.dash")
                        Text("Rules (\(setBuilder.rules.count))")
                    }.frame(maxWidth: .infinity)
                }
                .padding(.top, 10)
                List {
                    Section(header: Text("Landscape Cards")) {
                        ForEach(setBuilder.landscape, id: \.name) { card in
                            NavigationCardRow(card: card, showExpansion: self.showExpansion)
                        }
                    }
                    Section(header: Text("Cards")) {
                        ForEach(setBuilder.cards.sorted(by: sortMode.sortFunction()), id: \.name) { card in
                            NavigationCardRow(card: card, showExpansion: self.showExpansion)
                        }
                    }
                }.listStyle(GroupedListStyle())
            }
            .navigationTitle("Set Builder")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: HStack {
                        Button(action: {
                            self.setup.toggle()
                        }, label: {
                            Image(systemName: "play.fill")
                        })
                    })
                    .background(
                        NavigationLink(
                            destination: GameplaySetup(model: setBuilder.finalSet),
                            isActive: $setup,
                            label: {
                                EmptyView()
                            })
                    )
        }
    }
}

struct SetBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        SetBuilderView().environmentObject(SetBuilderModel(CardData()))
    }
}
