# Contributing to Securx

We welcome contributions to the `securx` plugin! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your help is greatly appreciated.

Please take a moment to review this document to ensure a smooth contribution process.

## How to Contribute

### Reporting Bugs

If you find a bug, please open an issue on our [GitHub Issue Tracker](https://github.com/Rgada28/securx/issues). When reporting a bug, please include:

- **A clear and concise description** of the bug.
- **Steps to reproduce** the behavior.
- **Expected behavior** vs. **actual behavior**.
- **Screenshots or video recordings** if applicable.
- Your **environment details**:
  - Flutter version (`flutter doctor -v`)
  - Operating System (iOS/Android version)
  - Device model (physical device or simulator/emulator)
  - Any relevant logs or stack traces.

### Suggesting Enhancements / Features

We'd love to hear your ideas for improving `securx`! Please open an issue on the [GitHub Issue Tracker](https://github.com/Rgada28/securx/issues) and describe:

- **The problem** you're trying to solve.
- **Your proposed solution** or feature idea.
- **Why this feature is important** for the plugin.
- Any **alternative solutions** you've considered.

### Submitting Pull Requests

We welcome pull requests for bug fixes, new features, and improvements. To submit a pull request:

1.  **Fork** the `securx` repository.
2.  **Clone** your forked repository to your local machine.
    ```bash
    git clone [https://github.com/YOUR_USERNAME/securx.git](https://github.com/YOUR_USERNAME/securx.git)
    ```
3.  **Create a new branch** for your changes.
    ```bash
    git checkout -b feature/your-feature-name-or-bugfix/issue-number
    ```
    (e.g., `feature/screenshot-protection` or `bugfix/unresolved-reference-123`)
4.  **Make your changes.**
    - Ensure your code adheres to the existing coding style.
    - Add or update comments as necessary.
    - Write **unit and integration tests** for your changes.
    - Update the `README.md` if your changes affect the public API or usage.
    - Add an entry to `CHANGELOG.md` under an "Unreleased" section, describing your changes.
5.  **Test your changes thoroughly.**
    - Run `flutter test`
    - Run `flutter analyze`
    - Run `flutter format .`
    - For Android: Open `example/android` in Android Studio and ensure it builds and runs correctly.
    - For iOS: Open `example/ios/Runner.xcworkspace` in Xcode and ensure it builds and runs correctly. Run `pod lib lint securx.podspec` in the `ios` directory to validate your podspec and native code.
6.  **Commit your changes** with a clear and concise commit message.
    ```bash
    git commit -m "feat: Add new feature (closes #123)"
    # or "fix: Resolve bug in X (fixes #123)"
    ```
7.  **Push your branch** to your forked repository.
    ```bash
    git push origin feature/your-feature-name-or-bugfix/issue-number
    ```
8.  **Open a Pull Request** on the `securx` repository's main branch.
    - Provide a clear title and description for your PR.
    - Reference any related issues (e.g., `Closes #123`).

## Code Style

- **Dart:** Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines. Use `flutter format .` to automatically format your code.
- **Kotlin (Android):** Adhere to the [Kotlin Coding Conventions](https://kotlinlang.org/docs/coding-conventions.html).
- **Swift/Objective-C (iOS):** Follow standard Swift/Objective-C coding practices.

Thank you for contributing to `securx`!
