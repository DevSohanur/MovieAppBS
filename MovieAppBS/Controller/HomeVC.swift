//
//  HomeVC.swift
//  MovieAppBS
//
//  Created by Sohanur Rahman on 19/4/23..
//

import UIKit

class HomeVC: UIViewController, UITextFieldDelegate {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Movie List"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    lazy var searchField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search Movie Here"
        textField.text = "Marvel"
        textField.font = UIFont.boldSystemFont(ofSize: 14)
        textField.textColor = .black
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.layer.borderColor = UIColor.hexStringToUIColor(hex: "#F0F0F5").cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.setLeftPaddingPoints(16)
        textField.setRightPaddingPoints(16)
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    lazy var movieCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .zero
        
        layout.itemSize = .zero
        layout.scrollDirection = .vertical
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    lazy var refreshView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.isHidden = true
        return view
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.tintColor = .white
        activityView.style = .white
        return activityView
    }()
    
    var movieResponseModel: MovieResponseModel!
    var movieDataResponseModel = [MovieDataResponseModel]()
    
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    
        setupConstraints()
        searchButton.addTarget(self, action: #selector(searchMovie),for: .touchUpInside)
        
        getMovieData(query: "Marvel")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        page = 1
        if (string == "\n") {
            textField.resignFirstResponder()
            if searchField.text!.isEmpty {
                getMovieData(query : "Marvel")
            }
            else{
                getMovieData(query : searchField.text!)
            }
            return false
        }
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                var str = searchField.text!
                str.removeLast()
                if str.isEmpty {
                    getMovieData(query : "Marvel")
                }
                else{
                    getMovieData(query : str)
                }
            }
            else{
                getMovieData(query : searchField.text! + string)
            }
        }
        return true
    }
    
    @objc func searchMovie(sender: UIButton) {
        print("click")
        movieDataResponseModel.removeAll()
        movieCollectionView.reloadData()
        getMovieData(query: searchField.text!)
    }
    
    
    
    func setupConstraints() {
        // Add subviews
        view.addSubview(titleLabel)
        view.addSubview(searchField)
        view.addSubview(searchButton)
        view.addSubview(movieCollectionView)
        view.addSubview(refreshView)
        
        searchField.delegate = self
        
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        movieCollectionView.register(MovieDetailsCell.self, forCellWithReuseIdentifier: MovieDetailsCell.identifire)
        movieCollectionView.register(MovieEmptyCell.self, forCellWithReuseIdentifier: MovieEmptyCell.identifire)
        
        refreshView.addSubview(activityIndicatorView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        movieCollectionView.translatesAutoresizingMaskIntoConstraints = false
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set static constraints
        NSLayoutConstraint.activate([
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: self.getStatusBarHeight() + 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            //Search Button
            searchButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            searchButton.widthAnchor.constraint(equalToConstant: 80),
            
            //Search Field
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: 0),
            searchField.heightAnchor.constraint(equalToConstant: 50),
            
            //Movie Collection View
            movieCollectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
            movieCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            movieCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            movieCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10),
            
            // Refresh View
            refreshView.topAnchor.constraint(equalTo: view.topAnchor),
            refreshView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            refreshView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            refreshView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Activity View
            activityIndicatorView.centerXAnchor.constraint(equalTo: refreshView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: refreshView.centerYAnchor)
        ])
    }
}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieDataResponseModel.count == 0 ? 1 : movieDataResponseModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if movieDataResponseModel.count == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieEmptyCell.identifire, for: indexPath) as! MovieEmptyCell
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieDetailsCell.identifire, for: indexPath) as! MovieDetailsCell
            cell.setMovieDataToCell(data: movieDataResponseModel[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if movieDataResponseModel.count == 0 {
            return CGSize(width: movieCollectionView.bounds.width, height: movieCollectionView.bounds.height)
        }
        else{
            let titleHeight = movieDataResponseModel[indexPath.row].original_title.height(withConstrainedWidth: (view.bounds.width - 112), font: UIFont.boldSystemFont(ofSize: 14))
            let subTitleHeight = movieDataResponseModel[indexPath.row].overview
                .height(withConstrainedWidth: (view.bounds.width - 112), font: UIFont.systemFont(ofSize: 14))
            
            var cellHeight = titleHeight + subTitleHeight + 20
            cellHeight = (cellHeight <= 120 ? 120 : cellHeight)
            
            print("Hey Sohan Cell Height: title Height: \(titleHeight) detailsHeight : \(subTitleHeight) \(cellHeight)")
            
            return CGSize(width: movieCollectionView.bounds.width, height: cellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movieDataResponseModel.count - 4 {
            if page < movieResponseModel.total_pages ?? 0{
                page += 1
                getMovieData(query: searchField.text!)
            }
        }
    }
    
}
