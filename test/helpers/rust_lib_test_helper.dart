// RustLib Test Helper
// Provides utilities for handling RustLib in test environment

/// Sets up test environment to handle RustLib dependencies
///
/// This function provides a no-op setup for RustLib in tests.
/// The actual RustLib functionality is mocked at the service level
/// (e.g., SalesBridgeService) rather than at the API level.
void setupMockRustLib() {
  // No-op: RustLib mocking is handled at service level
  // This function exists for consistency with test setup patterns
}

/// Disposes RustLib after tests
///
/// Call this in your test tearDown() method to clean up resources.
void disposeMockRustLib() {
  // No-op: Cleanup is handled at service level
}

/// Test configuration constants
class TestConfig {
  /// Default timeout for regular tests
  static const Duration defaultTimeout = Duration(seconds: 15);

  /// Timeout for widget tests (optimized)
  static const Duration widgetTestTimeout = Duration(seconds: 5);

  /// Timeout for integration tests
  static const Duration integrationTestTimeout = Duration(seconds: 30);

  /// Timeout for Dashboard tests (optimized from 45s to 10s)
  static const Duration dashboardTestTimeout = Duration(seconds: 10);
}
