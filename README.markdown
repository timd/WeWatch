# WeWatch

Table-driven version of the WeWatch iPhone app.
http://www.wewatch.co.uk

===================================================

### Version         :   0.98
### Branch          :   master
### Branched from   :   
### Merged from     :   revised_placeholder_text
### Date            :   20/06/2011

===================================================

RELEASE NOTES

### Build           :   
### Purpose         :   

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
- moved throbber to top windpw
- Gowalla-style watch view
- implemented persistent local notifications
- implemented notification cancellation from programme detail view
- implemented notification cancellation from unwatch action
- added open-in-Safari code to detail page; also implemented unused webview
- implemented image caching
- updated placeholder text in comment box
- implemented film flag

### In progress:


### Todo:

- add throbber to loading of images
- need to check async cancel format [REQUIRES TESTING]
- clean up display and formatting of multiple friend name [REQUIRES TESTING]
- test with more watcher names [Need Frankie to add a test feed that returns more watcher names]
- update class diagrams

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
