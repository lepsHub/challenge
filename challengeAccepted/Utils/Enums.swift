//
//  Enums.swift
//  challengeAccepted
//
//  Created by Mac on 12/29/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
enum ExtraParameter: String {
    case QUERY = "query="
    case FULL = "extended=full"
    case PAGE = "page="
    case LIMIT = "limit="
}

enum FilterType: String {
    case POPULAR = "/popular"
    case MOVIE = "/movie"
}

enum UseCase: String {
    case MOVIES = "/movies"
    case SEARCH = "/search"
}

struct APIQuery {
    static let extra = "?"
    static let and = "&"
    static let getPopularMovies = UseCase.MOVIES.rawValue + FilterType.POPULAR.rawValue + extra + ExtraParameter.FULL.rawValue
    static let searchMovies = UseCase.SEARCH.rawValue + FilterType.MOVIE.rawValue + extra + ExtraParameter.QUERY.rawValue
}
