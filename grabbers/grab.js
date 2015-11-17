// Get command line arguments
var system = require("system");
var args = system.args;
// Make sure there is a url to get
if (args.length === 1) {
  //console.log("Require URL!");
  phantom.exit();
}
// 0 is this script, 1 should be the url
var url = args[1];
// Get the webpage
var webPage = require("webpage");
var page = webPage.create();
// Remember to ignore ssl errors (--ignore-ssl-errors=true)
page.open(url, function (status) {
  if (status === "success") {
    // Wait a second before getting the final html content
    setTimeout(function() {
      // Output the final html to the standard out
      console.log(page.content);
      phantom.exit();
    },
    // Wait about 10 seconds (arbitrary)
    10000);
  }
  else {
    phantom.exit();
  }
});
