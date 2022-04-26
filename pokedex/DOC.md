# Pokedex 

### Written by Abdul-Jemeel

The implementation and architecture of the code follow the Clean Architecture and Solid Test-Driven development approach as proposed by **Uncle Bob** and adapted for flutter by **ResoCoder**, which simply says code must follow the SOLID principles and separation of concerns.

There is a complete decoupling of the three core layers of the app, which are the **Data, Domain, and Presentation layers**. The data layer deals with data handling and APIs, relying on the contract of functionalities declared in the Domain layer. The domain layer contains the core business logic of the app and handles the relationship between user interactions and data. Lastly, the presentation layer deals only with the presentation of data and user input. A service locator was used to couple the three layers together using dependency injections.

As I wrote the code with solid TDD principles, every core business logic of the app and error handling was unit tested, using the flutter_test and the mockito package for mocking.
 
#### Project dependencies
#*UI

string_extensions:  ^0.4.4    // for string manipulations

flutter_reorderable_grid_view:  ^2.1.0.  // for the pokemon grid layout

cached_network_image:  ^3.2.0.  // for displaying the pokemons images

flutter_bloc:  ^7.0.0.    // for state management and presentation logic

flutter_svg:  ^1.0.3.  // for rendering svg files in the ui

  

#* core

dartz:  ^0.10.1.   // this is a functional programming package that helps us handle errors properly with the help of the Either<L,R> that can return two different results based on actions and response.

equatable:  ^2.0.3. // for app wide object comparisons

#* service locator.

get_it:  ^7.2.0.  // for dependency injection

#* database

hive:  ^2.1.0. // the hive database for local data storage

hive_flutter:  ^1.1.0. // the flutter hive package for working with the hive db

#* remote data source

http:  ^0.13.4  // for remote api calls

internet_connection_checker:  ^0.0.1+3   // for checking network states

#### Dev dependencies


build_runner:  ^2.1.10. // for code generation of the mock classes

flutter_lints:  ^1.0.0. // a beautiful default package for linting

flutter_test:    //the flutter test package

mockito:  ^5.1.0.  // for mocking of various objects during testing


Thank you as you check and review my submission for technical evaluation for the role of Software Engineer (Flutter/mobile) at your amazing company. 