//
//  Networking.swift
//  MovieAppBS
//
//  Created by Sohanur Rahman on 19/4/23.
//

import Foundation



extension HomeVC {
    func getMovieData(query: String){
        
        let url = ("https://api.themoviedb.org/3/search/movie?api_key=3c78016499e73f3df0a20dc886b450e0&query=" + query + "&page=" + "\(page)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        print("Requested URL: \(url)")
        
        guard let apiURL = URL(string: url) else { return print("URL Error") }
        
        
              
        URLSession.shared.dataTask(with: apiURL) { (data, response, error) in
            guard let obtainedData = data else { return print("No data")}
            do {
                let movieApiData = try JSONDecoder().decode( MovieResponseModel.self, from: obtainedData)
                self.onSuccessGetData(movieData: movieApiData)
                print("Hey Sohan We Found Movie List Of: \(movieApiData)")
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func onSuccessGetData(movieData: MovieResponseModel){
        movieResponseModel = movieData
        
        if page == 1{
            movieDataResponseModel.removeAll()
        }
        
        movieDataResponseModel.append(contentsOf: movieResponseModel.results ?? [MovieDataResponseModel]())
        DispatchQueue.main.async {
            self.movieCollectionView.reloadData()
        }
    }
    
    func onFailed(){
        
    }
}
