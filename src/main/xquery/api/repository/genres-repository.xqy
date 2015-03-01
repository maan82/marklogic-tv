xquery version "1.0-ml";

module namespace genres-repository = "http://www.marklogic.co.uk/marklogic-tv/api/repository/genres-repository";

import module namespace request="http://www.marklogic.co.uk/marklogic-tv/api/common/request" at "/api/common/request.xqy";
import module namespace paging="http://www.marklogic.co.uk/marklogic-tv/api/common/paging" at "/api/common/paging.xqy";

declare default element namespace "http://marklogic.com/xdmp/json/basic";
declare namespace d="http://marklogic.com/xdmp/json/basic";

declare function search() as element()* {
  let $trace :=
    if (request:get-parameter("trace") = "true") then
      xdmp:query-trace(fn:true())
      else
      ()
  let $result :=
    (
      for $item in cts:values(cts:path-reference("/d:json/d:programme/d:genres/d:item"))
      return
        <json type="object">
          <genre type="object">
            <name type="string">{$item}</name>
            <count type="string">{cts:frequency($item)}</count>
          </genre>
        </json>
  )
  let $total := fn:count($result)
  let $paging := paging:calculate-paging(1, $total)
  return
    <result type="object">
      <total type="string">{ $total }</total>
      {paging:get-pagination($paging, $total)}
      <items type="array">{$result}</items>
    </result>
};

