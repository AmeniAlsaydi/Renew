//
//  RenewTests.swift
//  RenewTests
//
//  Created by Amy Alsaydi on 5/11/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import XCTest

@testable import Renew

class RenewTests: XCTestCase {

    // test for getting categories
    
    func testGettingCategories() {
        let expectedCount = 6
        let exp = XCTestExpectation(description: "categories found")
        
        DatabaseService.shared.getCategories { (results) in
            switch results {
            case(.failure(let error)):
                print("error getting categories: \(error.localizedDescription)")
            case(.success(let cetegories)):
                XCTAssertEqual(expectedCount, cetegories.count)
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 5.0)
    }
    
    func testGettingLocations() {
        let expectedCount = 2
        let exp = XCTestExpectation(description: "locations found")
        let zipCode = 11201
        let item = "Cell Phones"
        
        DatabaseService.shared.getLocationsThatAcceptItem(zipcode: zipCode, itemName: item) { (result) in
            switch result {
            case(.failure(let error)):
                XCTFail("failure getting locations with zipcode: \(error.localizedDescription)")
            case(.success(let locations)):
                XCTAssertEqual(locations.count, expectedCount)
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 9.0)
    }
    
    func testGettingAcceptedItems() {
        let expectedCount = 3
        let exp = XCTestExpectation(description: "items found")
        let id = "ZdRXl18ph7G6DCvm3L9T"
        
        DatabaseService.shared.getAcceptedItems(for: id) { (result) in
            switch result {
            case(.failure(let error)):
                XCTFail("failure getting locations with zipcode: \(error.localizedDescription)")
            case(.success(let items)):
                XCTAssertEqual(items.count, expectedCount)
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 9.0)
    }
}
