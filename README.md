## Todo App

This is an iOS todo app with Firebase as a backend. This is used in conjunction with another [React web app](https://github.com/muhdmirzamz/TodoAppReact) I'm working on. Both of these projects connect to the same Firebase database.


### Features

**General:**
- User login screen
- User sign up screen
- You can sign up as a user

**Lists:**
- You can retrieve lists
- You can delete a list
- You can add lists

**Todos**
- You can create todos


### Changelog

18 July 2021:
- You can now dismiss the keyboard by tapping on the screen after entering your login credentials

5 June 2021:
- Items are now ordered by order (You can move them around and it will remember the index)
- Added a sort button to sort by timestamp
- Fixed a bug that resets the timestamp when a new todo is created

3 June 2021:
- You can add items to a list
- Items show up latest first


2 June 2021:
- Lists now show up as the latest first on top
- Refactored code by adding a class to hold list details

17 April 2021:
- You can now sign up
- List title now show up in Navigation bar title when viewing list items

12 March 2021:
- You can get lists
- You can create new lists
- Refactored code according to database restructure

14 February 2021:
- You can now delete an item by activating deletion mode in tableview
- Code restructure: Used 2 arrays for keys and items
- Fixed: Items do not keep getting inserted into the array on page load

10 February 2021:
- Refactored item event listening code to listen for addition and deletion of items

9 February 2021:
- You are now able to retrieve items and listen for changes

7 February 2021:
- Implemented a Signin page

17 July:
- Connected project to Firebase

16 July:
- First commit

### Technologies used
- Swift
- Firebase
- Cocoapods

### INSTALL
Be sure to run ```pod install``` before anything else.
