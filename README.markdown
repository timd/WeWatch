# WeWatch

Table-driven version of the WeWatch iPhone app.
http://www.wewatch.co.uk

===================================================

### Version         :   0.9
### Branch          :   implement_unwatch
### Branched from   :   master
### Merged from     :   n/a
### Date            :   08/06/2011

===================================================

# NOTES

- appears to have fixed the compilation problems:
  - installed RestKit as per instructions at http://liebke.github.com/restkit-github-client-example/
  - created new scheme from scratch, then reimported ad-hoc distribution certificate
  - created archive as per normal

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

### In progress:
- implementing api-based unwatch

### Todo:
- tidy up api watch actions
- tidy up login/out process
- implement unwatch process
- amend programme image load to cancel if detail view is removed
- need to check async cancel format [REQUIRES TESTING]
- clean up display and formatting of multiple friend name [REQUIRES TESTING]
- move Twitter login to Login button on RootView [REQUIRES ONLINE TESTING]
- amend display of friends names 
- test with more watcher names [Need Frankie to add a test feed that returns more watcher names]
- add data refresh method to appDidEnterForeground (check in Programming iOS4 book)
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
- RestKit (http://restkit.org/ & https://github.com/twotoasters/RestKit)
- SVProgressHUD (https://github.com/samvermette/SVProgressHUD)

===================================================
