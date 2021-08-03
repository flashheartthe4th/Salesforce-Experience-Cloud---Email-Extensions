public without sharing class FinancialCalculations {
    
    public static Decimal simpleInterest(Decimal rate,Decimal principal,Date startDate,Date endDate) {
        return simpleInterest(rate, principal, startDate.monthsBetween(endDate));
    }

    public static Decimal simpleInterest(Decimal rate,Decimal principal,Integer periods) {
        return principal * (1 + (rate * periods));
    }

    public static Decimal futureValue(Decimal rate,Date startDate,Date endDate,Decimal paymentAmount) {

        return futureValue(rate, startDate.monthsBetween(endDate), paymentAmount, 0, 0);
    }

    public static Decimal futureValue(Decimal rate,Integer periods,Decimal paymentAmount) {
        return futureValue(rate, periods, paymentAmount, 0, 0);
    }

    public static Decimal futureValue(Decimal rate,Integer periods,Decimal paymentAmount,Decimal presentValue,Integer type) {
        Decimal pow = Math.pow((1.00 + rate).doubleValue(), Double.valueOf(periods));
        Decimal fv = 0;
        if (rate == 0) {
            fv = -1 * (presentValue + (paymentAmount*-1) * periods);
        } else {
            fv = ((paymentAmount*-1)*(1+rate*type)*(1-pow)/rate)-presentValue*pow;
        }

        return fv.setScale(2);
        
    }
}
