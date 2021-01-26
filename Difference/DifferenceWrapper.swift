import Foundation

public class DifferenceWrapper<CollectionType> where CollectionType: Hashable, CollectionType: RandomAccessCollection, CollectionType.Element: Hashable {
    private var differenceChange: DifferenceChange<CollectionType>?
    public init() {}
    
    private var block: ((DifferenceChange<CollectionType>) -> Void)?
    public func notifity(block: ((DifferenceChange<CollectionType>) -> Void)?) {
        self.block = block
    }
    
    @discardableResult
    public func diff(other: CollectionType) -> DifferenceChange<CollectionType> {
        if let differenceChange = differenceChange {
            switch differenceChange {
            case .initial(let array), .update(let array, deletions: _, insertions: _, moves: _):
                let newArray = other
                let oldArray = array
                let changes = newArray.difference(from: oldArray)
                
                // https://www.swiftjectivec.com/collectiondifference/
                let insertions = changes
                    .inferringMoves()
                    .compactMap { change -> Int? in
                        guard case let .insert(offset, _, move) = change,
                              move == nil
                        else { return nil }
                        return offset
                    }
                
                let deletions = changes
                    .inferringMoves()
                    .compactMap { change -> Int? in
                        guard case let .remove(offset, _, move) = change,
                              move == nil
                        else { return nil }
                        return offset
                    }
                
                let moves = changes
                    .inferringMoves()
                    .compactMap { change -> (Int, Int)? in
                        guard case let .remove(offset, _, move) = change else {
                            return nil
                        }
                        if let move = move {
                            return (offset, move)
                        } else {
                            return nil
                        }
                    }
                
                let result: DifferenceChange<CollectionType> = .update(other,
                                                                       deletions: deletions,
                                                                       insertions: insertions,
                                                                       moves: moves)
                self.differenceChange = result
                block?(result)
                return result
            }
        } else {
            let result: DifferenceChange<CollectionType> = .initial(other)
            self.differenceChange = result
            block?(result)
            return result
        }
    }
}

public enum DifferenceChange<CollectionType> {
    case initial(CollectionType)
    case update(CollectionType, deletions: [Int], insertions: [Int], moves: [(from: Int, to: Int)])
}
