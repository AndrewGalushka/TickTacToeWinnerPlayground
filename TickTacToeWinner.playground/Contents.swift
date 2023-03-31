import Foundation
import XCTest

enum GameResult: Equatable {
    case winner_O(path: [CGPoint])
    case winner_X(path: [CGPoint])
    case draw
    case pending
}

func checkForWinnerSimple(_ grid: [[Int]]) -> GameResult? {
    let gridSize = 3
    
    guard grid.count == gridSize else {
        return nil
    }
    for row in grid {
        if row.count != gridSize {
            return nil
        }
    }
    
    var isPossiableToWin = false
    
    for rowIndex in 0..<gridSize {
        var simularElement = 0
        var isFulfilled = true
        
        for elementIndex in 0..<gridSize {
            let currentElement = grid[rowIndex][elementIndex]
            if currentElement == 0 {
                isFulfilled = false
            }
            
            if simularElement == 0 {
                simularElement = currentElement
            } else if currentElement != 0 && simularElement != currentElement {
                simularElement = -1
            }
            
            if elementIndex == gridSize - 1 {
                if isFulfilled == false && simularElement != -1 {
                    isPossiableToWin = true
                } else if isFulfilled == true && simularElement != -1 {
                    if simularElement == 1 {
                        return .winner_O(path: (0..<gridSize).map { CGPoint(x: $0, y: rowIndex) })
                    } else if simularElement == 2 {
                        return .winner_X(path: (0..<gridSize).map { CGPoint(x: $0, y: rowIndex) })
                    } else {
                        print("Unxepected behaviour")
                    }
                }
            }
        }
    }
    
    var rowOffset = 0
    while rowOffset < gridSize {
        var columnOffset = 0
        var simularElement = 0
        var isFulfilled = true
        
        while columnOffset < gridSize {
            let currentElement = grid[columnOffset][rowOffset]
            
            if currentElement == 0 {
                isFulfilled = false
            }
            
            if simularElement == 0 {
                simularElement = currentElement
            } else if currentElement != 0 && simularElement != currentElement {
                simularElement = -1
            }
            
            if columnOffset == gridSize - 1 {
                if isFulfilled == false && simularElement != -1 {
                    isPossiableToWin = true
                } else if isFulfilled == true && simularElement != -1 {
                    if simularElement == 1 {
                        return .winner_O(path: (0..<gridSize).map { CGPoint(x: rowOffset, y: $0) })
                    } else if simularElement == 2 {
                        return .winner_X(path: (0..<gridSize).map { CGPoint(x: rowOffset, y: $0) })
                    } else {
                        print("Unxepected behaviour")
                    }
                }
            }
            
            columnOffset += 1
        }
        
        rowOffset += 1
    }
    
    var leftUpSimularElement = 0
    var isLeftUpFulfilled = true
    var leftDownSimularElement = 0
    var isLeftDownFulfilled = true
    
    var diagoanalRowOffset = 0
    var diagoanalColumnOffset = 0
    
    while diagoanalRowOffset < gridSize && diagoanalColumnOffset < gridSize {
        let downElement = grid[diagoanalRowOffset][diagoanalColumnOffset]
        let upElement = grid[gridSize - 1 - diagoanalRowOffset][diagoanalColumnOffset]
        
        if downElement == 0 {
            isLeftDownFulfilled = false
        }
        
        if upElement == 0 {
            isLeftUpFulfilled = false
        }
        
        if leftDownSimularElement == 0 {
            leftDownSimularElement = downElement
        } else if downElement != 0 && downElement != leftDownSimularElement {
            leftDownSimularElement = -1
        }
        
        if leftUpSimularElement == 0 {
            leftUpSimularElement = upElement
        } else if upElement != 0 && upElement != leftUpSimularElement {
            leftUpSimularElement = -1
        }
        
        if diagoanalRowOffset == gridSize - 1 && diagoanalColumnOffset == gridSize - 1 {
            if isLeftUpFulfilled == false && leftUpSimularElement != -1 {
                isPossiableToWin = true
            } else if isLeftUpFulfilled == true && leftUpSimularElement != -1 {
                if leftUpSimularElement == 1 {
                    return .winner_O(path: (0..<gridSize).map { CGPoint(x: $0, y: gridSize - 1 - $0) })
                } else if leftUpSimularElement == 2 {
                    return .winner_X(path: (0..<gridSize).map { CGPoint(x: $0, y: gridSize - 1 - $0) })
                } else {
                    print("Unxepected behaviour")
                }
            }
            
            if isLeftDownFulfilled == false && leftDownSimularElement != -1 {
                isPossiableToWin = true
            } else if isLeftDownFulfilled == true && leftDownSimularElement != -1 {
                if leftDownSimularElement == 1 {
                    return .winner_O(path: (0..<gridSize).map { CGPoint(x: $0, y: $0) })
                } else if leftDownSimularElement == 2 {
                    return .winner_X(path: (0..<gridSize).map { CGPoint(x: $0, y: $0) })
                } else {
                    print("Unxepected behaviour")
                }
            }
        }
        
        diagoanalRowOffset += 1
        diagoanalColumnOffset += 1
    }
    
    if isPossiableToWin == false {
        return .draw
    }
    
    return .pending
}

class TickTacToeWinnerTests: XCTestCase {
    func testDraw() {
        let grid = [
            [1, 2, 1],
            [2, 2, 1],
            [2, 1, 2]
        ]

        let result = checkForWinnerSimple(grid)
        XCTAssertEqual(result, .draw)
    }

