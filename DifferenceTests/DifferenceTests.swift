import XCTest
@testable import Difference

final class DifferenceTests: XCTestCase {
    func testNotifity() {
        let differenceWrapper = DifferenceWrapper<[Int]>()
        let array = [1]
        let array2 = [1, 3, 5, 7]
        differenceWrapper.notifity { (result) in
            switch result {
            case .initial(let element):
                XCTAssertEqual(element, array)
            case .update(let element, deletions: _, insertions: _, moves: _):
                XCTAssertEqual(element.map({ $0 }), array2)
            }
        }
        differenceWrapper.diff(other: .init(array))
        differenceWrapper.diff(other: .init(array2))
    }
    
    func testNotificationToken() {
        let differenceWrapper = DifferenceWrapper<[Int]>()
        XCTAssertTrue(differenceWrapper.callBackDictionary.isEmpty)
        let token = differenceWrapper.notifity { (_) in
            
        }
        XCTAssertEqual(differenceWrapper.callBackDictionary.count, 1)
        
        differenceWrapper.remove(token: token)
        XCTAssertTrue(differenceWrapper.callBackDictionary.isEmpty)
    }
    
    func testInitial() {
        let differenceWrapper = DifferenceWrapper<[Int]>()
        let array = [1]
        differenceWrapper.notifity { (result) in
            switch result {
            case.initial(let element):
                XCTAssertEqual(element.map({ $0 }), array)
            default: break
            }
        }
        differenceWrapper.diff(other: .init(array))
    }
    
    func testMoves() {
        let differenceWrapper = DifferenceWrapper<[Int]>()
        differenceWrapper.notifity { (result) in
            switch result {
            case .update(_, deletions: let deletions, insertions: let insertions, moves: let moves):
                XCTAssertTrue(deletions.isEmpty)
                XCTAssertTrue(insertions.isEmpty)
                XCTAssertEqual(moves.count, 2)
            default: break
            }
        }
        let array = [1, 2, 3]
        differenceWrapper.diff(other: .init(array))
        let array2 = [3, 2, 1]
        differenceWrapper.diff(other: .init(array2))
    }
    
    func testDeletions() {
        let differenceWrapper = DifferenceWrapper<[Int]>()
        differenceWrapper.notifity { (result) in
            switch result {
            case .update(_, deletions: let deletions, insertions: let insertions, moves: let moves):
                XCTAssertTrue(!deletions.isEmpty)
                XCTAssertTrue(insertions.isEmpty)
                XCTAssertTrue(moves.isEmpty)
            default: break
            }
        }
        let array = [1,2,3]
        differenceWrapper.diff(other: .init(array))
        let array2 = [2,3]
        differenceWrapper.diff(other: .init(array2))
    }
    
    func testInsertions() {
        let differenceWrapper = DifferenceWrapper<[Int]>()
        differenceWrapper.notifity { (result) in
            switch result {
            case .update(_, deletions: let deletions, insertions: let insertions, moves: let moves):
                XCTAssertTrue(deletions.isEmpty)
                XCTAssertEqual(insertions.count, 2)
                XCTAssertTrue(moves.isEmpty)
            default: break
            }
        }
        let array = [1,2]
        differenceWrapper.diff(other: .init(array))
        let array2 = [1,2,5,6]
        differenceWrapper.diff(other: .init(array2))
    }
}
