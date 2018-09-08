//
//  ViewController.swift
//  GlueTest
//
//  Created by Andy Bennett on 08/09/2018.
//  Copyright © 2018 Andy Bennett. All rights reserved.
//

import UIKit

private struct Constants
{
    static let backgroundColor: UIColor = .white
    static let insets = UIEdgeInsets(top: 50, left: 10, bottom: 10, right: 10)
}

class ViewController: UIViewController
{
    let searchController = UISearchController(searchResultsController: nil)
    
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())

    var model: Model?
    var viewModel: ViewModel?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        navigationItem.title = "Movies"
        definesPresentationContext = true
        
        self.view.backgroundColor = Constants.backgroundColor
        self.view.addEqualSubview(collectionView, with: Constants.insets)
        
        collectionView.backgroundColor = Constants.backgroundColor
        collectionView.register(Cell.self)
    
        Model.asyncFactory { [weak self] model in
            DispatchQueue.main.async {
                self?.configure(with: model)
            }
        }
    }
    
    func configure(with model: Model)
    {
        let viewModel = ViewModel(model: model)
        viewModel.addObserver(self)
        
        self.collectionView.delegate = viewModel
        self.collectionView.dataSource = viewModel
        
        self.viewModel = viewModel
        self.model = model
    }
}

extension ViewController: ViewModelObserver
{
    func didUpdateMovies()
    {
        self.collectionView.reloadData()
    }
}

extension ViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        self.viewModel?.search(title: searchController.searchBar.text!)
    }
}
