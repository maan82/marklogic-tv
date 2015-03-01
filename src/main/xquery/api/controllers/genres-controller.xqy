xquery version "1.0-ml";

import module namespace genres-repository = "http://www.marklogic.co.uk/marklogic-tv/api/repository/genres-repository" at "/api/repository/genres-repository.xqy";
import module namespace renderer = "http://www.marklogic.co.uk/marklogic-tv/api/controllers/renderer" at "/api/controllers/renderer.xqy";

declare option xdmp:mapping "false";

let $result := genres-repository:search()

return renderer:render($result)
