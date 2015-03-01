xquery version "1.0-ml";

declare namespace error = "http://marklogic.com/xdmp/error";

declare variable $error:errors as element(error:error)* external;

let $errorResponseCode := xdmp:get-response-code()
return (
  xdmp:add-response-header("Content-Type", "application/xml"),
  element result {
    element status {
      attribute code { $errorResponseCode[1] },
      $errorResponseCode[2]
    },
    element message {
      $errorResponseCode[2]
    },
    element errors {
      $error:errors
    }
  }
)
