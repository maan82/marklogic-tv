xquery version "1.0-ml";

module namespace programmes-repository = "http://www.marklogic.co.uk/marklogic-tv/api/repository/programmes-repository";

import module namespace request="http://www.marklogic.co.uk/marklogic-tv/api/common/request" at "/api/common/request.xqy";
import module namespace paging="http://www.marklogic.co.uk/marklogic-tv/api/common/paging" at "/api/common/paging.xqy";
import module namespace base-repository = "http://www.marklogic.co.uk/marklogic-tv/api/repository/base-repository" at "/api/repository/base-repository.xqy";
import module namespace mem = "http://xqdev.com/in-mem-update" at "/MarkLogic/appservices/utils/in-mem-update.xqy";

declare default element namespace "http://marklogic.com/xdmp/json/basic";
declare namespace d="http://marklogic.com/xdmp/json/basic";
declare namespace search="http://marklogic.com/appservices/search";

declare function search() as element()* {
  let $paging :=
    paging:calculate-paging(xs:integer($request:get-parameter("page")),
      xs:integer($request:get-parameter("page_size")))
  let $query := construct-query()
  let $trace :=
    if ($request:get-parameter("trace") = "true") then
      xdmp:query-trace(fn:true())
    else
      ()
  let $search :=
    "(for $doc in cts:search(/d:json[d:programme], $query)"
    || get-sort()
    || " return $doc)[paging:get-start($paging) to paging:get-end($paging)]"
  let $result := xdmp:value($search)

  let $total :=
    if ($result) then
      cts:remainder($result[1]) + paging:get-start($paging) - 1
    else
      0
  let $result := add-play-flag($result)
  return
    <result type="object">
      <total type="string">{ $total }</total>
      {paging:get-pagination($paging, $total)}
      <items type="array">{$result}</items>
    </result>
};

declare function add-play-flag($result) {
  let $now := fn:current-dateTime()
  return
    for $item in $result
    return
      if ($item/d:programme/d:start-date castable as xs:dateTime and xs:dateTime($item/d:programme/d:start-date) < $now
        and $item/d:programme/d:end-date castable as xs:dateTime and xs:dateTime($item/d:programme/d:end-date) > $now) then
          mem:node-insert-child($item/*, <play type="boolean">true</play>)
      else
        mem:node-insert-child($item/*, <play type="boolean">false</play>)
};

declare function construct-query() as cts:query {
  let $search-text := $request:get-parameter("search_text")
  let $genre := $request:get-parameter("genre")
  let $availability := $request:get-parameter("availability")

  return cts:and-query((
    if ($search-text) then
      add-text-search-query($search-text)
    else
      (),
    if ($genre) then
      cts:path-range-query("/d:json/d:programme/d:genres/d:item", "=", $genre)
    else
      (),
    if ($availability = "true") then
      let $now := fn:current-dateTime()
      return
        cts:and-query((
          cts:path-range-query("/d:json/d:programme/d:start-date", "<", $now),
          cts:path-range-query("/d:json/d:programme/d:end-date", ">", $now)
        ))
    else
      ()

  ))
};

declare function add-text-search-query($search-text as xs:string) as cts:query? {
  if (fn:exists($search-text) and ($search-text != "")) then
    let $term-options := (
      <search:term-option>case-insensitive</search:term-option>,
      <search:term-option>stemmed</search:term-option>
    )
    let $options :=
      <search:options>
        <search:constraint name="title">
          <search:word>
            <search:element ns="http://marklogic.com/xdmp/json/basic" name="title"/>
            {$term-options}
          </search:word>
        </search:constraint>
        <search:constraint name="synopsis">
          <search:word>
            <search:element ns="http://marklogic.com/xdmp/json/basic" name="synopsis"/>
            {$term-options}
          </search:word>
        </search:constraint>
        <search:term>
          {$term-options}
        </search:term>
      </search:options>

    return cts:query(parse($search-text, $options))
  else
    ()
};

declare function get-sort() {
  let $sort := $request:get-parameter("sort")
  return
    if ($sort = "start_date") then
      " order by $doc/d:programme/d:start-date descending"
    else if ($sort = "genre") then
      " order by ($doc/d:programme/d:genres/d:item)[0] ascending"
    else if ($sort = "views") then
      " order by ($doc/d:programme/d:views)[0] descending"
    else if ($sort = "popularity") then
      " order by ($doc/d:programme/d:popularity)[0] descending"
    else
      ()
};

declare function parse($search-text, $options){
  xdmp:eval('
    xquery version "1.0-ml";
    import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";
    declare default element namespace "http://marklogic.com/xdmp/json/basic";
    declare namespace d="http://marklogic.com/xdmp/json/basic";

    declare variable $d:search-text as xs:string external;
    declare variable $search:options as element() external;
    search:parse($d:search-text, $search:options)',
    (
      xs:QName('d:search-text'), $search-text,
      xs:QName('search:options'), $options
    )
  )
};

declare function create() as element() {
  let $l := xdmp:log("body "||$request:get-parameter("id"), "error")
return
  base-repository:create($request:get-parameter("id"), ("programme"))
};

declare function delete() {
  let $id := $request:get-parameter("id")
  let $del :=
    if (fn:doc($id)) then
      (xdmp:document-delete($id), $id)
    else
      ()
  return
    <result type="object">
      <total type="string">{fn:count($del)}</total>
    </result>
};