    func testDraw2() {
        let grid = [
            [1, 2, 1],
            [1, 2, 1],
            [2, 1, 2]
        ]

        let result = checkForWinnerSimple(grid)
        XCTAssertEqual(result, .draw)
    }

    func testUpperDiagonalWinnerIsX() {
        let grid = [
            [0, 0, 2],
            [0, 2, 0],
            [2, 0, 1]
        ]

        let result = checkForWinnerSimple(grid)
        XCTAssertEqual(
            result,
            .winner_X(
                path: [
                    CGPoint(x: 0, y: 2),
                    CGPoint(x: 1, y: 1),
                    CGPoint(x: 2, y: 0)
                ]
            )
        )
    }

    func testDownDiagonalWinnerIsX() {
        let grid = [
            [2, 0, 1],
            [0, 2, 0],
            [0, 0, 2]
        ]

        let result = checkForWinnerSimple(grid)
        XCTAssertEqual(
            result,
            .winner_X(
                path: [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 1, y: 1),
                    CGPoint(x: 2, y: 2)
                ]
            )
        )
    }
    
    func testUpperDiagonalWinnerIsO() {
        let grid = [
            [0, 0, 1],
            [0, 1, 0],
            [1, 0, 1]
        ]
        
        let result = checkForWinnerSimple(grid)
        XCTAssertEqual(
            result,
            .winner_O(
                path: [
                    CGPoint(x: 0, y: 2),
                    CGPoint(x: 1, y: 1),
                    CGPoint(x: 2, y: 0)
                ]
            )
        )
    }
    
    func testDownDiagonalWinnerIsO() {
        let grid = [
            [1, 0, 1],
            [0, 1, 0],
            [0, 0, 1]
        ]
        
        let result = checkForWinnerSimple(grid)
        XCTAssertEqual(
            result,
            .winner_O(
                path: [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 1, y: 1),
                    CGPoint(x: 2, y: 2)
                ]
            )
        )
    }

    func testColumnWinnerIsO() {
        let grid = [
            [0, 0, 1],
            [0, 0, 1],
            [0, 0, 1]
        ]

        let result = checkForWinnerSimple(grid)
        XCTAssertEqual(
            result,
            .winner_O(
                path: [
                    CGPoint(x: 2, y: 0),
                    CGPoint(x: 2, y: 1),
                    CGPoint(x: 2, y: 2)
                ]
            )
        )
    }

    func testColumnWinnerIsX() {
        let grid = [
            [2, 0, 0],
            [2, 0, 0],
            [2, 0, 0]
        ]

        let result = checkForWinnerSimple(grid)
        XCTAssertEqual(
            result,
            .winner_X(
                path: [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 0, y: 1),
                    CGPoint(x: 0, y: 2)
                ]
            )
        )
    }

    func testRowWinnerIsX() {
        let grid = [
            [2, 2, 2],
            [0, 0, 0],
            [0, 0, 0]
        ]

        let result = checkForWinnerSimple(grid)
        XCTAssertEqual(
            result,
                .winner_X(
                    path: [
                        CGPoint(x: 0, y: 0),
                        CGPoint(x: 1, y: 0),
                        CGPoint(x: 2, y: 0)
                    ]
                )
        )
    }

    func testRowWinnerIsO() {
        let grid = [
            [0, 0, 0],
            [0, 0, 0],
            [1, 1, 1]
        ]

        let result = checkForWinnerSimple(grid)
        XCTAssertEqual(
            result,
            .winner_O(
                path: [
                    CGPoint(x: 0, y: 2),
                    CGPoint(x: 1, y: 2),
                    CGPoint(x: 2, y: 2)
                ]
            )
        )
    }

    func testColumnWinability() {
        let grid = [
            [2, 0, 1],
            [1, 1, 2],
            [2, 1, 1]
        ]

        let result = checkForWinnerSimple(grid)
        XCTAssertEqual(result, .pending)
    }

    func testRowWinability() {
        let grid = [
            [0, 1, 1],
            [1, 2, 2],
            [2, 2, 1]
        ]

        let result = checkForWinnerSimple(grid)
        XCTAssertEqual(result, .pending)
    }

    func testLeftUpDiagonalWinability() {
        let grid = [
            [0, 1, 0],
            [2, 2, 1],
            [1, 2, 2]
        ]

        let result = checkForWinnerSimple(grid)

        XCTAssertEqual(result, .pending)
    }

    func testLeftDownDiagonalWinability() {
        let grid = [
            [0, 1, 2],
            [2, 1, 1],
            [1, 2, 1]
        ]

        let result = checkForWinnerSimple(grid)

        XCTAssertEqual(result, .pending)
    }

    func test_invalidRowSizeReturnsNil() {
        let grid = [
            [0, 0, 0, 0],
            [0, 0, 0],
            [0, 0, 0]
        ]

        let result = checkForWinnerSimple(grid)

        XCTAssertNil(result)
    }

    func test_invalidColumnSizeReturnsNil() {
        let grid = [
            [0, 0, 0],
            [0, 0, 0],
            [0, 0, 0],
            []
        ]

        let result = checkForWinnerSimple(grid)

        XCTAssertNil(result)
    }

    func test_invalidGridReturnsNil() {
        let grid = [[Int]]()

        let result = checkForWinnerSimple(grid)

        XCTAssertNil(result)
    }
}

TickTacToeWinnerTests.defaultTestSuite.run()
