//
//  Movie.swift
//  PopularMovies
//
//  Created by David Jose on 01/05/18.
//  Copyright © 2018 VinuDavidJose. All rights reserved.
//

import UIKit

class Movie: Codable {
    let id: Int32!
    let poster_path: String?
    let overview: String?
    let vote_average: Float?
    let title: String?

}
class movieList: Codable {
    let results :[Movie]?
    
}


