# SpaceXLaunches

This fetches SpaceX launches from the year 2020 (using V3 API as v4 had format issues) and displays them in a list. App fetches/caches image data provided via launch data, and displays icons next to respective launch names. On scroll, launches are auto-paginated. When a launch item is selected, a rudimentary telemetry view is shown -- I initially thought the data was more robust there. 

### Language

Swift

### Dependendencies

* KingFisher (Image Downloads/Caching)

### Dependency Injection

We use Resolver Dependency Injection (Service Locator Pattern) for a few reasons: 
1. NetworkProvider is used between multiple services (or can be), and we're able to avoid boilerplate using DI. 
2. For ease of tesability. We're easily able to re-register a service in unit tests using a mock NetworkProvider (see SpaceXLaunchTests).

### Architecture
* This project uses fairly standard MVVM architecture, however Views/ViewModels are 1:1 with view (single page application). If the application had a third view (e.g. Pin Entry or details) we'd reconsider as responsibility would be broken up for that feature set. This was also for the sake of time.

* Navigation Heirarchy is simple, since there's no navigation experience in the app per-se, more of an info window. If there was a more complex UX, we'd have to consider XCoordinator, SwiftCoordinator, or ComposableArchitecture to navigate a trickier hierarchy. 

* Reused services are injected via ServiceLocator or Resolver patterns. There are of course drawbacks to overusing shared resources -- to break this up the real world we'd register services with identifiers specific to their use.

### Setup

- Run the app.
- Notice that launch items are listed after fetch.
- Scroll and you'll see that we auto-paginate.
- Launch items should be marked based on whether a. launch succeeded and b. land succeeded (info shown in the telemetry header is based on this).
- Select an item with a Launch, but without a Landed marker, you should only see one dot. If Landed, you'll see more points.
- Run Tests.
