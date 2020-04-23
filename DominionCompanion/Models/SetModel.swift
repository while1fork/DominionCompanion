//
//  SetModel.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/26/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

struct SetModel {
    // MARK: Specific Set Wide Effects
    var landmarks: [Card]
    var events: [Card]
    var projects: [Card]
    
    // MARK: Cards for this set
    var cards: [Card]
    var notInSupply: [Card] {
        get {
            return self.cards.map({$0.relatedCards}).reduce([]) { (relatedCards, nextRelated) -> [Card] in
                let next = nextRelated.filter({Set($0.types).intersection(Set(Constants.notGameplayRelatedTypes)).count == 0})
                let cardSet = Set(relatedCards + next)
                return Array(cardSet)
            }.filter { Set(["Knight", "Castle"]).intersection(Set($0.types)).count == 0 } // Knights and Castles are special and technically in the supply
        }
    }
    
    // MARK: General Required Extras
    var colonies: Bool {
        guard !Settings.shared.colonies else { return true }
        let chance = cards.filter({$0.expansion == "Prosperity"}).count
        return chance > Int.random(in: 0...10)
    }
    var shelters: Bool {
        let chance = cards.filter({$0.expansion == "Dark Ages"}).count
        guard chance > 0 else { return false }
        guard !Settings.shared.shelters else { return true }
        return chance > Int.random(in: 0...10)
    }
    var boons: Bool { self.cards.filter({$0.types.contains("Fate")}).count > 0 }
    var hexes: Bool { self.cards.filter({$0.types.contains("Doom")}).count > 0 }
    var ruins: Bool { self.cards.filter({$0.types.contains("Looter")}).count > 0 }
    var potions: Bool { self.cards.filter({$0.potion}).count > 0 }
    var debt: Bool { self.cards.filter({$0.tokens.debt}).count > 0 }
    var victoryTokens: Bool { self.cards.filter({$0.tokens.victory > 0}).count > 0 }
    var coinTokens: Bool { self.cards.filter({$0.tokens.coin > 0}).count > 0 || self.projects.filter({$0.tokens.coin != 0}).count > 0 }
    var embargoTokens: Bool { self.cards.filter({$0.tokens.embargo}).count > 0 }
    var journeyToken: Bool { self.cards.filter({$0.tokens.journey}).count > 0 }
    var minusCardTokens: Bool { self.cards.filter({$0.tokens.minusCard}).count > 0 }
    var minusCoinTokens: Bool { self.cards.filter({$0.tokens.embargo}).count > 0 }
    var plusCardTokens: Bool { self.cards.filter({$0.tokens.plusCard}).count > 0 }
    var plusActionTokens: Bool { self.cards.filter({$0.tokens.plusAction}).count > 0 }
    var plusBuyTokens: Bool { self.cards.filter({$0.tokens.plusBuy}).count > 0 }
    var plusCoinTokens: Bool { self.cards.filter({$0.tokens.plusCoin}).count > 0 }
    var minusCostTokens: Bool { self.cards.filter({$0.tokens.minusCost}).count > 0 }
    var trashingTokens: Bool { self.cards.filter({$0.tokens.trashing}).count > 0 }
    var estateTokens: Bool { self.cards.filter({$0.tokens.estate}).count > 0 }
    var projectTokens: Bool { projects.count > 0 }
    
    // MARK: ViewModel
    func getSections(tableView: UITableView) -> [GameplaySection] {
        
        let sortFn = Settings.shared.gameplaySortMode.sortFunction()
        let getAttributedCardCell = { (card: Card) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "attributedCardCell") as? AttributedCardCell else {
                return UITableViewCell()
            }
            cell.setData(card, favorite: false, showExpansion: true)
            cell.selectionStyle = .none
            return cell
        }
        
        let getBasicCell = { (text: String) -> UITableViewCell in
            let cell = UITableViewCell()
            cell.textLabel?.text = text
            cell.selectionStyle = .none
            return cell
        }
        
        var sections = [
            GameplaySection(title: "In Supply", rows: self.cards.sorted(by: sortFn).map(getAttributedCardCell))
        ]
        
