# Comprehensive Prompt for Flutter Project Refactoring

Use this prompt to guide AI assistants or development teams when refactoring a Flutter project. The executor must produce a detailed refactoring plan and implementation following the structure defined in the **Output Format** section.

---

## Prompt for Flutter Project Refactoring

Refactor the provided Flutter project structure, code, and architecture based on the following strict guidelines:

### Architectural Requirements

1. **Design Patterns:** Thoroughly review and implement relevant Gang of Four (GoF) design patterns from [SourceMaking Design Patterns](https://sourcemaking.com/design_patterns). Explicitly state which patterns are implemented and where they are applied during the reasoning phase.

2. **Project Structure:** Implement a feature-wise Clean Architecture structure. Each feature module must strictly separate layers:
   - **Presentation/UI** – Screens, widgets, BLoCs
   - **Domain/Business Logic** – Entities, use cases, repository interfaces
   - **Data** – Repository implementations, data sources, DTOs

3. **Industry Standards:** Refactor the entire codebase to align with current Flutter/Dart best practices, emphasizing modularity, testability, and maintainability.

4. **OOP Principles:** Ensure all code rigorously follows Object-Oriented Programming concepts:
   - **Encapsulation** – Private fields, public interfaces, immutable state where appropriate
   - **Inheritance** – Base classes for shared behavior (e.g., base BLoC, base repository)
   - **Polymorphism** – Abstract interfaces, strategy patterns
   - **Abstraction** – Repository interfaces, use case abstractions

### State Management and Responsiveness

1. **State Management:** Use the **BLoC pattern exclusively** for all state management across the application. No `Provider`, `Riverpod`, `GetX`, or `setState` for shared/cross-screen state.

2. **UI Design and Theming:**
   - Define both **Dark Mode** and **Light Mode** themes using Flutter's `ThemeData`
   - Apply themes consistently via `MaterialApp.theme` and `MaterialApp.darkTheme`
   - Ensure the UI is **fully responsive** (mobile, tablet, desktop breakpoints)
   - Make the UI **dynamic** – content and layout adapt based on application state and configuration

### Code Quality and Maintenance

1. **Clean Architecture Enforcement:** Every screen and its logic must strictly adhere to the defined Clean Architecture layers. No business logic in UI; no framework dependencies in domain.

2. **Memory Management:** Implement rigorous checks to prevent memory leaks:
   - All BLoCs must be provided via `BlocProvider` with proper scope and disposal
   - Stream subscriptions must be cancelled in `close()` or via `StreamSubscription.cancel()`
   - `AnimationController`, `TextEditingController`, `ScrollController` must be disposed
   - Avoid retaining `BuildContext` across async gaps

---

## GoF Design Pattern Reference Mapping

| Pattern | Category | Typical Use in Flutter |
|---------|----------|------------------------|
| **Repository** | Structural | Abstract data sources; `AuthRepository`, `ThemeRepository` |
| **Factory** | Creational | Dio client creation, BLoC factory, theme factory |
| **Singleton** | Creational | App-wide services (Dio, analytics) |
| **Strategy** | Behavioral | Theme selection, validation strategies |
| **Observer** | Behavioral | BLoC streams, `ValueNotifier` for theme |
| **Adapter** | Structural | API response → domain model conversion |
| **Facade** | Structural | Simplify complex subsystem APIs |
| **Template Method** | Behavioral | Base BLoC with shared flow, base repository |

---

## Steps (Execution Order)

1. **Analyze Current Structure:** Map existing folders, identify violations of Clean Architecture, mixed concerns, and anti-patterns.

2. **Design Pattern Mapping:** For each feature/module, select appropriate GoF patterns. Document: Pattern → Class/Module → Rationale.

3. **Implement Clean Architecture:**
   - Create `domain/` (entities, use cases, repository interfaces)
   - Create `data/` (repositories, data sources, DTOs, mappers)
   - Refactor `presentation/` (screens, widgets, BLoCs)
   - Ensure dependencies point inward (UI → Domain ← Data)

4. **State Management Integration:** Replace any non-BLoC state (Provider, setState, etc.) with BLoC. Ensure `BlocProvider`/`MultiBlocProvider` scoping is correct.

5. **Theming Implementation:** Define `AppTheme.lightTheme` and `AppTheme.darkTheme`. Apply via `MaterialApp`. Support dynamic switching and persistence.

6. **Responsiveness Check:** Use `LayoutBuilder`, `MediaQuery`, breakpoints (e.g., 600, 840, 1200), and `ResponsiveBuilder`-style widgets for layout adaptation.

7. **Memory Leak Auditing:** Review every BLoC `close()`, stream subscription, and controller disposal. Add `mounted` checks before post-async navigation/snackbars.

---

## Output Format

The output **MUST** be structured as follows:

### 1. Reasoning and Analysis (Mandatory)

- **Architectural choices:** Why feature-wise structure, why Clean Architecture layers
- **Design patterns selected:** Table mapping Pattern → Location → Purpose
- **OOP adherence:** How encapsulation, inheritance, polymorphism, abstraction are applied
- **Memory management:** Summary of disposal points, stream handling, and leak-prevention measures

### 2. Refactored Project Structure

```
lib/
├── core/                    # Shared kernel
│   ├── domain/
│   ├── data/
│   └── theme/
├── features/
│   ├── auth/
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   ├── dashboard/
│   └── ...
└── config/
```

(Provide the full proposed directory tree with brief annotations.)

### 3. Summary of Changes

- BLoC adoption: screens converted, shared vs feature-scoped BLoCs
- Theming: light/dark implementation, persistence, dynamic switching
- Responsiveness: breakpoints used, layout strategy
- Clean Architecture: layer compliance per feature
- Memory management: disposal audit results

---

## Notes

- [SourceMaking Design Patterns](https://sourcemaking.com/design_patterns) is the definitive reference for pattern implementation.
- BLoC usage must be **comprehensive** – no other state management for app-wide or cross-screen state.
- Every screen must respect Clean Architecture layer separation.
- Prefer `flutter_bloc` and `bloc` packages for BLoC implementation.
