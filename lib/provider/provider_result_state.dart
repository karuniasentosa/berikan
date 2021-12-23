/// A result state to state a provider status (obvs.)
enum ProviderResultState {
  /// State that a provider is processing data
  loading,

  /// State that a provider processed the request but no data was received
  noData,

  /// State that a provider processed the request and all data was received
  hasData,

  /// State that a provider processed the request and the response was an error
  error,

  /// State that a provider cannot communicate to the Internet because device has no connection
  noConnection,
}
