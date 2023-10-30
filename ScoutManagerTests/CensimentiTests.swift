//
//  CensimentiTests.swift
//  ScoutManager
//
//  Created by Eugenio Tampieri on 30/10/23.
//

import XCTest

final class CensimentiTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSexMale() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let decoder = JSONDecoder()
        let decoded: Sex? = try? decoder.decode(Sex.self, from: "\"Male\"".data(using: .utf8)!)
        XCTAssert(decoded != nil)
        XCTAssert(decoded! == .Male)
    }
    func testSexFemale() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let decoder = JSONDecoder()
        let decoded: Sex? = try? decoder.decode(Sex.self, from: "\"Female\"".data(using: .utf8)!)
        XCTAssert(decoded != nil)
        XCTAssert(decoded! == .Female)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
