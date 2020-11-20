protocol WriteProtocol {
    func DisplayAnError(subcommand: String, keywords: String?)
    func WriteDiactionary(keywords: String?, wordForWrite: String?, dictionary: [String: [String: String]]?)
}