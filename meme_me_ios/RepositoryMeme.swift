import Foundation

final class MemeRepository {
	static let sharedInstance = MemeRepository()
	static private(set) var memes: [Meme] = []
	
	// MARK: - Inits
	private init() {}
	
	static func save(model meme: Meme) {
		memes.append(meme)
	}
}

