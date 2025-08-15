import XCTest
import SwiftUI
@testable import LogseqTodo

final class LogseqTaskTests: XCTestCase {
    
    func testTaskInitialization() throws {
        let task = LogseqTask(
            id: "test-id",
            title: "Test task",
            status: .todo,
            createdAt: Date(),
            filePath: "/test/path.md",
            pageName: "Test Page",
            lineNumber: 1
        )
        
        XCTAssertEqual(task.title, "Test task")
        XCTAssertEqual(task.status, .todo)
        XCTAssertEqual(task.pageName, "Test Page")
        XCTAssertEqual(task.filePath, "/test/path.md")
        XCTAssertEqual(task.lineNumber, 1)
    }
    
    func testTaskEquality() throws {
        let task1 = LogseqTask(
            id: "same-id",
            title: "Test task",
            status: .todo,
            createdAt: Date(),
            filePath: "/test/path.md",
            pageName: "Test Page",
            lineNumber: 1
        )
        let task2 = LogseqTask(
            id: "same-id",
            title: "Different title",
            status: .doing,
            createdAt: Date(),
            filePath: "/different/path.md",
            pageName: "Different Page",
            lineNumber: 2
        )
        let task3 = LogseqTask(
            id: "different-id",
            title: "Test task",
            status: .todo,
            createdAt: Date(),
            filePath: "/test/path.md",
            pageName: "Test Page",
            lineNumber: 1
        )
        
        XCTAssertEqual(task1.id, task2.id)
        XCTAssertNotEqual(task1.id, task3.id)
    }
    
    func testTaskHashable() throws {
        let task1 = LogseqTask(
            id: "same-id",
            title: "Test task",
            status: .todo,
            createdAt: Date(),
            filePath: "/test/path.md",
            pageName: "Test Page",
            lineNumber: 1
        )
        let task2 = LogseqTask(
            id: "same-id",
            title: "Different content",
            status: .doing,
            createdAt: Date(),
            filePath: "/different/path.md",
            pageName: "Different Page",
            lineNumber: 2
        )
        
        var set = Set<String>()
        set.insert(task1.id)
        set.insert(task2.id)
        
        XCTAssertEqual(set.count, 1)
    }
    
    func testTaskStatusRawValues() throws {
        XCTAssertEqual(TaskStatus.todo.rawValue, "TODO")
        XCTAssertEqual(TaskStatus.doing.rawValue, "DOING")
        XCTAssertEqual(TaskStatus.now.rawValue, "NOW")
        XCTAssertEqual(TaskStatus.later.rawValue, "LATER")
        XCTAssertEqual(TaskStatus.done.rawValue, "DONE")
        XCTAssertEqual(TaskStatus.cancelled.rawValue, "CANCELLED")
        XCTAssertEqual(TaskStatus.waiting.rawValue, "WAITING")
    }
    
    func testTaskStatusCaseIterable() throws {
        let allStatuses = TaskStatus.allCases
        
        XCTAssertEqual(allStatuses.count, 7)
        XCTAssertTrue(allStatuses.contains(.todo))
        XCTAssertTrue(allStatuses.contains(.doing))
        XCTAssertTrue(allStatuses.contains(.now))
        XCTAssertTrue(allStatuses.contains(.later))
        XCTAssertTrue(allStatuses.contains(.done))
        XCTAssertTrue(allStatuses.contains(.cancelled))
        XCTAssertTrue(allStatuses.contains(.waiting))
    }
    
    func testTaskStatusFromString() throws {
        XCTAssertEqual(TaskStatus(rawValue: "TODO"), .todo)
        XCTAssertEqual(TaskStatus(rawValue: "DOING"), .doing)
        XCTAssertEqual(TaskStatus(rawValue: "NOW"), .now)
        XCTAssertEqual(TaskStatus(rawValue: "LATER"), .later)
        XCTAssertEqual(TaskStatus(rawValue: "DONE"), .done)
        XCTAssertEqual(TaskStatus(rawValue: "CANCELLED"), .cancelled)
        XCTAssertEqual(TaskStatus(rawValue: "WAITING"), .waiting)
        XCTAssertNil(TaskStatus(rawValue: "INVALID"))
    }
    
    func testTaskStatusIsIncomplete() throws {
        XCTAssertTrue(TaskStatus.todo.isIncomplete)
        XCTAssertTrue(TaskStatus.doing.isIncomplete)
        XCTAssertTrue(TaskStatus.now.isIncomplete)
        XCTAssertTrue(TaskStatus.later.isIncomplete)
        XCTAssertTrue(TaskStatus.waiting.isIncomplete)
        XCTAssertFalse(TaskStatus.done.isIncomplete)
        XCTAssertFalse(TaskStatus.cancelled.isIncomplete)
    }
    
    func testTaskWithDifferentStatuses() throws {
        let todoTask = LogseqTask(
            id: "1",
            title: "Todo task",
            status: .todo,
            createdAt: Date(),
            filePath: "/test/path.md",
            pageName: "Test Page",
            lineNumber: 1
        )
        let doingTask = LogseqTask(
            id: "2",
            title: "Doing task",
            status: .doing,
            createdAt: Date(),
            filePath: "/test/path.md",
            pageName: "Test Page",
            lineNumber: 2
        )
        let doneTask = LogseqTask(
            id: "3",
            title: "Done task",
            status: .done,
            createdAt: Date(),
            filePath: "/test/path.md",
            pageName: "Test Page",
            lineNumber: 3
        )
        
        XCTAssertNotEqual(todoTask.status, doingTask.status)
        XCTAssertNotEqual(doingTask.status, doneTask.status)
        XCTAssertNotEqual(todoTask.status, doneTask.status)
    }
}