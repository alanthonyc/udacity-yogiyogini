# YogiYogini
> *YogiYogini, The Instructor's Toolkit*

This is an iOS app that provides yoga instructors with tools for organizing, conducting, and recording yoga class sessions that they teach.

**Table of Contents**

* Project Overview
    - Selecting YogiYogini
* Installation
    - Getting the Code
    - Running the Code
* Usage
    - Information Detail
    - App Execution
* Udacity Notes
    - Exceed Requirements
    - Additional Features

## Project Overview
This project was developed to satisfy the fifth and final requirement for graduating from Udacity's iOS Nanodegree program (as of the spring of 2016). For this final project, the student is directed to select a project of their own choosing and subsequently design and develop an app that satisfies the course's grading rubric.

### Selecting YogiYogini
For this project, I elected to design an app that would assist my sister in the execution of her duties as a (part-time) yoga instructor.

The initial implementation of this app includes basic features that make the app usable as a teaching companion app for my sister. At the same time, the initial implementation will aim to satisfy all of the requirements put forth by the iOS Nanodegree program in the grading rubric.

Subsequent interations of this app will further refine the included features, thereby making it suitable to be deployed into the Apple app store for general distribution and sale.

## Installation

### Requirements
* Xcode 7.3
* iOS 9.3 SDK
* a Mac that runs the above (OS X 10.11.4)

### Getting the Code
Download or clone the repository using your preferred method. The following command for cloning the repository is an easy way to do this:

    git clone git@github.com:alanthonyc/yogiyogini.git

### Running the Code
Open `YogiYogini.xcodeproj` with Xcode 7.3. You can then run it on the simulator from within Xcode.

## Usage
The __YogiYogini__ app lets the instructor store information about her students and her class sessions as they take place.

### Information Detail
#### Student Information
The following information is stored for each student:

* Name
* Date Joined
* Sessions Attended
* Active Status
* Student Type

#### Session Information
The following information is stored for each class session:

* Venue - selected from venues provided by the foursquare api
* Date and Time Started
* Date and Time Ended
* Attending Students
* Outside Temperature - from the openweathermap.org api

### App Execution
The app is based on a tab bar view with three tabs. 

* **Class Tab**– middle, the main view, used for controlling and recording class sessions.
* **Students Tab** – right, used for creating the master list of students
* **Sessions Tab** - left, used to review past class sessions

#### Primary Tab - Class
The app launches into the middle tab, `Class`. Tapping the `Check-In` button allows the user to check-in to a yoga venue from a list provided by Foursquare.

Once the user has checked-in, then the app considers the class in session and begins recording the duration of the session.

* the `Check-In` button is replaced by a `Pause` button.
* the session start time is displayed
* the outside temperature is displayed (if available)
* the venue name and address are displayed

The user/instructor can now record which students are attending the session by tapping the `+` button on the left, above the tableview. The list presented when this button is tapped is created in the tab to the right, the *Students* tab.

When the session is complete, the instructor taps the `Pause` button and may choose to save the session by following the subsequent prompts. (The instructor may also choose to delete/forget the session from within this area of the app.)

#### Students Tab
The tab on the right is a roster of students associated with the yoga instructor. Tapping the `+` button on the top right allows the instructor to add a student to her roster.

Only students already on this roster can be marked as attending a class session.

#### Sessions Tab
The tab on the left is a list of class sessions that the instructor has saved to the app. Tapping on each session shows details regarding that session.

* the venue
* the date and duration
* the list of attending students
* the outside temperature

## Udacity Notes
This app is being submitted with the expectation that it meets and exceeds all the given requirements in the rubric. Sorry if it doesn't!

### Exceed Requirements
Additional detail on meeting the *“exceed requirements”* of the specs:

1. **Customized _UIControl_ Subclass** – a subclass of UIButton, `LongPressButton`, was created. This subclass has a built-in *longpress gesture recognizer* and is designed to be reusable. It's implemented in the `Pause` button of the app. A long press on the `Pause` button allows the user to skip the confirmation steps and immediately save the class session.

2. **Multiple Networked API** – this application accesses two external API: [FourSquare](https://developer.foursquare.com/docs/venues/search) for the venues list and [OpenWeatherMap](http://openweathermap.org/api) for the weather.

3. **A Sophisticated Data Model** – this application contains three model entities (Student, Session, and Venue). These entities have various relations with each other, mostly centering around Session.

### Additional Features
There are extra features that have been given placeholders in the app, but are not yet functional. These do not interfere with fulfilling the rubric requirements, but I can take them out if you think I should before the app is approved.

* change sort order of sessions list 
* assign and display student type

Thanks for your feedback and your time!!

