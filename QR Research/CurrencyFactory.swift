//
//  CurrencyFactory.swift
//  QR Research
//
//  Created by DUCH Chamroeurn on 1/10/23.
//

import UIKit

public enum CurrencyFactory {
    static func from(iso: Int16) -> CurrencyType.Type {
        if iso == KHR.isoCode {
            return KHR.self
        }

        return USD.self
    }

    static func from(assetId: String) -> CurrencyType.Type {
        if assetId == KHR.assetId {
            return KHR.self
        }

        return USD.self
    }
}


public enum KHR: CurrencyType {
    public static var assetId: String {
        "khr#nbc"
    }

    static var isoCode: Int16 {
        116
    }

    public static var sign: String {
        "៛"
    }

    public static var precision: Int16 {
        0
    }


    public static var name: String {
        "Riel"
    }

    static var appearance: CurrencyAppearance {
        .khr
    }
}

public enum USD: CurrencyType {
    
    public static var assetId: String {
        "usd#nbc"
    }

    static var isoCode: Int16 {
        840
    }

    public static var sign: String {
        "$"
    }

    public static var precision: Int16 {
        2
    }


    public static var name: String {
        "Dollar"
    }

    static var appearance: CurrencyAppearance {
        .usd
    }
}


enum CurrencyAppearance: String {
    case usd
    case khr

    func bubblesImage() -> UIImage? {
        return UIImage(named: "\(rawValue)Account")
    }
}
