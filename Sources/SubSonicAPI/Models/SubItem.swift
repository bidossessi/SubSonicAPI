//
//  SubItem.swift
//  SubSonicAPI
//
//  Created by Stanislas Sodonon on 10/5/17.
//

import Foundation

protocol SubItem: class {}

extension SubItem {
    static func makeInt(_ unknown: Any?) -> Int? {
        if let fromNS = unknown as? NSNumber {
          return fromNS.intValue
        } else if let fromStr = unknown as? String {
            return Int(fromStr)
        }
        return nil
    }
}
