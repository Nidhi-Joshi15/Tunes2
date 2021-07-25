//
//  TUNESDemoTests.swift
//  TUNESDemoTests
//
//  Created by Nidhi Joshi on 27/04/2021.
//

import XCTest
import SDWebImage
@testable import TUNESDemo

class TUNESDemoTests: XCTestCase {
    let urlString = "https://itunes.apple.com/search?term=tree&entity=podcast"
    lazy var searchScreenList = SearchScreen.create(of: .main)
    lazy var listController = ListingScreenViewController.create(of: .main)
    lazy var detailController = DetailViewController.create(of: .main)
    lazy var mediaController = MediaListViewController.create(of: .main)
    var data: [Section]?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCallToiTunesCompletes() {
        let session: URLSession = URLSession(configuration: .default)
        
        let url = URL(string: urlString)
        
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = session.dataTask(with: url!) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            // 2
            promise.fulfill()
        }
        dataTask.resume()
        // 3
        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    func testFetchData() {
        let apiExpectation = expectation(description: "")
        
        ServiceManager().fetchData(url: urlString, onSuccess: { data in
            let list = data?.convertMedia()
            // Test amount of articles
            XCTAssertGreaterThan(data?.resultCount ?? 0, 0)
            
            XCTAssertGreaterThan(list?.sections.count ?? 0, 0)
            apiExpectation.fulfill()
        }, onError: { error in
            print(error)
        })
        
        wait(for: [apiExpectation], timeout: 30)
    }
    
