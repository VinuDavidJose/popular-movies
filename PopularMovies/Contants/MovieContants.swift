//
//  MovieContants.swift
//  PopularMovies
//
//  Created by David Jose on 01/05/18.
//  Copyright © 2018 VinuDavidJose. All rights reserved.
//

import Foundation



struct MovieEndpoints {
    private static let basePath = "https://api.themoviedb.org/3/"
    private static let popularPath = "discover/movie"
    private static let imageBaseUrl = "https://image.tmdb.org/t/p"
    private static let APIKey = "2ccf7bafbad0ca13e9aeae2db6696e7e"
    private static let w200 = "/w200"
    private static let w400 = "/w400"

    static var popular: String {
        return basePath + popularPath
    }
    static var ImageBase: String {
        return imageBaseUrl + w200
    }
    static var largeImageBase: String {
        return imageBaseUrl + w400
    }
    static var defaultParams:URLQueryItem {
       return URLQueryItem(name: "api_key", value: APIKey)
    }
   
}
struct MovieConstant {
    static let page =  "page"
    static let segueListDetailIdentifier = "goDetail"
}

