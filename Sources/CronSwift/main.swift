let tool = CronSwiftCommand()

do {
    try tool.run()
} catch {
    print("Whoops! An error occurred: \(error)")
}
