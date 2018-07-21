//
//  GiphyListViewController.swift
//  GiphyBrowser
//
//  Created by Joshua Homann on 7/15/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import UIKit

class GiphyListViewController: UIViewController {
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    @IBOutlet weak var searchFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var favoritesFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var favoritesHeader: FavoriteHeaderView!
    private static let numberOfItemsAcross: CGFloat = 2
    private var searchResults: [Giphy] = []
    private var favorites: [Giphy] = []
    //FIXME: Issue 13 (Intermediate) Data structures
    private var favoritesIds: [String] = []
    private var isShowingFavorites = true
    private var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for new giphies..."
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        load()
        favoritesCollectionView.reloadData()
        favoritesIds = favorites.map{$0.id}
        favoritesHeader.configure(with: favorites)
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: .UIApplicationWillResignActive, object: nil)
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(save), userInfo: nil, repeats: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let remainingSpace = searchCollectionView.bounds.width
                            - searchFlowLayout.sectionInset.left
                            - searchFlowLayout.sectionInset.right
                            - searchFlowLayout.minimumInteritemSpacing * (GiphyListViewController.numberOfItemsAcross - 1)
        let dimension = remainingSpace / GiphyListViewController.numberOfItemsAcross
        searchFlowLayout.itemSize = CGSize(width: dimension, height: dimension)
        favoritesFlowLayout.itemSize = searchFlowLayout.itemSize
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? GiphyDetailViewController else {
            return
        }
        if presentedViewController != nil  {
            dismiss(animated: false, completion: nil)
        }
        if sender is UIBarButtonItem {
            destination.mode = .cat
        } else if let cell = sender as? UICollectionViewCell,
                  let index = searchCollectionView.indexPath(for: cell)?.row {
            destination.mode = .detail(searchResults[index])
        } else if let cell = sender as? UICollectionViewCell,
            let index = favoritesCollectionView.indexPath(for: cell)?.row {
            destination.mode = .favorite(favorites[index])
        }
    }
    @IBAction private func tap(_ sender: Any) {
        isShowingFavorites = !isShowingFavorites
        UIView.animate(withDuration: 0.5) {
            self.searchCollectionView.isHidden = self.isShowingFavorites
            self.favoritesCollectionView.isHidden = !self.isShowingFavorites
        }
    }
    private func load() {
        do {
            let saved = try FileService.read(from: "favorites")
            favorites = saved
        } catch (let error) {
            print(error)
        }
    }
    @objc private func save() {
        do {
            try FileService.write(giphies: self.favorites, to: "favorites")
        } catch (let error) {
            print(error)
        }
    }

    private func add(favorite: Giphy) {
        guard favoritesIds.contains(favorite.id) == false else {
            return
        }
        favoritesIds.append(favorite.id)
        favorites.append(favorite)
        favoritesCollectionView.insertItems(at: [IndexPath(item: favorites.count - 1, section: 0)])
        favoritesHeader.configure(with: favorites)
    }

    private func remove(favorite: Giphy) {
        guard favoritesIds.contains(favorite.id),
              let index = favorites.index(where: {$0.id == favorite.id}) else {
            return
        }
        favoritesIds.append(favorite.id)
        favorites.remove(at: index)
        favoritesCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        favoritesHeader.configure(with: favorites)
        searchCollectionView.reloadData()
    }
}

extension GiphyListViewController: GiphyCollectionViewCellDelegate {
    func giphyCollectionViewCell(_ cell: GiphyCollectionViewCell, didUpdate isStar: Bool) {
        if let index = searchCollectionView.indexPath(for: cell)?.row  {
            if isStar {
                add(favorite: searchResults[index])
                //FIXME: Issue 6 (Easy) remove the forced unwrapped optionals
                let snapShot = cell.snapshotView(afterScreenUpdates: false)!
                let favoritesSuperView = favoritesHeader.superview!
                snapShot.center = view.convert(cell.center, from: searchCollectionView)
                let target = view.convert(favoritesHeader.frame.origin, from: favoritesSuperView).y
                view.addSubview(snapShot)
                UIView.animate(withDuration: 0.5, animations: {
                    snapShot.frame = CGRect(x: 0, y: target, width: 96, height: 96)
                    snapShot.alpha = 0.2
                }, completion: { _ in
                    snapShot.removeFromSuperview()
                    self.favoritesHeader.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    UIView.animate(withDuration: 0.67, delay: 0, usingSpringWithDamping: 0.25, initialSpringVelocity: 4, options: [], animations: { self.favoritesHeader.transform = .identity}, completion: { _ in })
                })
            } else {
                remove(favorite: searchResults[index])
            }
        } else if let index = favoritesCollectionView.indexPath(for: cell)?.row {
            remove(favorite: favorites[index])
        }
    }
}

extension GiphyListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GiphyCollectionViewCell.reuseIdentifier, for: indexPath) as? GiphyCollectionViewCell else {
            return UICollectionViewCell()
        }
        switch collectionView {
        case searchCollectionView:
            cell.configure(with: searchResults[indexPath.row],
                           isStar: favoritesIds.contains(searchResults[indexPath.row].id),
                           delegate: self)
        case favoritesCollectionView:
            cell.configure(with: favorites[indexPath.row],
                           isStar: true,
                           delegate: self)
        default:
            break
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case searchCollectionView:
            return searchResults.count
        case favoritesCollectionView:
            return favorites.count
        default:
            return 0
        }
    }
}

extension GiphyListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchCollectionView.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.searchCollectionView.isHidden = false
            self.favoritesCollectionView.isHidden = true
        }
        Giphy.getSearchResults(term: searchBar.text ?? "", page: 0) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else {
                    return
                }
                switch result {
                case .success(let page):
                    self.searchResults.removeAll()
                    self.searchResults.append(contentsOf: page.data)
                    self.searchCollectionView.reloadData()
                    self.searchCollectionView.contentOffset = .zero
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
