xquery version "1.0-ml";

module namespace html = "http://lds.org/code/shared/xqtest/html";

import module namespace unittest = "http://lds.org/code/shared/xqtest/unittest" at "unittest.xqy";

declare option xdmp:mapping "false";

declare function html:test() {
  unittest:test(xdmp:function(xs:QName("html:runFormat")), xdmp:function(xs:QName("html:render")), ())
};

declare function html:test($testDir as xs:string?) {
  unittest:test(xdmp:function(xs:QName("html:runFormat")), xdmp:function(xs:QName("html:render")), $testDir)
};

declare function html:tests($modules as xs:string*) as element() {
  html:render(html:runFormat($modules))
};

declare function html:render($suite as element()*) as element() {
  let $passes := fn:count($suite[2]//div[@class eq 'single-success'])
  let $total := fn:count($suite[2]//div[@class eq 'single-failure']) + $passes
  let $skipped := fn:count($suite[2]//div[@class eq 'single-skip'])
  let $skipped := if ($skipped > 0) then "("||$skipped||" skipped)" else ""
  let $results := fn:concat($passes,' of ',$total,' passed ', $skipped, ' - ',$suite[1]/@suiteElapsed)
	return
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <title>{fn:concat('Unit Tests - ',$results)}</title>
        <link rel="stylesheet" href="/xqtest/resources/css/io.css" type="text/css"/>
        <script type="text/javascript" src="/xqtest/resources/scripts/jquery-1.4.3.min.js"></script>
        <script type="text/javascript" src="/xqtest/resources/scripts/manipulate.js"></script>
        <script>
          $(function () {{
            $(".toggle-vars").click(function () {{
              $(this).siblings(".vars").slideToggle();
            }});
          }});
        </script>
      </head>
      <body xmlns="">
        <div class="container">
          <h1><a href="/test/">Unit Test Results</a></h1>
          <h2 class="results { if ($passes = $total) then " success" else "failure" }">
            {$results}
          </h2>
          <div id="failed-tests"><div style='color:#FFF'>Failed</div></div>
          <div id="main">
            {$suite[2]/*}
          </div>
        </div>
      </body>
    </html>
};

declare function html:runFormat($modules as xs:string*) {
  xdmp:trace("xqtest", "##################################### Executing XQuery Unit Test Suite #######################################"),
	html:formatTests(unittest:run($modules))
};

declare function html:formatTests($results) {
	$results,
	element formatted {
		for $module in $results/module
		return <div id="{ fn:replace(fn:replace($module/@moduleName, '/', '_'), '\.', '_')}">{(
			<div id="module">Module: <a href="/test/?file={fn:string($module/@moduleName)}">{ fn:string($module/@moduleName) }</a> - { fn:string($module/@moduleElapsed) }</div>,

			for $test in $module/test
        let $testName := fn:concat(fn:string($test/@testName), ' - ',
                                   fn:format-number(unittest:ms($test/@innerTime), "##0.000"),
                                   ' ms (',
                                   fn:format-number(unittest:ms($test/@testElapsed) - unittest:ms($test/@innerTime), "##0.000"),
                                   ' ms)'
                                  )
        order by $test/@testName descending
        return if($test/error) then
          html:format($testName, ( element br {}, html:formatStackTrace($test/error/*), element br {} ))
        else
          html:format($testName, $test/message/node()),

      for $skipped in $module/skip
        let $testName := fn:string($skipped/@name)
        order by $skipped/@name descending
        return <div class="single-skip">{$testName} : skipped.</div>
		)}</div>
	}
};

declare function html:format($name as xs:string?, $result as item()*) {
  <div class="single-{ if ($result) then "failure" else "success" }">{
      $name, ": ", $result
  }</div>
};

declare function html:formatStackTrace($errors) {
  for $error in $errors
  return element ul {
    attribute class { "stack" },
    element li {
      if (fn:exists($error/error:format-string/text())) then
        $error/error:format-string
      else
        fn:concat($error/error:name, " -- ", $error/error:message)
    },
    for $frame in $error/error:stack/error:frame
    let $uri := $frame/error:uri/text()
    let $line := $frame/error:line/text()
    let $location := fn:concat($uri, ":", $line)
    let $op := $frame/error:operation/text()
    let $vars := $frame/error:variables/error:variable
    return element li {
      element span {
          $location
      },
      $op,
      if ($vars) then
        ( element a {
            attribute href { "javascript:void(0);" },
            attribute class { "toggle-vars" },
            "vars"
          }
        , element ul {
            attribute class { "vars" },
            for $var in $vars
            let $name := $var/error:name/text()
            let $val := $var/error:value/text()
            return element li {
              element span {
                $name
              },
              $val
            }
          }
        )
      else
        ()
    }
  }
};
