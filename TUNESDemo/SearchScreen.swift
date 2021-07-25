//
//  SearchScreen.swift
//  TUNESDemo
//
//  Created by Nidhi Joshi on 27/04/2021.
//

import UIKit

class SearchScreen: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var collectionTagList: UICollectionView?
    @IBOutlet weak var textSearchTag: UITextField?
    @IBOutlet weak var btnSubmit: UIButton?
    var coordinator: Coordinator?

    var viewModel: SearchScreenViewModelProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SearchScreenViewModel()
        coordinator = SearchScreenCoordinator(navigationController: self.navigationController ?? UINavigationController())
        setupCollection()
       
        viewModel?.didLoad = { [weak self] in
            self?.collectionTagList?.reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(SearchScreen.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SearchScreen.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
      
    }
        
    func setupCollection() {
        collectionTagList?.registerNib(Constant.tagCellIdentifier)
        collectionTagList?.dataSource = self
        collectionTagList?.delegate = self
        collectionTagList?.collectionViewLayout = createLeftAlignedLayout()
        collectionTagList?.reloadData()
    }
    
    private func createLeftAlignedLayout() -> UICollectionViewLayout {
      let item = NSCollectionLayoutItem(          // this is your cell
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .estimated(40),         // variable width
          heightDimension: .absolute(48)          // fixed height
        )
      )
      
      let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: .init(
          widthDimension: .fractionalWidth(1.0),  // 100% width as inset by its Section
          heightDimension: .estimated(50)         // variable height; allows for multiple rows of items
        ),
        subitems: [item]
      )
      group.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
      group.interItemSpacing = .fixed(10)         // horizontal spacing between cells
      
      return UICollectionViewCompositionalLayout(section: .init(group: group))
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
              if self.view.frame.origin.y == 0 {
                  self.view.frame.origin.y -= keyboardSize.height
              }
         }
     }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
              if self.view.frame.origin.y != 0 {
                  self.view.frame.origin.y += keyboardSize.height
              }
         }
     }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }

    @IBAction func btnSubmitClicked(_ sender: Any) {
       submitData()
    }
    
    func submitData() {
        let entity = viewModel?.getList()?.joined(separator: ",") ?? ""

        var url = Constant.url
        url += "term=" + (textSearchTag?.text ?? "")
        url += "&entity=" + entity.replacingOccurrences(of: " ", with: "")
        (coordinator as? SearchScreenCoordinator)?.didSubmitMedia(url)
    }
    
    @IBAction func getMediaList(_ sender: Any) {
        (coordinator as? SearchScreenCoordinator)?.fetchMediaTag(viewModel as? SearchScreenViewModel ?? SearchScreenViewModel())
        
    }
}

extension SearchScreen: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.getListCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constant.tagCellIdentifier, for: indexPath) as? TagCell
        cell?.loadData(searchItem: viewModel?.getItemAt(index: indexPath.row) ?? "")
                // Configure the cell
        return cell ?? UICollectionViewCell() 
    }
}
