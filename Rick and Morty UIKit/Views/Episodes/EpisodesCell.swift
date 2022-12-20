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
    let episodesSubject = CurrentValueSubject<[EpisodeResult], Never>([])
    var currentName = ""
    var currentPage = 1
    var canLoadMorePages = true

    @LazyInjected private var networkService: NetworkService
    
    func getEpisodes() async {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        isLoadingPage = true
        let request = EpisodesRequest(name: currentName, page: currentPage)
        do {
            let episodeResponseModel = try await networkService.fetch(request)
            isLoadingPage = false
            episodesSubject.value.append(contentsOf: episodeResponseModel.results)
            if episodeResponseModel.pageInfo.pages == currentPage {
                canLoadMorePages = false
                return
            }
            currentPage += 1
            isFirstLoadingPageSubject.value = false
        } catch {
            if error != nil {
                print(error)
            }
            print(error.localizedDescription)
        }
    }
}

