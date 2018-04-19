//
//  ConsentString.swift
//  gdprConsentStringSwift
//
//  Created by Daniel Kanaan on 4/17/18.
//  Copyright © 2018 Daniel Kanaan. All rights reserved.
//

import Foundation

class ConsentString:ConsentStringProtocol {
    
    public var consentString: String {
        
        //error correction in didSet resets old value if base64decoding fails
        didSet {
            guard let dataValue = Data(base64Encoded: consentString) else {
                print("New Consent String Value is not base64 decodable. Throwing away changes.")
                consentString = oldValue
                return
            }
            consentString = consentString.base64Padded
            consentData = dataValue
        }
        
    }
    
    var consentData:Data
    
    /**
     Creates new instance of a ConsentString object
     
     - parameter consentString: web-safe base64 encoded consent string
    */
    public required init(consentString: String) throws {
        self.consentString = consentString.base64Padded
        guard let dataValue = Data(base64Encoded: self.consentString) else {
            throw ConsentStringError.base64DecodingFailed
        }
        consentData = dataValue
    }
    
    
    var cmpId: Int {
        return 0
    }
    
    var consentScreen: Int {
        return 0
    }
    
    var consentLanguage: String {
        return "EN"
    }
    
    var purposesAllowed: [Int8] {
        return []
    }
    
    func purposeAllowed(forPurposeId purposeId: Int8) -> Bool {
        return false
    }
    
    func isVendorAllowed(vendorId: Int) -> Bool {
        return false
    }
    
}
