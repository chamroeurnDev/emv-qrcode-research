//
//  EMVQRConstants.swift
//  QR Research
//
//  Created by DUCH Chamroeurn on 1/10/23.
//

import Foundation

enum EMVQRConstants {
    static let payloadFormatIndicator = "01"
    static let pointOfInitiationMethodStatic = "11"
    static let pointOfInitiationMethodDynamic = "12"
    static let merchantCategoryDefaultCode = "5999"
    static let countryCode = "KH"
    static let merchantDefaultName = "undefined"
    static let merchantDefaultCity = "Phnom Penh"
    static let accountIDTag = "29"
    static let merchantIDTag = "30"
    static let accountInformation = "01" // CASA account
    static let acquireBank = "02"
    static let availableIDTags = Array(26...51).map { String($0) }
    static let merchantAccountAvailableTags = ["29", "30"]
    static let billNumberSymbolLimit = 25
    static let amountLengthLimit = 13
    static let fullNameLengthLimit = 25
}
