//
//  NetworkClient.swift
//  PopularMovies
//
//  Created by David Jose on 01/05/18.
//  Copyright © 2018 VinuDavidJose. All rights reserved.
//

import UIKit


class NetworkClient: NSObject {
static let sharedClient = NetworkClient()
    enum MoviesError: Error {
        case NoResponse
        case ErrorResponse
    }
    
    
    
    //MARK: Call Movies API
    
    func getMovieListFromAPI(page:Int = 1, completion:@escaping ([Movie]?, Error?) -> Void) {
        let urlComp = NSURLComponents(string:MovieEndpoints.popular)!
        var items = [URLQueryItem]()
        items.append(MovieEndpoints.defaultParams)
        items.append(URLQueryItem(name:MovieConstant.page, value:String(page)))
        items = items.filter{!$0.name.isEmpty}
        if !items.isEmpty {
            urlComp.queryItems = items
        }
        
    guard let gitUrl = urlComp.url else { return }
    URLSession.shared.dataTask(with: gitUrl) { (data, response
    , error) in
    guard let data = data else { return }
    do {
    let decoder = JSONDecoder()
    let movieData = try decoder.decode(movieList.self, from: data)
    completion(movieData.results, nil)
    } catch let err {
        print(err)
        completion([],MoviesError.ErrorResponse)

    }
    }.resume()
    
}
}