    func testControllerHasCollectionView() {
        
        let controller = ListingScreenViewController.create(of: .main)
        if controller == listController {
            XCTFail("Could not instantiate ListingScreenViewController from main storyboard")
        }
        
        controller.loadViewIfNeeded()
        
        XCTAssertNotNil(controller.gridView,
                        "Controller should have a collectionview")
        
        XCTAssertTrue(controller.gridView?.dataSource is ListingScreenViewController,
                      "collectionview's data source should be a ListingScreenViewController")
        
        XCTAssertTrue(controller.gridView?.delegate is ListingScreenViewController,
                      "collectionview's data source should be a ListingScreenViewController")
        
        XCTAssertTrue(controller.responds(to: #selector(controller.collectionView(_:didSelectItemAt:))))
        XCTAssertTrue(controller.conforms(to: UICollectionViewDataSource.self))
        XCTAssertTrue(controller.responds(to: #selector(controller.collectionView(_:numberOfItemsInSection:))))
        XCTAssertTrue(controller.responds(to: #selector(controller.collectionView(_:cellForItemAt:))))
        
    }
    
    func testListshowsData() {
        if listController.viewModel?.getsectionCount() ?? 0 > 0 {
            let weatherCount = listController.viewModel?.getItemCount(0)
            XCTAssertNil(listController.viewModel?.getList(0))
            XCTAssertNil(listController.viewModel?.getSectionList())
            XCTAssertGreaterThan(weatherCount!, 0)
            
        }
        
    }
    
    func testHasUsers() {
        let viewModel = MediaListViewModel(selsectedType: [String]())
        XCTAssertTrue(viewModel.hasMediaType())
    }
    
    func testcheckCamalized() {
        var string = "Music Video"
        string = string.replacingOccurrences(of: " ", with: "")
        XCTAssertEqual(string.camelized, "musicVideo")
        
    }
    
    func testValidHost() {
        let expected = expectation(description: "Check valid host")
        if Reachability.isConnectedToNetwork() {
            expected.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testImageWithStaticURL() throws {
        let expectation = self.expectation(description: "static url initializer")
        let imageUrl = URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Video/v4/ae/be/c8/aebec8f3-2baa-7708-1cb9-af064c5423a4/source/100x100bb.jpg")
        let imageView = UIImageView()
        imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholderImage")) { (image, error, _, _) in
            guard image != nil  else {
                XCTFail(error.debugDescription)
                return
            }
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testHeaderView() {
        if listController.viewModel?.getsectionCount() ?? 0 > 0 {
            _ = listController.viewModel?.getSectionAt(0)
            
            listController.gridView?.reloadData()
            let section = listController.gridView?.dataSource?.numberOfSections?(in: listController.gridView ?? UICollectionView())
            
            XCTAssertEqual(section, listController.viewModel?.getsectionCount())
            
        }
    }
    
    func testControllerHasTableView() {
        let controller = MediaListViewController.create(of: .main)
        if controller == mediaController {
            XCTFail("Could not instantiate MediaListViewController from main storyboard")
        }
        
        controller.loadViewIfNeeded()
        
        XCTAssertNotNil(controller.tblMediaTypeList,
                        "Controller should have a tableview")
        
        XCTAssertTrue(controller.tblMediaTypeList?.dataSource is MediaListViewController,
                      "TableView's data source should be a MediaListViewController")
        
        XCTAssertTrue(controller.tblMediaTypeList?.delegate is MediaListViewController,
                      "TableView's data source should be a MediaListViewController")
        
        XCTAssertTrue(controller.responds(to: #selector(controller.tableView(_:didSelectRowAt:))))
        XCTAssertTrue(controller.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(controller.responds(to: #selector(controller.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(controller.responds(to: #selector(controller.tableView(_:cellForRowAt:))))
        
    }
    
    func testListshowsWeather() {
        if mediaController.viewModel?.getListCount() ?? 0 > 0 {
            let mediaCount = mediaController.viewModel?.getListCount() ?? 0
            return XCTAssertGreaterThan(mediaCount, 0)
        }
        
    }
    
    func testTableViewCellCreateCellsWithReuseIdentifier() {
        let indexPath = IndexPath(row: 0, section: 0)
        guard  let list = mediaController.tblMediaTypeList else {
            return
        }
        let cell = list.dataSource?.tableView(list, cellForRowAt: indexPath)
        let expectedReuseIdentifier = String(format: "CELL", indexPath.section, indexPath.row)
        XCTAssertTrue((cell?.reuseIdentifier == expectedReuseIdentifier), "Table does not create reusable cells")
    }
    
    func testlistCollectionViewForGRIDCellCreateCellsWithReuseIdentifier() {
        let indexPath = IndexPath(row: 0, section: 0)
        listController.viewModel?.displayView = .grid
        
        if let list = listController.gridView {
            let kindString = UICollectionView.elementKindSectionHeader
            let header = list.dataSource?.collectionView?(list, viewForSupplementaryElementOfKind: kindString, at: indexPath) as? HeaderView
        
            header?.layoutSubviews()
            XCTAssertEqual(header?.frame.origin.x, 15)
            let section = listController.viewModel?.getSectionAt(0)
            XCTAssertEqual(header?.titleLabel.text, section?.sectionName)
        }
    }
    
    func testReusIdentifier() {
        
        let indexPath = IndexPath(row: 0, section: 0)
        listController.viewModel?.displayView = .grid
        if  let list = listController.gridView {
            let cell = list.dataSource?.collectionView(list, cellForItemAt: indexPath)
            let expectedReuseIdentifier = String(format: Constant.mediaCellIdentifier, indexPath.section, indexPath.row)
            XCTAssertTrue((cell?.reuseIdentifier == expectedReuseIdentifier), "Table does not create reusable cells")
        }
    }
    
    func testlistCollectionViewForLISTCellCreateCellsWithReuseIdentifier() {
        let indexPath = IndexPath(row: 0, section: 0)
        listController.viewModel?.displayView = .list
        if  let list = listController.gridView {
            let cell = list.dataSource?.collectionView(list, cellForItemAt: indexPath)
            let expectedReuseIdentifier = String(format: Constant.mediaSingleCellIdentifier, indexPath.section, indexPath.row)
            XCTAssertTrue((cell?.reuseIdentifier == expectedReuseIdentifier), "Table does not create reusable cells")
        }
        
    }
    
    func testSearchScreenCoordinator() {
        searchScreenList.coordinator = SearchScreenCoordinator(navigationController: UINavigationController())
        listController.coordinator = ListingScreenCoordinator(navigationController: UINavigationController())
        
        let media = listController.viewModel?.getItemAt(0, 0)

        XCTAssertNotNil(listController.coordinator?.didSelectMedia(media))
        XCTAssertNotNil(searchScreenList.getMediaList(UIButton()))
        XCTAssertNotNil(searchScreenList.btnSubmitClicked(UIButton()))
        XCTAssertNotNil(searchScreenList.submitData())
    }
    
    func testSegmentValue() {
        listController.segmentValueChanged(UISegmentedControl())
    }
    
    func testDetailViewControllerSetup() {
        detailController.viewModel = DetailScreenViewModel(media: nil)
        detailController.setupData()
        XCTAssertTrue(detailController.responds(to: #selector(detailController.playVideoClicked(_:))))
        
    }
    func test_cell() {
        // given
        let list = mediaController.tblMediaTypeList ?? UITableView()
        
        // when
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = list.dataSource?.tableView(list, cellForRowAt: indexPath)
        
        // then
        XCTAssertEqual(cell?.textLabel?.text, mediaController.viewModel?.getItemAt(0))
        
        let headerTitle = "Songs"
        let header = HeaderView(frame: CGRect.zero)
        header.loadData(headerTitle)
        XCTAssertEqual(header.titleLabel.text, headerTitle)
        
        let media = listController.viewModel?.getItemAt(0, 0)
        
        let mediaCell = MediaCell(frame: CGRect.zero)
        mediaCell.loadData(media: media)
        
        XCTAssertEqual(mediaCell.mediaTitle?.text, media?.trackCensoredName)
        detailController.viewModel?.mediaItem = media
        detailController.setupVideo()
        let mediaSingleCell = MediaSingleCell(frame: CGRect.zero)
        mediaSingleCell.loadData(media: media)
        
        XCTAssertEqual(mediaSingleCell.mediaTitle?.text, media?.trackCensoredName)
        
        let tagCell = TagCell()
        let tagItem = "Artist"
        tagCell.loadData(searchItem: tagItem)
        
    }
    
    func testListingViewModel() {
        let viewModel = ListingScreenViewModel(urlString)
        let expectation = self.expectation(description: "fetchData")
        viewModel.fetchData()
        viewModel.didLoad = {
            expectation.fulfill()
            XCTAssertNotNil(viewModel.getSectionList())
            XCTAssertNotNil(viewModel.getList(0))
            XCTAssertNotNil(viewModel.getItemAt(0, 0))
            XCTAssertNotNil(viewModel.getsectionCount())
            XCTAssertNotNil(viewModel.getSectionAt(0))
            XCTAssertNotNil(viewModel.getItemCount(0))
        }
        wait(for: [expectation], timeout: 30)
    }
    
    func testSearchViewModel() {
        let viewModel = SearchScreenViewModel()
        viewModel.selectedList = ["book", "song"]
        
        XCTAssertNotNil(viewModel.getList())
        XCTAssertNotNil(viewModel.getListCount())
        XCTAssertNotNil(viewModel.getItemAt(index: 0))
        
    }
    
    func testMediaViewModel() {
        let viewModel = MediaListViewModel(selsectedType: ["book", "song"])
        XCTAssertNotNil(viewModel.getList())
        XCTAssertNotNil(viewModel.getListCount())
        XCTAssertNotNil(viewModel.getItemAt(0))
        XCTAssertTrue(viewModel.hasMediaType())
        
    }
    
    func testHelper() {
        let string = "bOOK"
        let string2 = ""
        XCTAssertEqual(string.uppercasingFirst, "BOOK")
        XCTAssertEqual(string2.camelized, "")
        
    }
}
