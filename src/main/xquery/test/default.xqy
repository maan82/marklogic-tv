xquery version "1.0-ml";

import module namespace html = "http://lds.org/code/shared/xqtest/html" at "/xqtest/html.xqy";

declare option xdmp:mapping "false";

declare variable $file as xs:string*  := xdmp:get-request-field("file", "");
declare variable $directory as xs:string  := xdmp:get-request-field("dir", "");

if ($file) then
  html:tests($file)
else if ($directory) then
  html:test($directory)
else
  html:test('/test/')
