===================================================

WeWatchTabled

Table-driven version of the WeWatch iPhone app.
http://www.wewatch.co.uk

===================================================

Version :   0.6
Branch  :   ww-refactor
Date    :   28/04/2011

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

In progress:

- cleaning up grouped tableview

Todo:

- 
- update class diagrams
- implement pull refresh
- refactor Programme model to handle dates/times
  durations properly

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

- Aral Balkan's ActivityIndicator

===================================================