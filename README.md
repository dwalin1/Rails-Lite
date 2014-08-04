<h1>Working on the Rails Road</h1>

This is a lite version of Rails written in Ruby using the WEBrick web-server. I create my own <code>ControllerBase</code> class to provide some of the functionality of Rails' <code>ActionController::Base</code> (<code>#render</code>, <code>#redirect</code>, etc.).

For views, I use ERB. Like big daddy Rails, my lite version renders views like this:

<ul>
<li>Read a template file and create a new ERB object from it</li>
<li>Capture the controller's instance variables with a binding</li>
<li>Evaluate the ERB object in the context of the binding</li>
<li>Pass this to a render method inherited by all controllers from our version of <code>ActionController::Base</code></li>
</ul>

I use a <code>WEBrick::Cookie</code> object with JSON serialization to create a session hash like that provided by Rails, and likewise emulate Rails' hashlike params object. The latter required me to be able to take strings like "user[address][street]=main&user[address][zip]=94709" and produce a deeply nested hash, as Rails does, so that all three types of parameters (those coming from the router's match of the URL, those coming from the query string, and those coming from the request body) can ultimately be integrated into the final params object, which can then be filtered with <code>#require</code> and <code>#permit</code> for mass assignment. I use Ruby's URI module and some basic regex to accomplish this.

Finally, I construct a <code>Router</code> and a <code>Route</code> class, each instance of the latter being basically a row in Rails' <code>rake routes</code> with relevant methods (e.g. for matching the route to a url through regex, at the same time capturing route params).