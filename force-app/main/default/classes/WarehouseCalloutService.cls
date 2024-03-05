public with sharing class WarehouseCalloutService implements Queueable{
    public WarehouseCalloutService() {


        private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

        //Method for calling external service
        @future(callout=true)
        public static void runWarehouseEquipmentSync(){
            
            // External service callout
            Http http = new Http();
            HttpRequest request = new HttpRequest();

            request.setEndpoint(WAREHOUSE_URL);
            request.setMethod('GET');

            HttpResponse response = http.send(request);
            
            List<Product2> warehouseEquipments = new List<Product2>;
            
            //Response handling
            if (response.getStatusCode == 200) {
                List<Object> jsonResponse = (List<Object>) JSON.deserializeUntyped(response.getBody());
                System.debug(response.getBody());
            }
        }

    }
}