//
//  WindDirectionTests.swift
//  SwiftWeather
//
//  Created by Mykhailo Vorontsov on 12/04/2016.
//  Copyright © 2016 Mykhailo Vorontsov. All rights reserved.
//

import XCTest
@testable import SwiftWeather

private let accuracy = 0.1

class WindDirectionTests: XCTestCase {
    
    func testAngles() {
      XCTAssertEqualWithAccuracy(WindDirection.n.angleRawValue!, 0.0, accuracy: accuracy)
      XCTAssertEqualWithAccuracy(WindDirection.s.angleRawValue!, M_PI / 2.0, accuracy: accuracy)
      XCTAssertEqualWithAccuracy(WindDirection.w.angleRawValue!, M_PI / 4.0, accuracy: accuracy)
      XCTAssertEqualWithAccuracy(WindDirection.e.angleRawValue!, 3.0 * M_PI / 4.0, accuracy: accuracy)
      
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
