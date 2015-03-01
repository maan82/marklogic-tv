xquery version "1.0-ml";

module namespace media-play-repository = "http://www.marklogic.co.uk/marklogic-tv/api/repository/media-play-repository";

import module namespace request="http://www.marklogic.co.uk/marklogic-tv/api/common/request" at "/api/common/request.xqy";
import module namespace base-repository = "http://www.marklogic.co.uk/marklogic-tv/api/repository/base-repository" at "/api/repository/base-repository.xqy";

declare default element namespace "http://marklogic.com/xdmp/json/basic";
declare namespace d="http://marklogic.com/xdmp/json/basic";

declare function create() as element() {
  let $media-play := base-repository:create(request:get-parameter("id"), ("media-play"))
  let $programme-id := $media-play/d:media-play/d:programme-id
  let $programme := /d:json/d:programme[d:id = $programme-id]
  let $programme-views := $programme/d:views
  let $programme-popularity := $programme/d:popularity

  let $u :=
    if ($programme-views) then
      xdmp:node-replace($programme-views, create-view(xs:integer($programme-views) + 1))
    else
      xdmp:node-insert-child($programme, create-view(1))

  let $u :=
    let $date-time := (fn:current-dateTime() - xs:dayTimeDuration("PT20S"))
    let $popularity :=
      xdmp:estimate(/d:json[d:media-play/$programme-id = $programme-id
        and d:media-play/d:created-at > $date-time]) + 1
    return
      if ($programme-popularity) then
        xdmp:node-replace($programme-popularity, create-popularity(xs:integer($programme-popularity) + 1))
      else
        let $n := create-popularity(1)
        return xdmp:node-insert-child($programme, $n)

  return $media-play
};

declare function create-view($views as xs:integer) as element() {
  <views type="number">{$views}</views>
};

declare function create-popularity($views as xs:integer) as element() {
  <popularity type="number">{$views}</popularity>
};
