//
//  Settings.swift
//  ScoutManager
//
//  Created by Eugenio Tampieri on 23/11/23.
//

import Foundation

public final class Settings {
    let unitName: String
    let unitType: Branch
    let dataFile: URL
    let unitDuration: Int
    private init(unitName: String, unitType: Branch, dataFile: URL, unitDuration: Int) {
        self.unitName = unitName
        self.unitType = unitType
        self.dataFile = dataFile
        self.unitDuration = unitDuration
    }
}
