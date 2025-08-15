import XCTest
import Foundation
@testable import LogseqTodo

final class LogseqParserTests: XCTestCase {
    var tempDir: URL!
    var graphPath: String!
    
    override func setUp() {
        super.setUp()
        tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        graphPath = tempDir.path
        try? FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        try? FileManager.default.createDirectory(at: tempDir.appendingPathComponent("journals"), withIntermediateDirectories: true)
        try? FileManager.default.createDirectory(at: tempDir.appendingPathComponent("pages"), withIntermediateDirectories: true)
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: tempDir)
        super.tearDown()
    }
    
    func testParseStandardTODOFormat() throws {
        let content = """
        TODO Buy groceries
        TODO Call dentist
        """
        
        let journalFile = tempDir.appendingPathComponent("journals/2024_01_15.md")
        try content.write(to: journalFile, atomically: true, encoding: .utf8)
        
        let parser = LogseqParser(graphPath: graphPath)
        let tasks = try parser.parseTasks()
        
        XCTAssertEqual(tasks.count, 2)
        XCTAssertEqual(tasks[0].title, "Buy groceries")
        XCTAssertEqual(tasks[0].status, .todo)
        XCTAssertEqual(tasks[1].title, "Call dentist")
    }
    
    func testParseHyphenPrefixFormat() throws {
        let content = """
        - TODO Morning workout
        - DOING Write documentation
        """
        
        let journalFile = tempDir.appendingPathComponent("journals/2024_01_15.md")
        try content.write(to: journalFile, atomically: true, encoding: .utf8)
        
        let parser = LogseqParser(graphPath: graphPath)
        let tasks = try parser.parseTasks()
        
        XCTAssertEqual(tasks.count, 2)
        XCTAssertEqual(tasks[0].title, "Morning workout")
        XCTAssertEqual(tasks[0].status, .todo)
        XCTAssertEqual(tasks[1].title, "Write documentation")
        XCTAssertEqual(tasks[1].status, .doing)
    }
    
    func testParseBracketFormat() throws {
        let content = """
        [[TODO]] Review pull request
        [[NOW]] Fix critical bug
        """
        
        let journalFile = tempDir.appendingPathComponent("journals/2024_01_15.md")
        try content.write(to: journalFile, atomically: true, encoding: .utf8)
        
        let parser = LogseqParser(graphPath: graphPath)
        let tasks = try parser.parseTasks()
        
        XCTAssertEqual(tasks.count, 2)
        XCTAssertEqual(tasks[0].title, "Review pull request")
        XCTAssertEqual(tasks[0].status, .todo)
        XCTAssertEqual(tasks[1].title, "Fix critical bug")
        XCTAssertEqual(tasks[1].status, .now)
    }
    
    func testParseMixedFormats() throws {
        let content = """
        TODO Standard format task
        - TODO Hyphen format task
        [[TODO]] Bracket format task
        DOING Another standard task
        """
        
        let journalFile = tempDir.appendingPathComponent("journals/2024_01_15.md")
        try content.write(to: journalFile, atomically: true, encoding: .utf8)
        
        let parser = LogseqParser(graphPath: graphPath)
        let tasks = try parser.parseTasks()
        
        XCTAssertEqual(tasks.count, 4)
        XCTAssertEqual(tasks[0].title, "Standard format task")
        XCTAssertEqual(tasks[1].title, "Hyphen format task")
        XCTAssertEqual(tasks[2].title, "Bracket format task")
        XCTAssertEqual(tasks[3].title, "Another standard task")
        XCTAssertEqual(tasks[3].status, .doing)
    }
    
    func testParseAllStatuses() throws {
        let content = """
        TODO Todo task
        DOING Doing task
        NOW Now task
        LATER Later task
        DONE Done task
        CANCELLED Cancelled task
        WAITING Waiting task
        """
        
        let journalFile = tempDir.appendingPathComponent("journals/2024_01_15.md")
        try content.write(to: journalFile, atomically: true, encoding: .utf8)
        
        let parser = LogseqParser(graphPath: graphPath)
        let tasks = try parser.parseTasks()
        
        XCTAssertEqual(tasks.count, 7)
        XCTAssertEqual(tasks[0].status, .todo)
        XCTAssertEqual(tasks[1].status, .doing)
        XCTAssertEqual(tasks[2].status, .now)
        XCTAssertEqual(tasks[3].status, .later)
        XCTAssertEqual(tasks[4].status, .done)
        XCTAssertEqual(tasks[5].status, .cancelled)
        XCTAssertEqual(tasks[6].status, .waiting)
    }
    
    func testIgnoreNonTaskLines() throws {
        let content = """
        This is a regular line
        TODO Valid task
        Another regular line
        # Heading
        DOING Another valid task
        """
        
        let journalFile = tempDir.appendingPathComponent("journals/2024_01_15.md")
        try content.write(to: journalFile, atomically: true, encoding: .utf8)
        
        let parser = LogseqParser(graphPath: graphPath)
        let tasks = try parser.parseTasks()
        
        XCTAssertEqual(tasks.count, 2)
        XCTAssertEqual(tasks[0].title, "Valid task")
        XCTAssertEqual(tasks[1].title, "Another valid task")
    }
    
    func testParseJournalDate() throws {
        let content = "TODO Test task"
        
        let journalFile = tempDir.appendingPathComponent("journals/2024_12_25.md")
        try content.write(to: journalFile, atomically: true, encoding: .utf8)
        
        let parser = LogseqParser(graphPath: graphPath)
        let tasks = try parser.parseTasks()
        
        XCTAssertEqual(tasks.count, 1)
        XCTAssertEqual(tasks[0].pageName, "2024/12/25")
    }
    
    func testParsePageTasks() throws {
        let content = "TODO Test task"
        
        let pageFile = tempDir.appendingPathComponent("pages/my_page.md")
        try content.write(to: pageFile, atomically: true, encoding: .utf8)
        
        let parser = LogseqParser(graphPath: graphPath)
        let tasks = try parser.parseTasks()
        
        XCTAssertEqual(tasks.count, 1)
        XCTAssertEqual(tasks[0].pageName, "my page")
    }
    
    func testEmptyContent() throws {
        let content = ""
        
        let journalFile = tempDir.appendingPathComponent("journals/2024_01_15.md")
        try content.write(to: journalFile, atomically: true, encoding: .utf8)
        
        let parser = LogseqParser(graphPath: graphPath)
        let tasks = try parser.parseTasks()
        
        XCTAssertEqual(tasks.count, 0)
    }
    
    func testWhitespaceHandling() throws {
        let content = """
            TODO Task with leading spaces
        \t\tTODO Task with tabs
        TODO    Task with extra spaces
        """
        
        let journalFile = tempDir.appendingPathComponent("journals/2024_01_15.md")
        try content.write(to: journalFile, atomically: true, encoding: .utf8)
        
        let parser = LogseqParser(graphPath: graphPath)
        let tasks = try parser.parseTasks()
        
        XCTAssertEqual(tasks.count, 3)
        XCTAssertEqual(tasks[0].title, "Task with leading spaces")
        XCTAssertEqual(tasks[1].title, "Task with tabs")
        XCTAssertEqual(tasks[2].title, "Task with extra spaces")
    }
}