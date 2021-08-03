public class BudgetItem_Wrapper {
    
    public String name {get;private set;}
    public String type {get;private set;}
    public Decimal amount {get;private set;}
    public String frequencylabel {get;private set;}
    public double frequency {get;private set;}
    public Date startDate {get;private set;}
    public Date endDate {get;private set;}
    public Integer relativeStartMonth {get;private set;}
    public Integer relativeEndMonth {get;private set;}
    public budgetPeriod[] budgetPeriods {get;private set;}
    
    public class budgetPeriod {
        public Date periodEndDate {get;private set;}
        public Integer periodOffset {get;private set;}
        public Decimal monthly {get;private set;}
        //public Decimal accrueCumulative {get;private set;}
        //public Decimal accrue {get;private set;}
        public Decimal cumulative {get;private set;}
        
        public budgetPeriod(Date budgetPeriodDate,Date budgetStartDate,String budgetInterval,BudgetItem_Wrapper currentItem) {
            periodEndDate = DateExtension.endOfInterval(budgetPeriodDate,budgetInterval);
            periodOffset = budgetStartDate.monthsBetween(budgetPeriodDate);
            monthly = 0;
            //accrueCumulative = 0;
            //accrue = 0;
            cumulative = 0;
            //is the current period after the start of the budget?
            //if the current period is after the start of the budget, then do the calculation
            //unless it is a accrual calc, then we want to calc one period before the start date to start
            
            if(periodOffset >= currentItem.relativeStartMonth && (periodOffset<=currentItem.relativeEndMonth || currentItem.relativeEndMonth == null)){
                monthly = (
                    Math.mod(
                        periodOffset-currentItem.relativeStartMonth,
                        currentItem.frequency.intValue()
                    )==0 ? 1 : 0) * currentItem.amount;
            }
            
            //accrueCumulative = ((Math.max(periodOffset-Math.max(currentItem.relativeStartMonth,0)-(currentItem.relativeEndMonth == null? 0 : (Math.max(0,periodOffset-currentItem.relativeEndMonth))),0)+(Math.mod(currentItem.relativeStartMonth,currentItem.frequency.intValue())==0 ? 1 : 0))*(periodOffset<=currentItem.relativeEndMonth ? 1 : 0)*(periodOffset>=currentItem.relativeStartMonth ? 1 : 0)*(currentItem.amount/currentItem.frequency)).setScale(4);
			//accrue = (accrueCumulative > 0 ? (currentItem.amount/currentItem.frequency) : 0).setScale(4);
            
            if(periodOffset >= currentItem.relativeStartMonth) {
                cumulative = (((Math.max(0,(((0-Math.max(0,currentItem.relativeStartMonth))+periodOffset)/currentItem.frequency).intValue())-(currentItem.relativeEndMonth==null ? 0 : Math.max(0,((periodOffset-currentItem.relativeEndMonth)/currentItem.frequency).intValue()))) + (Math.mod(currentItem.relativeStartMonth,currentItem.frequency.intValue())==0 ? 1 : 0)) * currentItem.amount).setScale(4);
            }
            
            //cumulative since start of time or since start of budget?
        }
    }
    
    public BudgetItem_Wrapper(BudgetItem__c budgetItem,Date budgetStartDate,Date[] budgetPeriodDates,String budgetInterval) {
        name = budgetItem.Name;
        type = budgetItem.Type__c;
        amount = budgetItem.Amount__c;
        frequency = budgetItem.Interval__c;
        frequencylabel = budgetItem.PaymentFrequency__c;
        startDate = budgetItem.StartDate__c;
        endDate = budgetItem.EndDate__c;
        
        relativeStartMonth = budgetStartDate.monthsBetween(startDate);
        relativeEndMonth = endDate == null ? 99999 : budgetStartDate.monthsBetween(endDate);
        
        budgetPeriods = new budgetPeriod[]{};
        
        for(Date budgetPeriodDate:budgetPeriodDates){
            budgetPeriods.add(new budgetPeriod(budgetPeriodDate, budgetStartDate, budgetInterval, this));
        }
    }

	    
    /*
     {
      "relativeStartMonth": -21,
      "relativeEndMonth": 14,
      "periodEndDate": "2022-12-31T23:59:59.999Z",
      "periodOffset": 23,
      "monthly": 0,
      "accrueCumulative": 0,
      "accrue": 0,
      "cumulative": 1060,
      "2021-12-31T23:59:59.999Z": 848,
      "2022-12-31T23:59:59.999Z": 1060
    }
    */
}