//
//  gdprConsentStringSwiftTests.swift
//  gdprConsentStringSwiftTests
//
//  Created by Daniel Kanaan on 4/17/18.
//  Copyright © 2018 Daniel Kanaan. All rights reserved.
//

import XCTest
@testable import gdprConsentStringSwift

class gdprConsentStringSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testPadding() {
        var string = "BOMXuBxOMXuBxAABAENAAAAAAAAoAAA"
        XCTAssert(string.base64Padded == "BOMXuBxOMXuBxAABAENAAAAAAAAoAAAA", string.base64Padded)
        string = "BOMXuBxOMXuBxAABAENAAAAAAAAoAAB"
        XCTAssert(string.base64Padded == "BOMXuBxOMXuBxAABAENAAAAAAAAoAABA", string.base64Padded)
        string = "BOMXuBxOMXuBxAABAENAAAAAAAAoA"
        XCTAssert(string.base64Padded == "BOMXuBxOMXuBxAABAENAAAAAAAAoAAAA", string.base64Padded)
        string = "BOMXuBxOMXuBxAABAENAAAAAAAAo"
        XCTAssert(string.base64Padded == "BOMXuBxOMXuBxAABAENAAAAAAAAo", string.base64Padded)
        string = "BOMXuBxOMXuBxAABAENAAAAAAAAoAABoo"
        XCTAssert(string.base64Padded == "BOMXuBxOMXuBxAABAENAAAAAAAAoAABooAAA", string.base64Padded)
    }
    
    func testBase64Encoding() {
        var string1 = "BOMXuBxOMXuBxAABAENAAAAAAAAoAAA"
        var string2 = "BOMXuBxOMXuBxAABAENAAAAAAAAoAAB"
        var data1 = Data(base64Encoded: string1.base64Padded)
        var data2 = Data(base64Encoded: string2.base64Padded)
        XCTAssert(data1 != data2)
        string1 = "BOMXuBxOMXuBxAABAENAAAAAAAAoA"
        string2 = "BOMXuBxOMXuBxAABAENAAAAAAAAoAA"
        data1 = Data(base64Encoded: string1.base64Padded)
        data2 = Data(base64Encoded: string2.base64Padded)
        XCTAssert(data1 == data2)
    }
    
    func testInit() {
        var consentString = try?ConsentString(consentString: "BOMXuBxOMXuBxAABAENAAAAAAAAoAAA")
        XCTAssert(consentString != nil)
        if consentString != nil {
            let representation = binaryStringRepresenting(data: consentString!.consentData)
            XCTAssert(binary(string: representation, isEqualToBinaryString: "000001001110001100010111101110000001110001001110001100010111101110000001110001000000000000000001000000000100001101000000000000000000000000000000000000000000000000101000000000000"), "Actual value : \(representation)")
        }
        
        consentString = try?ConsentString(consentString: "BOMXuBxOMXuBxAABAENAAAAAAAAoAAC")
        XCTAssert(consentString != nil)
        if consentString != nil {
            let representation = binaryStringRepresenting(data: consentString!.consentData)
            XCTAssert(!binary(string: representation, isEqualToBinaryString: "000001001110001100010111101110000001110001001110001100010111101110000001110001000000000000000001000000000100001101000000000000000000000000000000000000000000000000101000000000000"), "Actual value : \(representation)")
        }
    }
    
    func binaryStringRepresenting(data:Data) -> String {
        return  data.reduce("") { (acc, byte) -> String in
            let stringRep = String(byte, radix: 2)
            let pad = 8 - stringRep.count
            let padString = "".padding(toLength: pad, withPad: "0", startingAt: 0)
            return acc + padString + stringRep
        }
    }
    
    func binary(string:String, isEqualToBinaryString string2:String) -> Bool {
        var index = 0
        var max = string.count
        if string.count > string2.count {
            max = string2.count
        }
        while index < max {
            if string[string.index(string.startIndex, offsetBy: index)] != string2[string2.index(string2.startIndex, offsetBy: index)] {
                return false
            }
            index += 1
        }
        if string.count > string2.count {
            while index < string.count {
                if string[string.index(string.startIndex, offsetBy: index)] != "0" {
                    return false
                }
                index += 1
            }
        } else {
            while index < string2.count {
                if string2[string2.index(string2.startIndex, offsetBy: index)] != "0" {
                    return false
                }
                index += 1
            }
        }
        return true
    }
    
}
