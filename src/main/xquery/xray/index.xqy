xquery version "1.0-ml";

import module namespace xray="http://github.com/robwhitby/xray" at "src/xray.xqy";

(: where to look for tests :)
declare variable $dir as xs:string := xdmp:get-request-field("dir", "test");

(: module name matcher regex :)
declare variable $modules as xs:string? := xdmp:get-request-field("modules", "test");

(: test name matcher regex :)
declare variable $tests as xs:string? := xdmp:get-request-field("tests", "test-.*");

(: output format xml|html|text :)
declare variable $format as xs:string := xdmp:get-request-field("format", "html");


xray:run-tests($dir, $modules, $tests, $format)