        if notInSupply.count > 0 {
            sections.append(GameplaySection(title: "Not In Supply", rows: self.notInSupply.sorted(by: sortFn).map(getAttributedCardCell)))
        }
        
        if landmarks.count > 0 {
            sections.append(GameplaySection(title: "Landmarks", rows: self.landmarks.map(getAttributedCardCell)))
        }

        if events.count > 0 {
            sections.append(GameplaySection(title: "Events", rows: self.events.map(getAttributedCardCell)))
        }
        
        if projects.count > 0 {
            sections.append(GameplaySection(title: "Projects", rows: self.projects.map(getAttributedCardCell)))
        }
        
        let tokens = getTokens()
        if tokens.count > 0 {
            sections.append(GameplaySection(title: "Tokens", rows: tokens.map(getBasicCell)))
        }
        
        let additionalMechanics = getAdditionalMechanics()
        if additionalMechanics.count > 0 {
            sections.append(GameplaySection(title: "Additional Mechanics", rows: additionalMechanics.map(getBasicCell)))
        }
        
        var victories: [UITableViewCell] = []
        if shelters {
            victories.append(getBasicCell("Shelters"))
        }
        if colonies {
            let colonyPlatinum = CardData.shared.allCards.filter({ ["Colony", "Platinum"].contains($0.name)})
            victories.append(contentsOf: colonyPlatinum.map(getAttributedCardCell))
        }
        
        if victories.count > 0 {
            sections.append(GameplaySection(title: "Victory and Treasure", rows: victories))
        }
        
        return sections
    }
    
    // MARK: Helpers
    func getTokens() -> [String] {
        var tokens: [String] = []
        
        if debt { tokens.append("Debt Tokens") }
        if victoryTokens { tokens.append("Victory Tokens") }
        if coinTokens { tokens.append("Coin Tokens") }
        if embargoTokens { tokens.append("Embargo Tokens") }
        if journeyToken { tokens.append("Journey Token") }
        if minusCardTokens { tokens.append("-Card Token") }
        if minusCoinTokens { tokens.append("-Coin Token") }
        if plusCardTokens { tokens.append("+Card Token") }
        if plusActionTokens { tokens.append("+Action Token") }
        if plusBuyTokens { tokens.append("+Buy Token") }
        if plusCoinTokens { tokens.append("+Coin Token") }
        if minusCostTokens { tokens.append("-Cost Token") }
        if trashingTokens { tokens.append("Trashing Token") }
        if estateTokens { tokens.append("Estate Token") }
        if projectTokens { tokens.append("Wooden Project Cubes") }
        return tokens
    }
    
    func getAdditionalMechanics() -> [String] {
        var mechanics: [String] = []
        
        if boons {
            mechanics.append("Boons")
        }
        
        if hexes {
            mechanics.append("Hexes")
        }
        
        if ruins {
            mechanics.append("Ruins")
        }
        
        if potions {
            mechanics.append("Potion")
        }
        
        return mechanics
    }
    
    func getShareable() -> ShareableSet {
        return ShareableSet(
            cards: self.cards.map({$0.name}),
            events: self.events.map({$0.name}),
            landmarks: self.landmarks.map({$0.name}),
            projects: self.projects.map({$0.name})
        )
    }
}

// MARK: Sharing
struct ShareableSet: Codable {
    let cards: [String]
    let events: [String]
    let landmarks: [String]
    let projects: [String]
}

extension ShareableSet {
    func getSetModel() -> SetModel {
        let cards = self.cards.compactMap { (name) -> Card? in
            return CardData.shared.kingdomCards.first(where: {$0.name == name})
        }
        
        let events = self.events.compactMap { (name) -> Card? in
            return CardData.shared.allCards.first(where: {$0.name == name})
        }
        
        let landmarks = self.landmarks.compactMap { (name) -> Card? in
            return CardData.shared.allCards.first(where: {$0.name == name})
        }
        
        let projects = self.projects.compactMap { (name) -> Card? in
            return CardData.shared.allCards.first(where: {$0.name == name})
        }
        
        return SetModel(landmarks: landmarks, events: events, projects: projects, cards: cards)
    }
}

struct GameplaySection {
    let title: String
    let rows: [UITableViewCell]
}
