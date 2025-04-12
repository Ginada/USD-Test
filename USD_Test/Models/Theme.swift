//
//  Theme.swift
//  Makeover-panel
//
//  Created by Gina Adamova on 2024-08-04.
//

import Foundation


public enum Theme: String, Codable, Identifiable, CaseIterable {
    
    public var id: Self { self }
    
    case glamour
    case formal
    case scifi
    case alternative
    case fashion
    case retro
    case festival
    case everyday
    case floraFauna
    case cosmicElements
    case fantasy
    case horror
    case elegance
}

public enum ThemeTag: String, Codable, Identifiable, CaseIterable {
    
    public var id: Self { self }
    
    case date
    case forests
    case office
    case romance
    case party
    case cheerleader
    case wedding
    case vampire
    case spider
    case witch
    case runway
    case fairy
    case unicorn
    case mermaid
    case alien
    case superhero
    case villain
    case princess
    case clouds
    case cosmic
    case tropical
    case romantic
    case gothic
    case winter
    case scary
    case artistic
    case holistic
    case snow
    case planets
    case stars
    case flower
    case butterfly
    case comic
}

//halloween witch challenge
//spider
//poison
//witch
//cat
//pointy hat
//frog
//web
