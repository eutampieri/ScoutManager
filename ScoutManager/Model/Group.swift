//
//  Group.swift
//  ScoutManager
//
//  Created by Eugenio Tampieri on 23/11/23.
//

import Foundation

class Group {
    let name: String
    let members: [UUID]
    let style: GroupStyle
    
    init(name: String, members: [UUID], style: GroupStyle) {
        self.name = name
        self.members = members
        self.style = style
    }
}

protocol GroupStyle {
    
}
