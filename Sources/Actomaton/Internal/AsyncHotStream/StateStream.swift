/// Stateful hot-stream where `projectedValue` (stream) emits over `currentValue` change.
///
/// - FIXME: `where Element: Sendable` will cause crash for some reason as of Swift 5.5.1.
@propertyWrapper
struct StateStream<Element> /* where Element: Sendable */
{
    private var currentValue: Element
    private let yield: (Element) -> Void
    private let stream: AsyncStream<Element>

    init(wrappedValue initialValue: Element)
    {
        let (stream, yield) = AsyncStream<Element>.makeNonTerminalHotStream()
        self.stream = stream
        self.yield = { _ = yield($0) }
        self.currentValue = initialValue
    }

    var wrappedValue: Element
    {
        get {
            self.currentValue
        }
        set {
            self.currentValue = newValue
            self.yield(newValue)
        }
    }

    var projectedValue: AsyncStream<Element>
    {
        AsyncStream { [currentValue, stream] continuation in
            let task = Task {
                continuation.yield(currentValue)

                for await value in stream {
                    continuation.yield(value)
                }

                continuation.finish()
            }

            continuation.onTermination = { @Sendable _ in
                task.cancel()
            }
        }
    }
}
