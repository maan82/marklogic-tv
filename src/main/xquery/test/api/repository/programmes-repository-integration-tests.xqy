xquery version "1.0-ml";

module namespace test = "http://www.marklogic.co.uk/marklogic-tv/xqtest/test";

import module namespace repo = "http://www.marklogic.co.uk/marklogic-tv/api/repository/programmes-repository"
at "/api/repository/programmes-repository.xqy";
import module namespace programmes-fixtures = "http://www.marklogic.co.uk/marklogic-tv/test/api/fixtures/programmes-fixtures"
at "/test/api/fixtures/programmes-fixtures.xqy";
import module namespace transaction-evaluater = "http://www.marklogic.co.uk/marklogic-tv/test/api/fixtures/transaction-evaluater"
at "/test/api/fixtures/transaction-evaluater.xqy";


import module namespace request="http://www.marklogic.co.uk/marklogic-tv/api/common/request" at "/api/common/request.xqy";

import module namespace assert = "http://lds.org/code/shared/xqtest/assert" at "/xqtest/assert.xqy";

declare default element namespace "http://marklogic.com/xdmp/json/basic";
declare namespace d="http://marklogic.com/xdmp/json/basic";

declare option xdmp:mapping "false";

declare function (:TEST:) test-search---when-empty-db() {
  let $clear := programmes-fixtures:clear-db()

  let $fn := xdmp:set($request:get-parameter,
    function ($param-name as xs:string) {
      if ($param-name = "page") then
        1
      else if ($param-name = "page_size") then
        10
      else
        ()
    }
  )

  let $actual := repo:search()
  let $expected :=
    <result type="object">
      <total type="string">0</total>
      <items type="array"></items>
    </result>

  return assert:equal($actual, $expected, "Should be empty")
};

declare function (:TEST:) test-search---when-result() {
  let $clear := programmes-fixtures:clear-db()

  let $fn := xdmp:set($request:get-parameter,
    function ($param-name as xs:string) {
      if ($param-name = "page") then
        1
      else if ($param-name = "page_size") then
        10
      else
        ()
    }
  )
  let $p := programmes-fixtures:new-programme("test-id")

  let $programme := programmes-fixtures:persist($p)

  let $actual := repo:search()
  let $expected :=
    <result type="object">
      <total type="string">1</total>
      <items type="array">{$programme}</items>
    </result>

  return
    (
      assert:equal($actual/d:items/d:json/d:programme/d:id/fn:string(.), "test-id", "Should have programme")
    )
};

declare function (:TEST:) test-search---when-paging() {
  let $clear := programmes-fixtures:clear-db()

  let $fn := xdmp:set($request:get-parameter,
    function ($param-name as xs:string) {
      if ($param-name = "page") then
        2
      else if ($param-name = "page_size") then
        1
      else
        ()
    }
  )

  let $fn := xdmp:set($request:get-request-query-string-path,
    function () {
      "/test/path"
    }
  )

  let $fn := xdmp:set($request:get-parameter-names,
    function () {
      "/test/path"
    }
  )

  let $p1 := programmes-fixtures:new-programme("test-id1")
  let $p2 := programmes-fixtures:new-programme("test-id2")
  let $p3 := programmes-fixtures:new-programme("test-id3")

  let $programmes := programmes-fixtures:persist(($p1, $p2, $p3))

  let $actual := repo:search()

  return
    (
      assert:equal($actual/d:total/fn:string(.), "3", "Total should be correct"),
      assert:equal($actual/d:paging/d:previous-page/fn:string(.) , "/test/path?page=1", "Should be previous page"),
      assert:equal($actual/d:paging/d:next-page/fn:string(.) , "/test/path?page=3", "Should be next page")
    )
};

declare function (:TEST:) test-search---when-genre-filter() {
  let $clear := programmes-fixtures:clear-db()

  let $fn := xdmp:set($request:get-request-query-string-path,
    function () {
      "/test/path"
    }
  )

  let $fn := xdmp:set($request:get-parameter,
    function ($param-name as xs:string) {
      if ($param-name = "page") then
        1
      else if ($param-name = "page_size") then
        10
      else if ($param-name = "genre") then
        "g2"
      else
        ()
    }
  )

  let $p1 := programmes-fixtures:new-programme("test-id1")
  let $p1 := programmes-fixtures:add-genre($p1, ("g1"))

  let $p2 := programmes-fixtures:new-programme("test-id2")
  let $p2 := programmes-fixtures:add-genre($p2, ("g2"))

  let $p3 := programmes-fixtures:new-programme("test-id3")
  let $p3 := programmes-fixtures:add-genre($p3, ("g3"))

  let $programmes := programmes-fixtures:persist(($p1, $p2, $p3))

  let $actual := repo:search()

  return
    (
      assert:equal($actual/d:items/d:json/d:programme/d:id/fn:string(.) , "test-id2", "Should be same programme ")
    )
};

declare function (:TEST:) test-create() {
  let $clear := programmes-fixtures:clear-db()

  let $actual := transaction-evaluater:eval('
    let $fn := xdmp:set($request:get-parameter,
      function ($param-name as xs:string) {
        if ($param-name = "id") then
          "1"
        else
          ()
      }
    )
    let $json := ''{"programme" : { "id": "1"} }''

    let $fn := xdmp:set($request:get-body,
      function () {
        $json
      }
    )

    return
      programmes-repository:create()
  ')

  let $expected := fn:doc("1")/node()

  return assert:equal($actual, $expected, "Should have programme")
};
