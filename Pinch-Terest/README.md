//
//  README.md
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 07/10/2020.
//

### Endpoints
Albums and photos endpoint:
http://testapi.pinch.nl:3000/albums
http://testapi.pinch.nl:3000/photos

For filter use url query parameters:
Example: photos?albumId=2&_page=1


### The Project

The project was built using MVVM and RxSwift to communicate between our ViewModel and ViewController

For the network layer was used Moya framework
For the image fetch we used KingFisher framework

For some situation we also used the native iOS pattern for reactive data using Result and customizing some operator

For the navigation we used Router pattern, except for the initial one that was used the first one from our Storyboard

#### Project Structure

It's was adopted a structure by modules

-> routes -> All our app routers files and utilities 
-> common -> Utilities in general that is not specific and can be used for the entire project
-> model -> Data Model 
-> viewmodel -> View model used by the project
-> view -> The views used by the project
-> network -> Our network layer

#### Testing

For the test purpose only one View Model was tested, as the purpose here is to evaluate the code, style and pattern.

Then the choice was to make a good test scenarios to show the code done and how other parts can achieve the same


### Improvements

Thinking about improvements that could be done the first one to think is Dependency Injection

For this purpose would be used Swinject as tool to achieved this.


