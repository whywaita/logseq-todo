import XCTest
@testable import LogseqTodo

final class AppStateTests: XCTestCase {
    
    @MainActor
    func testSortTasksNewestFirst() async throws {
        UserDefaults.standard.removeObject(forKey: "appSettings")
        let appState = AppState()
        
        let oldDate = Date(timeIntervalSince1970: 1704067200)
        let newDate = Date(timeIntervalSince1970: 1735603200)
        let middleDate = Date(timeIntervalSince1970: 1718409600)
        
        let task1 = LogseqTask(
            id: "1",
            title: "Old task",
            status: .todo,
            createdAt: oldDate,
            filePath: "/test/old.md",
            pageName: "2024/01/01",
            lineNumber: 1
        )
        let task2 = LogseqTask(
            id: "2",
            title: "New task",
            status: .todo,
            createdAt: newDate,
            filePath: "/test/new.md",
            pageName: "2024/12/31",
            lineNumber: 1
        )
        let task3 = LogseqTask(
            id: "3",
            title: "Middle task",
            status: .todo,
            createdAt: middleDate,
            filePath: "/test/middle.md",
            pageName: "2024/06/15",
            lineNumber: 1
        )
        
        appState.tasks = [task1, task3, task2]
        appState.sortOrder = .newestFirst
        
        let sorted = appState.tasks.sorted { first, second in
            first.displayDate > second.displayDate
        }
        
        XCTAssertEqual(sorted[0].title, "New task")
        XCTAssertEqual(sorted[1].title, "Middle task")
        XCTAssertEqual(sorted[2].title, "Old task")
    }
    
    @MainActor
    func testSortTasksOldestFirst() async throws {
        UserDefaults.standard.removeObject(forKey: "appSettings")
        let appState = AppState()
        
        let oldDate = Date(timeIntervalSince1970: 1704067200)
        let newDate = Date(timeIntervalSince1970: 1735603200)
        let middleDate = Date(timeIntervalSince1970: 1718409600)
        
        let task1 = LogseqTask(
            id: "1",
            title: "Old task",
            status: .todo,
            createdAt: oldDate,
            filePath: "/test/old.md",
            pageName: "2024/01/01",
            lineNumber: 1
        )
        let task2 = LogseqTask(
            id: "2",
            title: "New task",
            status: .todo,
            createdAt: newDate,
            filePath: "/test/new.md",
            pageName: "2024/12/31",
            lineNumber: 1
        )
        let task3 = LogseqTask(
            id: "3",
            title: "Middle task",
            status: .todo,
            createdAt: middleDate,
            filePath: "/test/middle.md",
            pageName: "2024/06/15",
            lineNumber: 1
        )
        
        appState.tasks = [task2, task3, task1]
        appState.sortOrder = .oldestFirst
        
        let sorted = appState.tasks.sorted { first, second in
            first.displayDate < second.displayDate
        }
        
        XCTAssertEqual(sorted[0].title, "Old task")
        XCTAssertEqual(sorted[1].title, "Middle task")
        XCTAssertEqual(sorted[2].title, "New task")
    }
    
    @MainActor
    func testFilterTasksByStatus() async throws {
        UserDefaults.standard.removeObject(forKey: "appSettings")
        let appState = AppState()
        
        let todoTask = LogseqTask(
            id: "1",
            title: "Todo task",
            status: .todo,
            createdAt: Date(),
            filePath: "/test/path.md",
            pageName: "2024/01/01",
            lineNumber: 1
        )
        let doingTask = LogseqTask(
            id: "2",
            title: "Doing task",
            status: .doing,
            createdAt: Date(),
            filePath: "/test/path.md",
            pageName: "2024/01/01",
            lineNumber: 2
        )
        let doneTask = LogseqTask(
            id: "3",
            title: "Done task",
            status: .done,
            createdAt: Date(),
            filePath: "/test/path.md",
            pageName: "2024/01/01",
            lineNumber: 3
        )
        
        appState.tasks = [todoTask, doingTask, doneTask]
        appState.selectedStatuses = [.todo, .doing]
        
        let filtered = appState.tasks.filter { appState.selectedStatuses.contains($0.status) }
        
        XCTAssertEqual(filtered.count, 2)
        XCTAssertTrue(filtered.contains(where: { $0.title == "Todo task" }))
        XCTAssertTrue(filtered.contains(where: { $0.title == "Doing task" }))
        XCTAssertFalse(filtered.contains(where: { $0.title == "Done task" }))
    }
    
    @MainActor
    func testSaveSettings() async throws {
        UserDefaults.standard.removeObject(forKey: "appSettings")
        let appState = AppState()
        
        appState.graphPath = "/test/path"
        appState.sortOrder = .oldestFirst
        appState.selectedStatuses = [.todo, .now]
        appState.reloadInterval = 120
        
        appState.saveSettings()
        
        let data = UserDefaults.standard.data(forKey: "appSettings")
        XCTAssertNotNil(data)
        
        if let data = data,
           let settings = try? JSONDecoder().decode(AppSettings.self, from: data) {
            XCTAssertEqual(settings.graphPath, "/test/path")
            XCTAssertEqual(settings.sortOrder, "Oldest First")
            XCTAssertEqual(settings.reloadInterval, 120)
            XCTAssertEqual(settings.selectedStatuses.count, 2)
            XCTAssertTrue(settings.selectedStatuses.contains("TODO"))
            XCTAssertTrue(settings.selectedStatuses.contains("NOW"))
        } else {
            XCTFail("Failed to decode saved settings")
        }
    }
    
    @MainActor
    func testLoadSettings() async throws {
        let settings = AppSettings(
            graphPath: "/loaded/path",
            selectedStatuses: ["TODO", "DOING"],
            sortOrder: "Oldest First",
            reloadInterval: 90
        )
        
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: "appSettings")
        }
        
        let newAppState = AppState()
        
        XCTAssertEqual(newAppState.graphPath, "/loaded/path")
        XCTAssertEqual(newAppState.sortOrder, .oldestFirst)
        XCTAssertEqual(newAppState.reloadInterval, 90)
        XCTAssertEqual(newAppState.selectedStatuses.count, 2)
        XCTAssertTrue(newAppState.selectedStatuses.contains(.todo))
        XCTAssertTrue(newAppState.selectedStatuses.contains(.doing))
    }
    
    @MainActor
    func testDefaultSettings() async throws {
        UserDefaults.standard.removeObject(forKey: "appSettings")
        let newAppState = AppState()
        
        XCTAssertEqual(newAppState.graphPath, "")
        XCTAssertEqual(newAppState.sortOrder, .newestFirst)
        XCTAssertEqual(newAppState.reloadInterval, 60)
        XCTAssertEqual(newAppState.selectedStatuses, [.todo, .doing])
    }
    
    @MainActor
    func testErrorHandling() async throws {
        UserDefaults.standard.removeObject(forKey: "appSettings")
        let appState = AppState()
        
        appState.errorMessage = "Test error"
        XCTAssertEqual(appState.errorMessage, "Test error")
        
        appState.errorMessage = nil
        XCTAssertNil(appState.errorMessage)
    }
    
    @MainActor
    func testLoadingState() async throws {
        UserDefaults.standard.removeObject(forKey: "appSettings")
        let appState = AppState()
        
        XCTAssertFalse(appState.isLoading)
        
        appState.isLoading = true
        XCTAssertTrue(appState.isLoading)
        
        appState.isLoading = false
        XCTAssertFalse(appState.isLoading)
    }
}