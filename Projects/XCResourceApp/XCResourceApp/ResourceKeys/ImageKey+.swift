import Foundation

extension ImageKey {
    static func componentIcon(for type: ComponentType) -> ImageKey {
        switch type {
        case .blog:
            return .component_blog
        case .book:
            return .component_book
        case .date:
            return .component_date
        case .link:
            return .component_link
        case .movie:
            return .component_movie
        case .news:
            return .component_news
        case .place:
            return .component_place
        }
    }
}
