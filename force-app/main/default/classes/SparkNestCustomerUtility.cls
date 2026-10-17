public with sharing class SparkNestCustomerUtility  {

    public static void processCustomerData() {

        String name = 'Spark Nest';
        Integer gadgetsCount = 10;
        Boolean isProfit = true;

        System.debug('Company Name: ' + name);
        System.debug('Total gadgets count: ' + gadgetsCount);
        System.debug('Is Profitable: ' + isProfit);

        List<String> customerNames = new List<String>{
            'Rahul Sharma',
            'Aman Verma',
            'Priya Singh',
            'Neha Kapoor',
            'Rahul Sharma'
        };

        System.debug('Customer List: ' + customerNames);

        for (String cname : customerNames) {
            System.debug('Customer: ' + cname);
        }

        Set<String> emails = new Set<String>{
            'rahul@gmail.com',
            'aman@gmail.com',
            'priya@gmail.com',
            'rahul@gmail.com',
            'neha@gmail.com'
        };

        System.debug('Unique Emails: ' + emails);

        Map<Integer, String> storeMap = new Map<Integer, String>();

        storeMap.put(101, 'Hyderabad');
        storeMap.put(102, 'Bengaluru');
        storeMap.put(103, 'Mumbai');

        String store = storeMap.get(102);
        System.debug('Store 102 City: ' + store);
        Map<String, Decimal> productPrices = new Map<String, Decimal>();

        productPrices.put('SparkNest Phone X1', 45000);
        productPrices.put('SparkNest Smart Speaker', 8000);
        productPrices.put('SparkNest Laptop Pro', 75000);

        Decimal laptopPrice =
            productPrices.get('SparkNest Laptop Pro');

        System.debug('SparkNest Laptop Pro Price: ' + laptopPrice);
    }


    public static Decimal calculateOrderValue(
        Integer quantity,
        Decimal unitPrice
    ) {
        return quantity * unitPrice;
    }
}