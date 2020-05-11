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
        
        wait(for:[exp], timeout: 9.0)
    }

}
