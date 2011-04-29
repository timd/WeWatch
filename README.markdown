===================================================

WeWatchTabled

Table-driven version of the WeWatch iPhone app.
http://www.wewatch.co.uk

===================================================

Version :   0.8
Branch  :   twitter-integration
Date    :   29/04/2011

===================================================

NOTES

Completed:

- initial commit to project
- skeleton XCode project
- initial implementation of Programme model
- implemented basic table view
- implemented programme detail view
- implementing subclassed cells to tweak table display
- overhauled detail view
- rewrote ProgrammesViewController init method to create array of programme objects from JSON-derived dictionary
- overhauled app based on Aral Balkan's Tweet Timeline browser
- implemented basic pull refresh functions
- implemented basic Twitter login

In progress:

- 

Todo:

- cleaning up title labels
- update class diagrams
- figure out how threading is managed
- clean up Twitter login:
  - add some narrative to explain what's going on
  - handle failure to authenticate more gracefully

===================================================

(cc) Tim Duckett, 2011
tim@adoptioncurve.net
http://www.adoptioncurve.net

Some rights reserved.  Freely available for
education and training purposes.

Licensed under Creative Commons
Attribution-NonCommercial-ShareAlike 3.0
Unported License.

http://creativecommons.org/licenses/by-nc-sa/3.0/

===================================================

REQUIREMENTS

- XCode 4.0 (Rev 4A304a) and above
- iPhone running iOS 4.3 and above

DEPENDENCIES

- MWFeedParser (partial)
https://github.com/mwaterfall/MWFeedParser.git

- GMHTTPFetcher

- TouchJSON

- Tim Duckett's ActivityIndicator

===================================================