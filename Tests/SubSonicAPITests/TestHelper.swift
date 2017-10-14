//
//  Helpers.swift
//  SubSonicAPITests
//
//  Created by Stanislas Sodonon on 10/5/17.
//

import Foundation
@testable import SubSonicAPI

class TestHelper {
    func getDataFromFile(fileName name: String, fileExt ext: String) -> Data {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: name, withExtension: ext)
        let data = try? Data(contentsOf: url!)
        return data!
    }

    func generateRandomNumber(min: Int = 1, max: Int) -> Int {
        let randomNum = Int(arc4random_uniform(UInt32(max) - UInt32(min)) + UInt32(min))
        return randomNum
    }
}
