tips
====

This is my first attempt at building an app in Swift.

It's a simple tip calculator, with a basic settings page for configuring decimal and grouping separators, as well as a "dark mode". There's also a page to set the currency symbol, but I lost a battle with NSLocale, so as of now, that's not working.

Things I want to improve:

* Get the currency symbol settings page to actually work
* Make the currency symbol placeholder visible in dark mode (I have a feeling that some alpha channel weirdness is going on there)
* Add an icon and splash page (polish)
* Come up with a cleaner, more object-oriented way of dealing with NSUserDefaults
