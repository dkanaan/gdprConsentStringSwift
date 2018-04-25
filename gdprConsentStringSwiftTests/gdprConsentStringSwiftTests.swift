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
    
   
    
    func testPerformance() {
        self.measure {
            // Put the code you want to measure the time of here.
            let data = Data(unpaddedBase64String: "BOMYO7eOMYO7eAABAENAAAAAAAAoAAA")!
            XCTAssert(data.intValue(fromBit: 6, toBit: 41) == 15240064734)
        }
    }
    func testPerformance2() {
        let base64CharacterString = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
        self.measure {
            for i in 0..<50 {
                var string = ""
                for _ in 0...i {
                    string.append(base64CharacterString[base64CharacterString.index(base64CharacterString.startIndex, offsetBy: Int(arc4random_uniform(64)))])
                }
                let data = Data(unpaddedBase64String: string)
                XCTAssert(data != nil)
            }
        }
    }
    func testPadding() {
        var string = "BOMXuBxOMXuBxAABAENAAAAAAAAoAAA"
        XCTAssert(string.base64PaddedWithA == "BOMXuBxOMXuBxAABAENAAAAAAAAoAAAA", string.base64PaddedWithA)
        string = "BOMXuBxOMXuBxAABAENAAAAAAAAoAAB"
        XCTAssert(string.base64PaddedWithA == "BOMXuBxOMXuBxAABAENAAAAAAAAoAABA", string.base64PaddedWithA)
        string = "BOMXuBxOMXuBxAABAENAAAAAAAAoA"
        XCTAssert(string.base64PaddedWithA == "BOMXuBxOMXuBxAABAENAAAAAAAAoAAAA", string.base64PaddedWithA)
        string = "BOMXuBxOMXuBxAABAENAAAAAAAAo"
        XCTAssert(string.base64PaddedWithA == "BOMXuBxOMXuBxAABAENAAAAAAAAo", string.base64PaddedWithA)
        string = "BOMXuBxOMXuBxAABAENAAAAAAAAoAABoo"
        XCTAssert(string.base64PaddedWithA == "BOMXuBxOMXuBxAABAENAAAAAAAAoAABooAAA", string.base64PaddedWithA)
    }
    
    func testBase64Encoding() {
        let notEqual:[(String,String)] =
            [("BOMXuBxOMXuBxAABAENAAAAAAAAoAAA",
              "BOMXuBxOMXuBxAABAENAAAAAAAAoAAB"),
             ("BOMXuBxOMXuBxAABAENAAAAAAAAoA",
              "BOMXuBxOMXuBxAABAENAAAAAAAAoAA"),
             ("BOMXuBxOMXuBxAABAENAAAAAAAAo",
              "BOMXuBxOMXuBxAABAENAAAAAAAAoA"),
             ("AA==",
              "A="),
             ("AB=",
              "ABA"),
             ("AABAA",
              "AABA"),
             ("===",
              "A")
             ]
        
        for pair in notEqual {
            let data1 = Data(unpaddedBase64String: pair.0)
            let data2 = Data(unpaddedBase64String: pair.1)
            XCTAssert(data1 != data2,"\(pair.0) == \(pair.1)")
        }
        
        let equal:[(String,String)] = [
            ("BOMXuBxOMXuBxAABAENAAAAAAAAoAAA",
             "BOMXuBxOMXuBxAABAENAAAAAAAAoAAAA"),
            ("BOMXuBxOMXuBxAABAENAAAAAAAAoA=",
             "BOMXuBxOMXuBxAABAENAAAAAAAAoA"),
            ("BOMXuBxOMXuBxAABAENAAAAAAAAoA==",
             "BOMXuBxOMXuBxAABAENAAAAAAAAoA"),
            ("BOMXuBxOMXuBxAABAENAAAAAAAAoA===",
             "BOMXuBxOMXuBxAABAENAAAAAAAAoA"),
            ("===AAA===",
             "AAA"),
            ("AAA",
             "AAAA"),
            ("=",
             ""),
            ("==",
             ""),
            ("===",
             ""),
            ("======",
             "")
            ]
        for pair in equal {
            let data1 = Data(unpaddedBase64String: pair.0)
            let data2 = Data(unpaddedBase64String: pair.1)
            XCTAssert(data1 == data2, "\(pair.0) != \(pair.1)")
        }
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
    
    func testDataExtensions () {
        var data = Data(unpaddedBase64String: "BOMYO7eOMYO7eAABAENAAAAAAAAoAAA")!
        var byteLength = 24
        var lastBit = Int64(byteLength * 8 - 1)
        XCTAssert(data.byte(forBit: 0) == 0)
        XCTAssert(data.byte(forBit: 1) == 0)
        XCTAssert(data.byte(forBit: 6) == 0)
        XCTAssert(data.byte(forBit: 8) == 1)
        XCTAssert(data.byte(forBit: 10) == 1)
        XCTAssert(data.byte(forBit: 15) == 1)
        XCTAssert(data.byte(forBit: 16) == 2)
        XCTAssert(data.byte(forBit: lastBit) == byteLength - 1)
        XCTAssert(data.byte(forBit: lastBit + 1) == nil)
        XCTAssert(data.byte(forBit: lastBit - 8) == byteLength - 2)
        
        XCTAssert(data.intValue(fromBit: 0, toBit: 5) == 1)
        XCTAssert(data.intValue(fromBit: 0, toBit: 7) == 4)
        XCTAssert(data.intValue(fromBit: 6, toBit: 41) == 15240064734)
        XCTAssert(data.intValue(fromBit: 42, toBit: 77) == 15240064734)
        XCTAssert(data.intValue(fromBit: 78, toBit: 89) == 0)
        XCTAssert(data.intValue(fromBit: 90, toBit: 95) == 1)
        XCTAssert(data.intValue(fromBit: 96, toBit: 101) == 0)
        XCTAssert(data.intValue(fromBit: 102, toBit: 113) == 269)
        XCTAssert(data.intValue(fromBit: 114, toBit: 125) == 0)
        XCTAssert(data.intValue(fromBit: 13*8+1, toBit: 13*8+1) == 1)
        
        data = Data(unpaddedBase64String: "AAAB")!
        byteLength = 3
        lastBit = Int64(byteLength * 8 - 1)
        for i in 0..<(byteLength*3-1) {
            XCTAssert(data.intValue(fromBit: Int64(i), toBit: Int64(i)) == 0)
        }
        XCTAssert(data.intValue(fromBit: Int64(byteLength*8-1), toBit: Int64(byteLength*8-1)) == 1)
        XCTAssert(data.intValue(fromBit: 0, toBit: 23) == 1)
        XCTAssert(data.intValue(fromBit: 100000, toBit: 1000000) == 0)
        
        data = Data(unpaddedBase64String: "AAEA")!
        byteLength = 3
        lastBit = Int64(byteLength * 8 - 1)
        XCTAssert(data.intValue(fromBit: 15, toBit: 15) == 1)
        XCTAssert(data.intValue(fromBit: 0, toBit: 15) == 1)
        XCTAssert(data.intValue(fromBit: 16, toBit: 23) == 0)
        
        data = Data(unpaddedBase64String: "AQAA")!
        byteLength = 3
        lastBit = Int64(byteLength * 8 - 1)
        XCTAssert(data.intValue(fromBit: 15, toBit: 15) == 0)
        XCTAssert(data.intValue(fromBit: 16, toBit: 23) == 0)
        XCTAssert(data.intValue(fromBit: 0, toBit: 7) == 1)
        XCTAssert(data.intValue(fromBit: 0, toBit: 8) == 2)
        XCTAssert(data.intValue(fromBit: 0, toBit: 9) == 4)
        XCTAssert(data.intValue(fromBit: 0, toBit: 10) == 8)
        XCTAssert(data.intValue(fromBit: 0, toBit: 11) == 16)
        XCTAssert(data.intValue(fromBit: 0, toBit: 12) == 32)
        
        //Bad Data
        data = Data(unpaddedBase64String: "AAAAAAAB")!
        byteLength = 6
        lastBit = Int64(byteLength * 8 - 1)
        
        XCTAssert(data.intValue(fromBit: 0, toBit: lastBit) == 1)
        XCTAssert(data.intValue(fromBit: 0, toBit: 63) == 1)
        
        
        data = Data(unpaddedBase64String: "AAAAAAABAAAA")!
        byteLength = data.count
        lastBit = Int64(byteLength * 8 - 1)
        
        XCTAssert(data.intValue(fromBit: 0, toBit: lastBit) == 65536, "\(data.intValue(fromBit: 0, toBit: lastBit))")
        XCTAssert(data.intValue(fromBit: 0, toBit: 63) == 65536)
        XCTAssert(data.intValue(fromBit: 0, toBit: 100) == 65536)
        
        
        data = Data(unpaddedBase64String: "BOMexSfOMexSfAAABAENAAAAAAAAoAA")!
        byteLength = data.count
        lastBit = Int64(byteLength * 8 - 1)
        XCTAssert(data.intValue(fromBit: 0, toBit: 5) == 1)
        XCTAssert(data.intValue(fromBit: 6, toBit: 41) == 15241778335)
        XCTAssert(data.intValue(fromBit: 42, toBit: 77) == 15241778335)
        XCTAssert(data.intValue(fromBit: 78, toBit: 89) == 0)
        XCTAssert(data.intValue(fromBit: 90, toBit: 101) == 1)
        XCTAssert(data.intValue(fromBit: 102, toBit: 107) == 0)
        XCTAssert(data.intValue(fromBit: 108, toBit: 119) == 269)
        XCTAssert(data.intValue(fromBit: 120, toBit: 131) == 0)
        XCTAssert(data.intValue(fromBit: 132, toBit: 155) == 0)
        XCTAssert(data.intValue(fromBit: 156, toBit: 171) == 10)
        XCTAssert(data.intValue(fromBit: 172, toBit: 172) == 0)
        XCTAssert(data.intValue(fromBit: 173, toBit: lastBit) == 0)
    }
    
    func testConsentStringLanguage () {
        let consentString = try!ConsentString(consentString: "BOMexSfOMexSfAAABAENAAAAAAAAoAA")
        XCTAssert(consentString.consentLanguage == "EN", consentString.consentLanguage)
    }
    
    func testPurposesAllowed () {
        let consentStringArray = ["BOMexSfOMexSfAAABAENAA////AAoAA",
                                  "BOMexSfOMexSfAAABAENAAf///AAoAA",
                                  "BOMexSfOMexSfAAABAENAAP///AAoAA",
                                  "BOMexSfOMexSfAAABAENAAH///AAoAA",
                                  "BOMexSfOMexSfAAABAENAAD///AAoAA",
                                  "BOMexSfOMexSfAAABAENAAB///AAoAA",
                                  "BOMexSfOMexSfAAABAENAAA///AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAf//AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAP//AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAH//AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAD//AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAB//AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAA//AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAf/AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAP/AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAH/AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAD/AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAB/AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAA/AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAAfAAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAAPAAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAAHAAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAADAAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAABAAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAAAAAoAA"]
        var consentString:ConsentString
        var purposesAllowed:[Int8]
        for (index,string) in consentStringArray.enumerated() {
            consentString = try!ConsentString(consentString: string)
            purposesAllowed = consentString.purposesAllowed
            if index < 24 {
                for i in index+1...24 {
                    XCTAssert(purposesAllowed.contains(Int8(i)))
                }
            }
            for i in 0..<index {
                XCTAssert(!purposesAllowed.contains(Int8(i+1)))
            }
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
