xquery version "1.0-ml";

import module namespace testng = "http://lds.org/code/shared/xqtest/testng" at "/xqtest/testng.xqy";

declare option xdmp:mapping "false";

declare variable $file as xs:string  := xdmp:get-request-field("file", "");

if ($file) then
  testng:tests($file)
else
  testng:test('/test/')
