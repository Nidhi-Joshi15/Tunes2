//
//  MediaListViewController.swift
//  TUNESDemo
//
//  Created by Nidhi Joshi on 27/04/2021.
//

import Foundation
import UIKit

class MediaListViewController: UIViewController {
    var viewModel: MediaListViewModel?
    @IBOutlet weak var tblMediaTypeList: UITableView?
    var delegate: SearchScreenViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMediaTypeList?.reloadData()
    }
    deinit {
        delegate?.selectedList = viewModel?.selectedType
        delegate?.didLoad?()
    }
    
}

extension MediaListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.getListCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell? ?? UITableViewCell()
        cell.textLabel?.text = viewModel?.getItemAt(indexPath.row)
    
        if((viewModel?.selectedType.contains(viewModel?.getItemAt(indexPath.row).lowercased() ?? "")) ?? false) {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
                // set the text from the data model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard let item = viewModel?.getItemAt(indexPath.row).lowercased() else {
            return
        }
        
        if !(viewModel?.selectedType.contains(item) ?? false) {
            viewModel?.selectedType.append(viewModel?.getItemAt(indexPath.row).lowercased() ?? "")
            cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
                    } else {
                        viewModel?.selectedType = viewModel?.selectedType.filter { $0 != item } ?? []
                        cell?.accessoryType = UITableViewCell.AccessoryType.none
                    }
    }
}
