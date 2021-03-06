//
//  AppCoordinator.swift
//  Cima+
//
//  Created by Kerolles Roshdi on 3/29/21.
//

import UIKit
import XCoordinator

enum AppRoute: Route {
    case nowPlaying
    case topRated
    case search
    case movieDetails(id: Int)
    case dismiss
}

class AppCoordinator: TabBarCoordinator<AppRoute> {
    
    // MARK: Initialization
    init() {
        
        // app tab bar
        let appTabBarController = TextyTabBarController()
        super.init(rootViewController: appTabBarController, initialRoute: .nowPlaying)
        
        // now playing
        let nowPlaying = NowPlayingVC(
            viewModel: BrowseVM(
                router: weakRouter,
                useCase: BrowseUseCase(moviesRepository: MoviesRepositoryImpl(), browsing: .nowPlaying)
            )
        )
        let nowPlayingBarItem = TextyTabBarItem(title: "Now Playing", image: #imageLiteral(resourceName: "icon-play"), tag: 0)
        nowPlayingBarItem.color = DesignSystem.Color.nowPlaying.UIColor
        nowPlaying.tabBarItem = nowPlayingBarItem
        
        // top rated
        let topRated = TopRatedVC(
            viewModel: BrowseVM(
                router: weakRouter,
                useCase: BrowseUseCase(moviesRepository: MoviesRepositoryImpl(), browsing: .topRated)
            )
        )
        let topRatedBarItem = TextyTabBarItem(title: "Top Rated", image: #imageLiteral(resourceName: "icon-like"), tag: 1)
        topRatedBarItem.color = DesignSystem.Color.topRated.UIColor
        topRated.tabBarItem = topRatedBarItem
        
        // search
        let search = SearchVC(
            viewModel: SearchVM(
                router: weakRouter,
                useCase: SearchUseCase(moviesRepository: MoviesRepositoryImpl())
            )
        )
        let searchBarItem = TextyTabBarItem(title: "Search", image: #imageLiteral(resourceName: "icon-search"), tag: 2)
        searchBarItem.color = DesignSystem.Color.search.UIColor
        search.tabBarItem = searchBarItem
        
        
        appTabBarController.viewControllers = [nowPlaying, topRated, search]
    }
    
    // MARK: Overrides
    
    override func prepareTransition(for route: AppRoute) -> TabBarTransition {
        switch route {
        case .nowPlaying:
            return .select(index: 0)
        case .topRated:
            return .select(index: 1)
        case .search:
            return .select(index: 2)
        case .movieDetails(let id):
            let movieDetails = MovieDetailsVC(
                viewModel: MovieDetailsVM(
                    router: weakRouter,
                    useCase: MovieDetailsUseCase(movieID: id, moviesRepository: MoviesRepositoryImpl())
                )
            )
            movieDetails.modalPresentationStyle = .overFullScreen
            return .present(movieDetails)
        case .dismiss:
            return .dismiss()
        }
    }
    
}
