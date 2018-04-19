import Foundation

final class RepositoryMeme {
	static let sharedInstance = RepositoryMeme()
	static private(set) var memes: [Meme] = []
	
	// MARK: - Inits
	private init() {}
	
	static func save(model meme: Meme) {
		memes.append(meme)
	}
}

