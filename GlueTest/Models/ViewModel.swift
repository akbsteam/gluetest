//
//  ViewModel.swift
//  GlueTest
//
//  Created by Andy Bennett on 09/09/2018.
//  Copyright © 2018 Andy Bennett. All rights reserved.
//

import UIKit

protocol ViewModelObserver: AnyObject {
    func didUpdateMovies()
}

class ViewModel: NSObject
{
    let model: Model
    
    var observers: [ViewModelObserver] = []
    var movies: [Movie] {
        didSet {
            self.observers.forEach { $0.didUpdateMovies() }
        }
    }
    
    func addObserver(_ observer: ViewModelObserver)
    {
        self.observers.append(observer)
    }
    
    init(model: Model)
    {
        self.model = model
        self.movies = model.movies
    }
    
    func search(title: String)
    {
        self.movies = title.isEmpty
            ? self.model.movies
            : self.model.movies.filter { $0.title.contains(title) }
    }
    
    func search(genre: String)
    {
        self.movies = self.movies.count == self.model.movies.count
            ? self.model.movies.filter { $0.genre == genre }
            : self.model.movies
    }
}

extension ViewModel: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 100, height: 140)
    }
}

extension ViewModel: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath)
    {
        let movie = self.movies[indexPath.item]
        self.search(genre: movie.genre)
    }
}

extension ViewModel: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int
    {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: Cell = collectionView.dequeueCell(at: indexPath)
        let movie = self.movies[indexPath.item]

        cell.configure(with: movie.genre,
                       poster: movie.poster)
        
        URLSession.shared.fetchImage(from: movie.poster, into: self.model.cacheFolder) { (url, image) in
            DispatchQueue.main.async {
                cell.addImage(from: url, image: image)
            }
        }

        return cell
    }
}
