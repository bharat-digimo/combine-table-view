//
//  RepositoryViewModel.swift
//  CombineTableView
//
//  Created by Bharat Lal on 26/03/23.
//

import Foundation
import Combine

class RepositoryViewModel {
    private var cancellables = Set<AnyCancellable>()
    @Published var repositories = [Repository]()
    
    func getRepositories() {
        NetworkManager.shared.fetch(with: Repository.self)
            .sink { complition in
                switch complition {
                case .failure(let error):
                    print("finished with error:  \(error.localizedDescription)")
                case .finished:
                    print("Finished successfully")
                }
            } receiveValue: { [weak self] repositories in
                self?.repositories = repositories
            }
            .store(in: &cancellables)
    }
}
