public with sharing class WarehouseCalloutService implements Queueable {

        private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

        //Method for calling external service
        @future(callout=true)
        public static void runWarehouseEquipmentSync() {
            
            // External service callout
            Http http = new Http();
            HttpRequest request = new HttpRequest();

            request.setEndpoint(WAREHOUSE_URL);
            request.setMethod('GET');

            HttpResponse response = http.send(request);
            
            List<Product2> warehouseEquipments = new List<Product2>();
            
            //Response handling
            if (response.getStatusCode() == 200) {
                List<Object> jsonResponse = (List<Object>) JSON.deserializeUntyped(response.getBody());
                System.debug(response.getBody());

                for (Object equipment : jsonResponse) {
                    Map<String, Object> mappedJson = (Map<String, Object>) equipment;
                    Product2 myEquipent = new Product2();
                    myEquipent.Replacement_Part__c = (Boolean) mappedJson.get('replacement');
                    myEquipent.Name = (String) mappedJson.get('name');
                    myEquipent.Maintenance_Cycle__c = (Integer) mappedJson.get('maintenanceperiod');
                    myEquipent.Lifespan_Months__c = (Integer) mappedJson.get('lifespan');
                    myEquipent.Cost__c = (Integer) mappedJson.get('cost');
                    myEquipent.Warehouse_SKU__c = (String) mappedJson.get('sku');
                    myEquipent.Current_Inventory__c = (Double) mappedJson.get('quantity');
                    myEquipent.ProductCode = (String) mappedJson.get('_id');
                    warehouseEquipments.add(myEquipent);
                }
            }

            if (warehouseEquipments.size() > 0) {
                upsert warehouseEquipments;
                System.debug('Your equipment was synced with the warehouse');
            }
       }
    }
    
    public static void execute (QueueableContext qc) {
        runWarehouseEquipmentSync();
    }
}