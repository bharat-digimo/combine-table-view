//
//  NetworkManager.swift
//  CombineTableView
//
//  Created by Bharat Lal on 26/03/23.
//

import Combine
import Foundation


class NetworkManager {
    static let shared = NetworkManager()
    private init(){}
    
    private var cancellables = Set<AnyCancellable>()
    private let url = "https://api.github.com/users/bharat-digimo/repos"
    
    func fetch<T: Codable>(with type: T.Type) -> Future<[T], Error> {
        return Future<[T], Error> { [weak self] promise in
            guard let self = self, let url = URL(string: self.url) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) in
                    guard let res = response as? HTTPURLResponse, 200...299 ~= res.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: [T].self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink { complition in
                    if case let .failure(error) = complition {
                        switch error {
                        case let parsingError as DecodingError:
                            promise(.failure(parsingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                } receiveValue: { promise(.success($0)) }
                .store(in: &self.cancellables)
        }
    }
}


enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}
