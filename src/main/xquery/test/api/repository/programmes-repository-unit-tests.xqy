xquery version "1.0-ml";

module namespace test = "http://www.marklogic.co.uk/marklogic-tv/xqtest/test";

import module namespace repo = "http://www.marklogic.co.uk/marklogic-tv/api/repository/programmes-repository"
at "/api/repository/programmes-repository.xqy";

import module namespace request="http://www.marklogic.co.uk/marklogic-tv/api/common/request" at "/api/common/request.xqy";

import module namespace assert = "http://lds.org/code/shared/xqtest/assert" at "/xqtest/assert.xqy";

declare namespace d="http://marklogic.com/xdmp/json/basic";

declare option xdmp:mapping "false";

declare variable $should-not-run as xdmp:function :=
  function () {
      fn:error(xs:QName("should-not-run"))
  };

declare function (:TEST:) test-get-sort---when-no-sort() {
  let $fn := xdmp:set($request:get-parameter,
    function ($param-name as xs:string) {
      ()
    }
  )
  return assert:empty(repo:get-sort(), "Should be empty")
};

declare function (:TEST:) test-get-sort---when-start-date() {
  let $fn := xdmp:set($request:get-parameter,
    function ($param-name as xs:string) {
      if ($param-name = "sort") then
        "start_date"
      else
        $should-not-run()
    }
  )
  let $expected := " order by $doc/d:programme/d:start-date descending"
  return assert:equal(repo:get-sort(), $expected, "Should be start_date")
};

declare function (:TEST:) test-get-sort---when-genre() {
  let $fn := xdmp:set($request:get-parameter,
    function ($param-name as xs:string) {
      if ($param-name = "sort") then
        "genre"
      else
        $should-not-run()
    }
  )
  let $expected := " order by ($doc/d:programme/d:genres/d:item)[0] ascending"
  return assert:equal(repo:get-sort(), $expected, "Should be genre")
};

declare function (:TEST:) test-get-sort---when-views() {
  let $fn := xdmp:set($request:get-parameter,
    function ($param-name as xs:string) {
      if ($param-name = "sort") then
        "views"
      else
        $should-not-run()
    }
  )
  let $expected := " order by ($doc/d:programme/d:views)[0] descending"
  return assert:equal(repo:get-sort(), $expected, "Should be views")
};

declare function (:TEST:) test-get-sort---when-popularity() {
  let $fn := xdmp:set($request:get-parameter,
    function ($param-name as xs:string) {
      if ($param-name = "sort") then
        "popularity"
      else
        $should-not-run()
    }
  )
  let $expected := " order by ($doc/d:programme/d:popularity)[0] descending"
  return assert:equal(repo:get-sort(), $expected, "Should be popularity")
};

