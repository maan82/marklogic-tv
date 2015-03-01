xquery version "1.0-ml";

import module namespace media-play-repository = "http://www.marklogic.co.uk/marklogic-tv/api/repository/media-play-repository" at "/api/repository/media-play-repository.xqy";
import module namespace renderer = "http://www.marklogic.co.uk/marklogic-tv/api/controllers/renderer" at "/api/controllers/renderer.xqy";

declare option xdmp:mapping "false";

let $request-method := xdmp:get-request-method()
let $result :=
  if ("POST" = $request-method) then
    media-play-repository:create()
  else
    ()

return renderer:render($result)
