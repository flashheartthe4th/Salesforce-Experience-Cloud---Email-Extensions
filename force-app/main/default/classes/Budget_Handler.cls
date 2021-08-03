@RestResource(urlMapping='/Budget/*')
global class Budget_Handler {
    
    @HttpPost
    global static Budget_Wrapper httpPost() {
        RestRequest req = RestContext.request;
        BudgetRequest br = (BudgetRequest)json.deserialize(req.requestBody.toString(),BudgetRequest.Class);
        Budget_Wrapper bw = new Budget_Wrapper(br.budgetStartDate,br.interval,br.periods,br.mode);
        return bw;
    }
    
    global class BudgetRequest {
        global Date budgetStartDate {get;set;}
        global String interval {get;set;}
        global Integer periods {get;set;}
        global String mode {get;set;}
    }
}