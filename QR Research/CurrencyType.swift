//
//  CurrencyType.swift
//  QR Research
//
//  Created by DUCH Chamroeurn on 1/10/23.
//

import Foundation

protocol CurrencyType {
    static var assetId: String { get }
    static var isoCode: Int16 { get }
    static var sign: String { get }
    static var precision: Int16 { get }
    static var name: String { get }
    static var appearance: CurrencyAppearance { get }
}
