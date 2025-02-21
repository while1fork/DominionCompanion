//
//  Constants.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/26/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation

struct Constants {
    static let nonKingdomTypes = ["Artifact", "Boon", "Curse", "Event", "Heirloom", "Hex", "Landmark", "Prize", "Project", "Ruins", "Shelter", "State"]
    static let notGameplayRelatedTypes = ["Boon", "Hex", "Ruins"]
    struct SaveKeys {
        static let maxKingdomCards = "maxKingdomCards"
        static let maxExpansions = "maxExpansions"
        static let chosenExpansions = "expansions"
        
        static let pinnedRules = "pinnedRules"
        static let savedRules = "savedRules"

        static let currentCards = "currentCards"
        static let currentLandscape = "currentLandscape"
        static let pinnedCards = "pinnedCards"
        static let pinnedLandscape = "pinnedLandscape"

        static let settingsMaxLandscape = "settings_maxLandscape"
        static let settingsNumEvents = "settings_numberOfEvents"
        static let settingsNumProjects = "settings_numberOfProjects"
        static let settingsNumLandmarks = "settings_numberOfLandmarks"
        static let settingsNumWays = "settings_numberOfWays"
        static let settingsColonies = "settings_colonies"
        static let settingsShelters = "settings_shelters"
        static let settingsAnyLandscape = "settings_anyLandscape"
        static let settingsShowExpansionsWhenBuilding = "settings_showExpansionsWhenBuilding"
        static let settingsSortMode = "settings_sortMode"
        static let settingsGameplaySortMode = "settings_gameplaySortMode"
        static let settingsPinCards = "settings_pincards"
        static let settingsHideWikiLink = "settings_hideWikiLink"
        
        static let savedExcludedCards = "excludedCards"

        static let blackMarketDeckSize = "blackMarketDeckSize"
        static let blackMarketShuffle = "blackMarketShuffle"
    }
}
