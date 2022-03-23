//
//  MovieDetailListDto.swift
//  cleanSwift
//
//  Created by 최민준(Minjun Choi) on 2021/08/05.
//

import Foundation

struct MovieDetailListDto: Codable {
    var adult: Bool?
    var backdropPath: String?
    var belongsToCollection: belongsToCollection?
    var budget: Int?
    var genres: [genres]?
    var homepage: String?
    var id: Int?
    var imdbId: String?
    var originalLanguage: String?
    var originalTitle: String?
    var overview: String?
    var popularity: Double?
    var posterPath: String?
    var productionCompanies: [productionCompanies]?
    var productionCountries: [productionCountries]?
    var releaseDate: String?
    var revenue: Int?
    var runtime: Int?
    var spokenLanguages: [spokenLanguages]?
    var status: String?
    var tagline: String?
    var title: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case adult,budget, genres, homepage, id, overview, popularity,
             revenue, runtime, status, tagline, title, video
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case imdbId = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case spokenLanguages = "spoken_languages"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    struct belongsToCollection: Codable {
        var id: Int?
        var name: String?
        var posterPath: String?
        var backdropPath: String?
        
        enum CodingKeys: String, CodingKey {
            case id, name
            case posterPath = "poster_path"
            case backdropPath = "backdrop_path"
        }
    }
    struct genres: Codable {
        var id: Int?
        var name: String?
        
        enum CodingKeys: String, CodingKey {
            case id, name
        }
    }
    struct productionCompanies: Codable {
        var id: Int?
        var logoPath: String?
        var name: String?
        var originCountry: String?
        
        enum CodingKeys: String, CodingKey {
            case id, name
            case logoPath = "logo_path"
            case originCountry = "origin_country"
        }
    }
    struct productionCountries: Codable {
        var iso31661: String?
        var name: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case iso31661 = "iso_3166_1"
        }
    }
    struct spokenLanguages: Codable {
        var iso6391: String?
        var name: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case iso6391 = "iso_639_1"
        }
    }
}
