import Foundation

final class PatchImporter {
    func load(from path: String, password: String?) throws -> Data {
        return try Data(contentsOf: URL(fileURLWithPath: path))
    }

    func parse(manifest raw: Data) throws -> Patch {
        let decoder = JSONDecoder()
        return try decoder.decode(Patch.self, from: raw)
    }
}