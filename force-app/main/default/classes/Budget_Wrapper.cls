global class Budget_Wrapper {
    
    public Date budgetStartDate {get;private set;}
    public BudgetItem__c[] budgetItems {get;set;}
    public BudgetItem_Wrapper[] expenditureItems {get;set;}
    public BudgetItem_Wrapper[] incomeItems {get;set;}
    public Date[] budgetPeriodDates {get;private set;}
    public Integer periods {get;private set;}
    public String interval {get;set;}
    public String calculationMode {get;private set;}
    public column[] columns {get;set;}
    public periodTotal[] periodTotals {
        get {
            return periodTotalMap.values();
        }
        private set;
    }
    private transient Map<Date,periodTotal> periodTotalMap = new Map<Date,periodTotal>();

    global class column {
        public String label {get;set;}
        public String fieldName {get;set;}
    }
    
    global class periodTotal {
        public Date period {get;set;}
        public Decimal income {get;set;}
        public Decimal expenditure {get;set;}
        public Decimal networth {get;set;}
        public Decimal balance {
            get {
            	return income - expenditure;
            }
            private set;
        }
        
        public periodTotal(Date periodDate) {
            period = periodDate;
			income = 0;
            expenditure = 0;
            networth = 0;
        }
    }
    
    public Budget_Wrapper(Date refDate,String i,Integer p,String c) {
        budgetStartDate = refDate;//DateExtension.endOfInterval(refDate,i);
        periods = p;
        calculationMode = c;
        interval = i;
        
        expenditureItems = new BudgetItem_Wrapper[]{};
        incomeItems = new BudgetItem_Wrapper[]{};
         
        budgetPeriodDates = new Date[]{};
        
        buildBudgetPeriodDates();
        
        retrieveBudgetItems();
    }
    
    private void buildBudgetPeriodDates() {
        for(Integer i = 1 ; i <= periods ; i++) {
            Date tmpDate = budgetStartDate.addMonths(i*(interval == 'Year' ? 12 : 1)).addDays(-1);
            budgetPeriodDates.add(tmpDate);
            periodTotalMap.put(tmpDate,new periodTotal(tmpDate));
            //budgetPeriodDates.add(DateExtension.addInterval(DateExtension.endOfInterval(budgetStartDate,interval),interval,i));
        }
    }
    
    private void retrieveBudgetItems() {
        //name: "RTYC", amount: 212, frequencylabel: "Quarterly", frequency: 3, startDate: "2019-04-01T00:00:00Z",endDate:"2022-03-31T00:00:00Z"}
        //if monthly, then exlcude based on end date, otherwise if cumulative we want everything after the start date

        budgetItems = [SELECT Name, 
                       Amount__c, 
                       StartDate__c, 
                       EndDate__c,
                       Interval__c,
                       Type__c,
                       PaymentFrequency__c
                       FROM BudgetItem__c
                       WHERE StartDate__c <= :budgetPeriodDates[budgetPeriodDates.size()-1] 
                       AND (EndDate__c = NULL OR EndDate__c >= :(calculationMode == 'cumulative' ? Date.newInstance(1970,01,01) : budgetStartDate))
                      ORDER BY Name];
        
        for(BudgetItem__c budgetItem:budgetItems){
            BudgetItem_Wrapper currentItem = new BudgetItem_Wrapper(budgetItem,budgetStartDate,budgetPeriodDates,interval);
            calculatePeriodTotals(currentItem);
            if(currentItem.type == 'Expenditure') {
            	expenditureItems.add(currentItem);
            } else if(currentItem.type == 'Income') {
                incomeItems.add(currentItem);
            }
            
        }
    }

    //calculates the period total, based upon the income and expenditure items
    private void calculatePeriodTotals(BudgetItem_Wrapper currentItem) {
        for(BudgetItem_Wrapper.budgetPeriod budgetPeriod:currentItem.budgetPeriods) {
            Decimal total = calculationMode == 'cumulative' ? budgetPeriod.cumulative : budgetPeriod.monthly;
            if(currentItem.type == 'Expenditure') {
            	periodTotalMap.get(budgetPeriod.periodEndDate).expenditure += total;
            } else if(currentItem.type == 'Income') {
                periodTotalMap.get(budgetPeriod.periodEndDate).income += total;
            }
        }
    }

}