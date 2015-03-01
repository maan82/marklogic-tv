xquery version "1.0-ml";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare option xdmp:mapping "false";

declare variable $redirected as xs:string? := xdmp:get-request-field("redirected");

<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>Nitro API</title>
  </head>
  <body>
    <h1>Nitro API</h1>
    <p>This is the root of the <code>ml-rest-lib</code> MarkLogic REST API.</p>
    <p>From here you can go to the <a href="/programmes/">programmes</a> feed
    or run the <a href="/test/">Nitro unit tests</a>.</p>
  </body>
</html>
