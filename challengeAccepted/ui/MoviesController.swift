//
//  ViewController.swift
//  challengeAccepted
//
//  Created by Mac on 12/28/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class MoviesController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var NoResults: UILabel!
    
    private var currentPage = 1
    private var limitOfItems = 10
    private var currentPageSearch = 1
    private var isSearching = false
    private var keywordHint = ""
    private var keywordTyping = ""
    
    private var movieData = [TraktMovieResponse]()
    private var searchData = [TraktResultResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.estimatedRowHeight = 500.0
        callMoviesServices(page: currentPage, limit: limitOfItems)
        NoResults.text = "No existen resultados"
        NoResults.isHidden = true
    }
    
    func callMoviesServices(page:Int,limit:Int){
        if NetworkManager.isConnectedToNetwork(){
            NetworkManager.sharedInstance.moviesService(page: page, limit: limit) {[weak self] (response) in
                guard let strongSelf = self else {
                    return
                }
                
                switch response {
                case .error(let serverError) :
                    UIAlertController.showServerErrorAlert(serverError: serverError, view: strongSelf)
                    break
                case .value(let traktMovieResponse) :
                    strongSelf.processMovieResponse(traktMovieResponse: traktMovieResponse)
                    break
                }
            }
        }else{
             UIAlertController.showServerErrorAlert(serverError: .connection, view: self)
        }
    }
    
    func callSearchMoviesServices(keyword:String,page:Int,limit:Int){

        if NetworkManager.isConnectedToNetwork(){
            NetworkManager.sharedInstance.searchService(keyword: keyword,page: page, limit: limit) {[weak self] (response) in
                guard let strongSelf = self else {
                    return
                }
                
                switch response {
                case .error(let serverError) :
                    UIAlertController.showServerErrorAlert(serverError: serverError, view: strongSelf)
                    break
                case .value(let traktResultResponse) :
                    self?.keywordHint = keyword
                    strongSelf.processSearchResponse(traktResultResponse: traktResultResponse)
                    break
                }
            }
        }else{
             UIAlertController.showServerErrorAlert(serverError: .connection, view: self)
        }
    }
    
    func processMovieResponse(traktMovieResponse: [TraktMovieResponse]){
        movieData.append(contentsOf: traktMovieResponse)
        
        tableView.reloadData()
        if movieData.isEmpty{
            self.NoResults.isHidden = false
        }else{
            self.NoResults.isHidden = true
        }
    }
    
    func callImageService(id:String) -> String{
        var imageUrl = ""
        if NetworkManager.isConnectedToNetwork(){
            NetworkManager.sharedInstance.ImageService(id: id) {(response) in
                
                switch response {
                case .error(let serverError) :
//                    UIAlertController.showServerErrorAlert(serverError: serverError, view: strongSelf)
                    break
                case .value(let ImageResultResponse) :
                    imageUrl = ImageResultResponse.moviethumb?.first?.url ?? ""
                    break
                }
            }
        }else{
//             UIAlertController.showServerErrorAlert(serverError: .connection, view: self)
        }
        return imageUrl
    }
    
    func processSearchResponse(traktResultResponse: [TraktResultResponse]){
        if keywordHint != keywordTyping{
            searchData.removeAll()
        }
        searchData.append(contentsOf: traktResultResponse)
        tableView.reloadData()
        if searchData.isEmpty{
            self.NoResults.isHidden = false
        }else{
           self.NoResults.isHidden = true
        }
    }
    
}

extension MoviesController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return searchData.count
        }else{
            return movieData.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieCell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell
        else { fatalError("Invalid Collection cell") }
        
        if isSearching{
            let serchingData = searchData[indexPath.row]
            
            if let title = serchingData.movie.title{
               movieCell.title.text = title
            }else{
                movieCell.title.text = "Titulo No Disponible"
            }
            
            if let year = serchingData.movie.year{
               movieCell.year.text = String(year)
            }else{
                movieCell.year.text = "Año No Disponible"
            }
            
            if let overview = serchingData.movie.overview{
               movieCell.overview.text = overview
            }else{
                movieCell.overview.text = "Descripción No Disponible"
            }
            
        }else{
            let data = movieData[indexPath.row]
            
            movieCell.title.text = data.title
            
            if let title = data.title{
               movieCell.year.text = title
            }else{
                movieCell.year.text = "Titulo No Disponible"
            }
            
            if let year = data.year{
               movieCell.year.text = String(year)
            }else{
                movieCell.year.text = "Año No Disponible"
            }
            
            if let overview = data.overview{
               movieCell.overview.text = overview
            }else{
                movieCell.overview.text = "Descripción No Disponible"
            }
        }
        
        
        return movieCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if isSearching{
            if indexPath.row + 1 == searchData.count {
                currentPageSearch = currentPageSearch + 1
                callSearchMoviesServices(keyword: keywordTyping, page: currentPageSearch, limit: limitOfItems)
            }
        }else{
            if indexPath.row + 1 == movieData.count {
                currentPage = currentPage + 1
                callMoviesServices(page: currentPage, limit: limitOfItems)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension MoviesController: UISearchBarDelegate{
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        keywordTyping = ""
        currentPageSearch = 1
        tableView.reloadData()
        searchBar.text = ""
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NetworkManager.sharedInstance.cancelRequest()
        keywordTyping = searchText.trimmingCharacters(in: .whitespaces)
        if searchText == ""{
            isSearching = false
            keywordTyping = ""
            currentPageSearch = 1
            tableView.reloadData()
        }
        isSearching = true
        callSearchMoviesServices(keyword: keywordTyping, page: currentPageSearch, limit: limitOfItems)
    }
    
}

