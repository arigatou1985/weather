In this project, the following requirements and non-fuctional points have been completed.
- ✅ App has to contain exactly two screens
- ✅ The first screen displays by default the temperature at the current location or temperature for the user selected location.
- ✅ The second screen contains a search bar where users can search for the location. If the location gets selected, the first screen displays the temperature there.
- ✅ The app has to rely on network data. Don't provide offline mode and use default caching. If there are network issues, handle errors.
- ✅ For implementation you can use a tech stack and architecture of your choice.
- ✅ Ensure you write your code with testing in mind.
- ✅ Following SOLID principles and conscious use of design patterns
- ✅ README file in your repository to share thoughts on your design decisions and trade-offs you made.
- ✅ Test coverage
- ✅ Dark/Light mode support
- ✅ Forecast react on location change
- ✅ Supporting multiple temperature units

I implemented a lightweight clean architecture in the MVVM flavor. SOLID prinples have always been the general guideline for me. I have added a few unit tests which cover about 90% over business logic intensive components, including domain objects and view models. No UI automation tests were done in this assignment, for the sake of simplicity.
