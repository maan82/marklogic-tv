xquery version "1.0-ml";

module namespace test = "http://www.marklogic.co.uk/marklogic-tv/test/api/fixtures/transaction-evaluater";

declare default element namespace "http://marklogic.com/xdmp/json/basic";

declare function eval($code as xs:string) {
  xdmp:eval(fn:concat("
    declare namespace d = 'http://marklogic.com/xdmp/json/basic';

    import module namespace programmes-repository = 'http://www.marklogic.co.uk/marklogic-tv/api/repository/programmes-repository'
    at '/api/repository/programmes-repository.xqy';
    import module namespace programmes-fixtures = 'http://www.marklogic.co.uk/marklogic-tv/test/api/fixtures/programmes-fixtures'
    at '/test/api/fixtures/programmes-fixtures.xqy';
    import module namespace base-repository = 'http://www.marklogic.co.uk/marklogic-tv/api/repository/base-repository'
    at '/api/repository/base-repository.xqy';
    import module namespace request='http://www.marklogic.co.uk/marklogic-tv/api/common/request'
    at '/api/common/request.xqy';
    import module namespace paging='http://www.marklogic.co.uk/marklogic-tv/api/common/paging'
    at '/api/common/paging.xqy';


    declare option xdmp:mapping 'false';
    ", $code
  ))
};



