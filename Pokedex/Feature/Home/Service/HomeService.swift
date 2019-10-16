//
//  HomeService.swift
//  Pokedex
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Moya

public enum HomeService {
    case pokemons(offset: Int, limit: Int)
    case detail(url: String)
}

extension HomeService: TargetType, AccessTokenAuthorizable {
    public var baseURL: URL {
        switch self {
        case let .detail(url):
            return URL(string: url)!
        default:
            return URL(string: K.Url.base)!
        }
    }

    public var path: String {
        switch self {
        case .pokemons:
            return "pokemon"
        case .detail:
            return ""
        }
    }

    public var method: Moya.Method {
        switch self {
        case .pokemons, .detail:
            return .get
        }
    }

    public var task: Task {
        switch self {
        case let .pokemons(email, password):
            return .requestParameters(parameters: ["offset": email, "limit": password], encoding: URLEncoding.queryString)
        case .detail:
            return .requestPlain
        }
    }

    public var headers: [String: String]? {
        switch self {
        case .pokemons, .detail:
            return ["Content-Type": "application/json; charset=utf-8"]
        }
    }

    public var authorizationType: AuthorizationType {
        switch self {
        case .pokemons, .detail:
            return .none
        }
    }

    public var validationType: ValidationType {
        switch self {
        case .pokemons, .detail:
            return .successCodes
        }
    }

    public var sampleData: Data {
        switch self {
        case .pokemons:

            guard let path = Bundle.main.path(forResource: MockJson.PokemonList.rawValue, ofType: "json") else {
                return "".data(using: String.Encoding.utf8)!
            }
            let url = URL(fileURLWithPath: path)
            do {
                return try Data(contentsOf: url, options: .mappedIfSafe)
            } catch {
                return "".data(using: String.Encoding.utf8)!
            }

        case .detail:
            guard let path = Bundle.main.path(forResource: MockJson.PokemonDetail.rawValue, ofType: "json") else {
                return "".data(using: String.Encoding.utf8)!
            }
            let url = URL(fileURLWithPath: path)
            do {
                return try Data(contentsOf: url, options: .mappedIfSafe)
            } catch {
                return "".data(using: String.Encoding.utf8)!
            }
        }
    }
}
