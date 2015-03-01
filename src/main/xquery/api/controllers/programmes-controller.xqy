xquery version "1.0-ml";

import module namespace programmes-repository = "http://www.marklogic.co.uk/marklogic-tv/api/repository/programmes-repository" at "/api/repository/programmes-repository.xqy";
import module namespace renderer = "http://www.marklogic.co.uk/marklogic-tv/api/controllers/renderer" at "/api/controllers/renderer.xqy";

declare option xdmp:mapping "false";

let $result := programmes-repository:search()

return renderer:render($result)
