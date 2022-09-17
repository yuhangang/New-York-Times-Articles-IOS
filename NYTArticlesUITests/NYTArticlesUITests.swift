import XCTest

class NYTArticlesUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws { }
    
    func testhomeArticleScreen() {
        let app = XCUIApplication()
        app.launch()
        
        let navigationControllerStaticTextQuery = app.navigationBars.children(matching: .staticText)
        let navigationBarTitle = navigationControllerStaticTextQuery.element(boundBy: 0).label
        let homeScreenCollectionView = app.collectionViews.element(matching: .collectionView,
                                                                    identifier: "home_collection_view")
        let sectionHeaders = homeScreenCollectionView.children(matching: .other)
        let cells = homeScreenCollectionView.children(matching: .cell)
        
        // Test Navigation Title
        XCTAssertEqual(navigationBarTitle, "NYT Articles")
        
        // Test Section Headers
        XCTAssertEqual(sectionHeaders.element(matching: .other, identifier: "home_section_header").staticTexts.element(boundBy: 0).label, "Search")
        XCTAssertEqual(sectionHeaders.element(matching: .other, identifier: "home_section_header").staticTexts.element(boundBy: 1).label, "Popular")
        
        // Test Cells
        XCTAssertEqual(cells.element(boundBy: 0).staticTexts.element.label, "Search Articles")
        XCTAssertEqual(cells.element(boundBy: 1).staticTexts.element.label, "Most Viewed")
        XCTAssertEqual(cells.element(boundBy: 2).staticTexts.element.label, "Most Shared")
        XCTAssertEqual(cells.element(boundBy: 3).staticTexts.element.label, "Most Emailed")
    }
    
    func testsearchArticleScreen() {
        let app = XCUIApplication()
        app.launch()
        
        let homeScreenCollectionView = app.collectionViews.element(matching: .collectionView,
                                                                   identifier: "home_collection_view")
        let searchCell = homeScreenCollectionView.children(matching: .cell).element(boundBy: 0)
        searchCell.tap()
        
        let navigationControllerStaticTextQuery = app.navigationBars.children(matching: .staticText)
        let navigationBarTitle = navigationControllerStaticTextQuery.element(boundBy: 0).label
        let searchBar = app.searchFields
        let searchBarTextField = searchBar.element(boundBy: 0)
        searchBarTextField.tap()
        let searchBarExists = searchBarTextField.exists
        
        XCTAssertEqual(navigationBarTitle, "Search Articles")
        XCTAssertTrue(searchBarExists)
    }
    
    func testMostViewedScreen() {
        let app = XCUIApplication()
        app.launch()
        
        let homeScreenCollectionView = app.collectionViews.element(matching: .collectionView,
                                                                   identifier: "home_collection_view")
        let mostViewedCell = homeScreenCollectionView.children(matching: .cell).element(boundBy: 1)
        mostViewedCell.tap()
        
        let navigationControllerStaticTextQuery = app.navigationBars.children(matching: .staticText)
        let navigationBarTitle = navigationControllerStaticTextQuery.element(boundBy: 0).label
        let mostViewedCollectionView = app.collectionViews.element(matching: .collectionView,
                                                                   identifier: "article_popular_collection_view")
        let cell = mostViewedCollectionView.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertNotNil(cell)
        XCTAssertTrue(navigationBarTitle == "Most Viewed")
    }
    
    func testMostViewedShared() {
        let app = XCUIApplication()
        app.launch()
        
        let homeScreenCollectionView = app.collectionViews.element(matching: .collectionView,
                                                                   identifier: "home_collection_view")
        let mostSharedCell = homeScreenCollectionView.children(matching: .cell).element(boundBy: 2)
        mostSharedCell.tap()
        
        let navigationControllerStaticTextQuery = app.navigationBars.children(matching: .staticText)
        let navigationBarTitle = navigationControllerStaticTextQuery.element(boundBy: 0).label
        let mostSharedCollectionView = app.collectionViews.element(matching: .collectionView,
                                                                   identifier: "article_popular_collection_view")
        let cell = mostSharedCollectionView.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertNotNil(cell)
        XCTAssertTrue(navigationBarTitle == "Most Shared")
    }
    
    func testMostEmailedScreen() {
        let app = XCUIApplication()
        app.launch()
        
        let homeScreenCollectionView = app.collectionViews.element(matching: .collectionView,
                                                                    identifier: "home_collection_view")
        let mostEmailedCell = homeScreenCollectionView.children(matching: .cell).element(boundBy: 3)
        mostEmailedCell.tap()
        
        let navigationControllerStaticTextQuery = app.navigationBars.children(matching: .staticText)
        let navigationBarTitle = navigationControllerStaticTextQuery.element(boundBy: 0).label
        let mostEmailedCollectionView = app.collectionViews.element(matching: .collectionView,
                                                                    identifier: "article_popular_collection_view")
        let cell = mostEmailedCollectionView.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertNotNil(cell)
        XCTAssertTrue(navigationBarTitle == "Most Emailed")
    }
}
