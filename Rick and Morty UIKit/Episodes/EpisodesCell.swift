//
//  EpisodesCell.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/11/22.
//

import UIKit
import Combine
import Resolver

class EpisodesCell {
    private var isLoadingPage = false
    
    let isFirstLoadingPageSubject = CurrentValueSubject<Bool, Never>(true)
    
    let episodesSubject = CurrentValueSubject<[Episode], Never>([])
    var currentSearchQuery = ""
    var currentPage = 1
    var canLoadMorePages = true

    @LazyInjected private var networkService: NetworkService
    
    func getEpisodes() async {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        isLoadingPage = true
        let request = EpisodesRequest(name: currentSearchQuery, page: currentPage)
        do {
            let episodeResponseModel = try await networkService.fetch(request)
            isLoadingPage = false
            episodesSubject.value.append(contentsOf: episodeResponseModel.results)
            if episodeResponseModel.pageInfo.pageCount == currentPage {
                canLoadMorePages = false
                return
            }
            currentPage += 1
            isFirstLoadingPageSubject.value = false
        } catch {
            if let apiError = error as? APIError {
                print(apiError.errorMessage)
            }
            print(error.localizedDescription)
        }
    }
}

