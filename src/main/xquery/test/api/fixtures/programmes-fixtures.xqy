xquery version "1.0-ml";

module namespace programmes-fixtures = "http://www.marklogic.co.uk/marklogic-tv/test/api/fixtures/programmes-fixtures";

import module namespace transaction-evaluater = "http://www.marklogic.co.uk/marklogic-tv/test/api/fixtures/transaction-evaluater"
at "/test/api/fixtures/transaction-evaluater.xqy";

import module namespace mem = "http://xqdev.com/in-mem-update"
at "/MarkLogic/appservices/utils/in-mem-update.xqy";

declare default element namespace "http://marklogic.com/xdmp/json/basic";
declare namespace d="http://marklogic.com/xdmp/json/basic";

declare option xdmp:mapping "false";

declare function new-programme($id as xs:string) as element() {
  element {"json"} {
    attribute {"type"} {"object"},
    element {"programme"} {
      attribute {"type"} {"object"},
      element {"id"} {
        attribute {"type"} {"string"},
        $id
      }
    }
  }
};

declare function add-genre($programme as element(), $genres as xs:string*) as element() {
  if ($genres) then
    let $node :=
      <genres type="array">
        {
          for $genre in $genres
          return <item type="string">{$genre}</item>
        }
      </genres>
    return mem:node-insert-child($programme/*, $node)
  else
    $programme
};

declare function persist($programmes as element()*) as element()* {
  let $up :=
    for $programme in $programmes
    return
      let $code := '
        let $id := "'||$programme/d:programme/d:id||'"
        return xdmp:document-insert($id, '|| xdmp:quote($programme)||')
      '
      let $l := xdmp:log($code, "error")
      return transaction-evaluater:eval($code)
  return $programmes
};

declare function clear-db() {
  transaction-evaluater:eval('
    let $db-name := xdmp:database-name(xdmp:database())
    return
      if (fn:contains($db-name, "test")) then
        for $d in fn:collection()
        return xdmp:document-delete(fn:base-uri($d))
      else
        fn:error(xs:QName("non-test-db"), "To wipe DB database name should contain test")
  ')
};

