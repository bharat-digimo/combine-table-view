//
//  RepositoryViewModel.swift
//  CombineTableView
//
//  Created by Bharat Lal on 26/03/23.
//

import Combine
import Foundation

@MainActor
final class RepositoryViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    private var cancellables = Set<AnyCancellable>()

    func getRepositories() async {
        do {
            let repos = try await NetworkManager.shared.fetch(with: Repository.self)
            repositories = repos
        } catch {
            print("Error fetching repositories: \(error.localizedDescription)")
        }
    }
}
