//
//  NetworkManager.swift
//  CombineTableView
//
//  Created by Bharat Lal on 26/03/23.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    private let url = "https://api.github.com/users/bharatlal087/repos"

    func fetch<T: Decodable>(with type: T.Type) async throws -> [T] {
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            return try JSONDecoder().decode([T].self, from: data)
        case 404:
            throw NetworkError.notFound
        default:
            throw NetworkError.unknown
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case notFound
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid response"
        case .notFound: return "Resource not found"
        case .unknown: return "Unknown error"
        }
    }
}
