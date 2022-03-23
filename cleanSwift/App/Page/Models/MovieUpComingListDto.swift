//
//  MovieUpComingListDto.swift
//  cleanSwift
//
//  Created by 최민준(Minjun Choi) on 2021/08/03.
//

import Foundation

struct MovieUpComingListDto: Codable {
    
    var dates: Dates?
    var page: Int?
    var results: [Results]?
    var totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results, dates
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    struct Dates: Codable {
        var maximum: String?
        var minimum: String?
        
        enum CodingKeys: String, CodingKey {
            case maximum = "maximum"
            case minimum = "minimum"
        }
    }
    
    struct Results: Codable {
        var adult: Bool?
        var backdropPath: String?
        var genreIds: [Int]?
        var id: Int?
        var originalLanguage: String?
        var originalTitle: String?
        var overview: String?
        var popularity: Double?
        var posterPath: String?
        var releaseDate: String?
        var title: String?
        var video: Bool?
        var voteAverage: Double?
        var voteCount: Int?
        
        enum CodingKeys: String, CodingKey {
            case adult
            case backdropPath = "backdrop_path"
            case genreIds = "genre_ids"
            case id
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case overview, popularity
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case title, video
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
        }
    }
}
