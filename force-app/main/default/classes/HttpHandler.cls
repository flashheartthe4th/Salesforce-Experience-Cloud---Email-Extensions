public without sharing class HttpHandler {
    
    public static HttpResponse callEndPoint(HttpRequest req) {
        http http = new http();
        HTTPResponse response = http.send(req);

        if(response.getStatusCode()>=300 && response.getStatusCode()<400) {
            system.debug(system.LoggingLevel.DEBUG,'Redirected EndPoint: "' + req.getEndpoint() + '"');
            system.debug(system.LoggingLevel.DEBUG,'New Location: "' + response.getHeader('Location') + '"');
            req.setEndpoint(response.getHeader('Location'));
            system.debug(system.LoggingLevel.DEBUG,'Requesting data from new location.');
            response = callEndPoint(req);
        }

        return response;
    }
}
