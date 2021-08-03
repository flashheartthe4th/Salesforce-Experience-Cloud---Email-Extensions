public without sharing class DateExtension {
    
    public static date startOfInterval(Date refDate,String interval) {
        switch on interval {
            when 'Month' {
                return toStartOfMonth(refDate);
            }
            when 'Year' {
                return toStartOfYear(refDate);
            } 
            when else {
                return refDate;
            }
        }
    }
    
    public static date endOfInterval(Date refDate,String interval) {
        switch on interval {
            when 'Month' {
                return toEndOfMonth(refDate);
            }
            when 'Year' {
                return toEndOfYear(refDate);
            } 
            when else {
                return refDate;
            }
        }
    }
    
    public static date addInterval(Date refDate,String interval,Integer increment) {
        switch on interval {
            when 'Month' {
                return refDate.addMonths(increment);
            }
            when 'Year' {
                return refDate.addMonths(increment*12);
            } 
            when else {
                return refDate;
            }
        }
    }
    
    public static date toStartOfMonth(date refDate) {
        return refDate.toStartOfMonth();
    }
    
    public static date toEndOfMonth(date refDate) {
        return refDate.toStartOfMonth().addMonths(1).addDays(-1);
    }
    
    public static date toStartOfYear(date refDate) {
        return refDate.addMonths((refDate.month()*-1)+1).toStartOfMonth();
    }
    
    public static date toEndOfYear(date refDate) {
        return toStartOfYear(refDate).addMonths(12).toStartOfMonth().addDays(-1);
    }
}