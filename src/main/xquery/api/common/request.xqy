xquery version "1.0-ml";

module namespace request = "http://www.marklogic.co.uk/marklogic-tv/api/common/request";
import module namespace functx = "http://www.functx.com" at "/MarkLogic/functx/functx-1.0-nodoc-2007-01.xqy";

declare namespace n = "http://www.marklogic.co.uk/marklogic-tv/";

declare option xdmp:mapping "false";

declare variable $get-parameter as xdmp:function := function ($param-name as xs:string) { get-parameter($param-name) };
declare variable $get-request-query-string-path as xdmp:function := function () { get-request-query-string-path() };
declare variable $get-parameter-names as xdmp:function := function () as xs:string* { get-parameter-names() };
declare variable $get-body as xdmp:function := function () { get-body() };

declare function get-parameter($param-name as xs:string) {
  xdmp:get-request-field($param-name)
};

declare function get-parameter-names() as xs:string* {
  xdmp:get-request-field-names()
};

declare function get-body() {
  xdmp:get-request-body()/node()
};

declare function get-request-query-string-path() as xs:string {
  functx:substring-before-if-contains(xdmp:get-original-url(),"?")
};

