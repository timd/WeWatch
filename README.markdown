# WeWatch

Table-driven version of the WeWatch iPhone app.
http://www.wewatch.co.uk

===================================================

### Version         :   0.91
### Branch          :   gowalla_watch
### Branched from   :   master
### Merged from     :   n/a
### Date            :   13/06/2011

===================================================

# NOTES

### Completed:

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
- retrieval & display of friends who are watching
- implemented Reachability on data retrieval methods
- mark programmes I'm flagged as watching
- move Twitter login out into better place
- creating reminder notifications (currently in test mode)
- implemented modal settings window
- implemented autoupdating of views after watching programme
- added basic HUB throbbers for reload in RootViewController
- implemented api-based unwatch
- moved watch & cancel buttons to toolbar
- added generic content to text box
- added 'tweet this' option
- removed RestKit and replaced with ASIHTTPRequest
- updated reachability code
- lose empty timeslots in the tableview

### In progress:

### Todo:
- fix watch/unwatch wording

- Gowalla-style watch view
- grey-out past programmes

- cache images
- add throbber to unwatch action
- move main throbber to fixed location
- add clock icon to watched programmes and link to unremind
- send tweet via wewatch site

- refresh RootViewController without hitting API after a 'watch programme'?

- amend table methods so empty timeslots aren't displayed
- implement tweeting
- amend programme image load to cancel if detail view is removed
- need to check async cancel format [REQUIRES TESTING]
- clean up display and formatting of multiple friend name [REQUIRES TESTING]
- amend display of friends names 
- test with more watcher names [Need Frankie to add a test feed that returns more watcher names]
- cleaning up title labels
- update class diagrams
- clean up Twitter login:
  - add some narrative to explain what's going on
  - handle failure to authenticate more gracefully
- improve text handling in alert views

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

# REQUIREMENTS

- XCode 4.0 (Rev 4A304a) and above
- iPhone running iOS 4.3 and above

#DEPENDENCIES

- MWFeedParser (partial) https://github.com/mwaterfall/MWFeedParser.git
- MGTwitterEngine
- SA_OAuthTwitterEngine
- TouchJSON
- Aral Balkan's ActivityIndicator
- QuartzCore
- SVProgressHUD (https://github.com/samvermette/SVProgressHUD)
- ASIHTTPRequest (https://github.com/pokeb/asi-http-request/tree)

===================================================
