xquery version "1.0-ml";

module namespace paging = "http://www.marklogic.co.uk/marklogic-tv/api/common/paging";

import module namespace request="http://www.marklogic.co.uk/marklogic-tv/api/common/request" at "/api/common/request.xqy";

declare default element namespace "http://marklogic.com/xdmp/json/basic";
declare namespace d="http://marklogic.com/xdmp/json/basic";

declare option xdmp:mapping "false";

declare variable $DEFAULT-PAGE as xs:integer      := 1;
declare variable $DEFAULT-PAGE-SIZE as xs:integer := 2;
declare variable $PAGE-SIZE-MINIMUM as xs:integer := 0;
declare variable $PAGE-SIZE-MAXIMUM as xs:integer := 50;


declare function make-paging($start as xs:integer, $end as xs:integer, $requested-page-number as xs:integer, $actual-page-number as xs:integer, $requested-page-size as xs:integer, $actual-page-size as xs:integer) {
  <d:paging start="{ $start }" end="{ $end }"
  requested-page-number="{ $requested-page-number }" page-number="{ $actual-page-number }" requested-page-size="{ $requested-page-size }" page-size="{ $actual-page-size }"/>
};

declare function calculate-paging($requested-page-number as xs:integer?, $requested-page-size as xs:integer?) as element(d:paging) {
  let $requested-page-number :=
    if ($requested-page-number) then
      $requested-page-number
    else
      $DEFAULT-PAGE

  let $requested-page-size :=
    if ($requested-page-size) then
      $requested-page-size
    else
      $DEFAULT-PAGE-SIZE

  let $actual-page-size :=
    if ($requested-page-size > $PAGE-SIZE-MAXIMUM) then
      $PAGE-SIZE-MAXIMUM
    else
      $requested-page-size
  let $actual-page-size :=
    if ($requested-page-size < $PAGE-SIZE-MINIMUM) then
      $PAGE-SIZE-MINIMUM
    else
      $actual-page-size

  let $actual-page-number :=
    if ($requested-page-number < $DEFAULT-PAGE) then
      $DEFAULT-PAGE
    else
      $requested-page-number

  let $start :=
    if( $actual-page-size = 0) then
      0
    else
      1 + ($actual-page-number - 1) * $actual-page-size
  let $end :=
    if( $actual-page-size = 0) then
      1
    else
      $actual-page-size * $actual-page-number

  return
    make-paging($start, $end, $requested-page-number, $actual-page-number, $requested-page-size, $actual-page-size)
};

declare function get-start($paging as element(d:paging)) as xs:integer {
  $paging/@start
};

declare function get-end($paging as element(d:paging)) as xs:integer {
  $paging/@end
};

declare function get-actual-page-number($paging as element(d:paging)) as xs:integer {
  $paging/@page-number
};

declare function get-pagination($paging as element(d:paging), $total as xs:integer) as element(paging)? {
  let $actual-page := get-actual-page-number($paging)
  let $params := get-query-string-without-page-number()
  let $path := $request:get-request-query-string-path()
  let $next-link :=
    if ($total > get-end($paging)) then
      let $next-page-number := $actual-page + 1
      return
        let $page-param := "page="||$next-page-number
        let $query-string := add-page-param($params, $page-param)
        return
          <next-page type="string">{create-link($path, $query-string)}</next-page>
    else
      ()

  let $previous-link :=
    if (get-actual-page-number($paging) > 1) then
      let $previous-page-number := $actual-page - 1
      return
        let $page-param := "page="||$previous-page-number
        let $query-string := add-page-param($params, $page-param)
        return
          <previous-page type="string">{create-link($path, $query-string) }</previous-page>
    else
      ()

  return
    if ($next-link or $previous-link ) then
      <paging type="object">{($previous-link, $next-link)}</paging>
    else
      ()
};

declare function add-page-param($params as xs:string?, $page-param as xs:string) as xs:string {
  if ($params) then
    fn:string-join(($params, $page-param), "&amp;")
  else
    $page-param
};

declare function create-link($path as xs:string, $query-string as xs:string ) as xs:string {
  if ($query-string) then
    $path||"?"||$query-string
  else
    $path
};

declare function get-query-string-without-page-number() {
  let $param-pairs :=
    for $param in $request:get-parameter-names()
    where fn:not($param = "page")
    return
      for $value in request:get-parameter($param)
      return $param||"="||$value
  return fn:string-join($param-pairs, "&amp;")
};

