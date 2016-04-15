/*************************************************************
@Name: APTS_BulkUploadProductsController
@Author: Axaykumar Varu
@CreateDate: 21st Oct 2015
@Description: This class create line items from the files uploaded by user.
@UsedBy: VF-Page : APTS_BulkUploadProducts & APTS_CreateLineItems
******************************************************************
@ModifiedBy: NA
@ModifiedDate: NA
******************************************************************/
public class APTS_BulkUploadProductsController {
    
    public Apttus_Config2__ProductConfiguration__c ProdConfigSobj {get; set;}
    public String quoteId{get; set;}
    public String Quotename{get; set;}
    public String Proposalname{get; set;}
    public String agreementNumber{get; set;}
    public String ApprovalStatus{get; set;}
    
    private String configId;
    private String configRequestId;
    private String flowName;
    
    private String distributionChannel;
    private String salesOrganization;
    
    //CSV File
    public transient Blob csvBody{get; set;}
    public String fileName{get; set;}
    public Boolean allowDuplicates{get; set;}
    public Boolean hasError{get; private set;}
    public Boolean showBlock{get; private set;}
    public List<CSVFileData> lstCSVData{get; private set;}
    public List<CSVLoadError> lstCSVDataErrors{get; private set;}
    public List<CSVFileData> lstCSVSampleData{get; private set;}
    private Set<String> uniqueProducts;
    private String applicableProductDiscounts, applicableHierarchyDiscounts; //todo: based on Discount Config object data - put all these validation
    private Map<String, String> mapProducts;
    private Set<String> productsOnCart;
    
    //CSV Delimiter
    private String DELIMITER;
    private String NEWLINE_DELIMITER = '\n'; //line feed char
    
    private static final String ID = 'Id';
    private static final String FLOW = 'Flow';
    private static final String CONFIG_REQUEST_ID = 'configRequestId';
    
    //Constructor
    public APTS_BulkUploadProductsController(){
         
         //get configuration Id          
         configId = Apexpages.Currentpage().getparameters().get(ID);
         //get temp object Id
         configRequestId = Apexpages.Currentpage().getparameters().get(CONFIG_REQUEST_ID);
         //get flow name
         flowName = Apexpages.Currentpage().getparameters().get(FLOW);
          
        this.ProdConfigSobj = [SELECT Id, Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.Name, 
        Apttus_CMConfig__AgreementId__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c,
        Apttus_QPConfig__Proposald__r.Apttus_QPApprov__Approval_Status__c, 
        Apttus_CMConfig__AgreementId__r.Apttus__FF_Agreement_Number__c,
        Apttus_Config2__BusinessObjectType__c, Apttus_QPConfig__Proposald__r.APTS_LP_Sales_Organization__c,
        Apttus_QPConfig__Proposald__r.APTS_LP_Distribution_Channel__c,
        Apttus_CMConfig__AgreementId__r.APTS_Distribution_Channel__r.APTS_Code__c,
        Apttus_QPConfig__Proposald__r.APTS_Distribution_Channel__r.APTS_Code__c,
        Apttus_CMConfig__AgreementId__r.APTS_LP_Sales_Organization__c,
        Apttus_QPConfig__Proposald__r.APTS_Product_Discounts__c,
        Apttus_QPConfig__Proposald__r.APTS_Hierarchy_Discounts__c,
        Apttus_CMConfig__AgreementId__r.APTS_Product_Discounts__c,
        Apttus_CMConfig__AgreementId__r.APTS_Hierarchy_Discounts__c,
        Apttus_CMConfig__AgreementId__r.Name,
        Apttus_CMConfig__AgreementId__r.APTS_SAP_Reference_No__c,
        Apttus_Config2__BusinessObjectId__c, Apttus_CMConfig__AgreementId__r.Apttus__Status__c,
        (SELECT Id, Apttus_Config2__ProductId__r.APTS_LP_Is_Hierarchy__c, 
        APTS_LP_Product_Hierarchy__c, APTS_LP_Product_Code__c FROM Apttus_Config2__LineItems__r)
        FROM Apttus_Config2__ProductConfiguration__c
        WHERE Id = :configId LIMIT 1];
        
        this.allowDuplicates = false;
        this.lstCSVData = new List<CSVFileData>();
        this.lstCSVDataErrors = new List<CSVLoadError>();
        this.showBlock = false;
        this.mapProducts = new Map<String, String>();
        this.uniqueProducts = new Set<String>();
        this.productsOnCart = new Set<String>();
        this.lstCSVSampleData = new List<CSVFileData>();
        
        if(ProdConfigSobj.Apttus_Config2__BusinessObjectType__c == 'Proposal'){
            
            this.distributionChannel = ProdConfigSobj.Apttus_QPConfig__Proposald__r.APTS_Distribution_Channel__r.APTS_Code__c;
            this.salesOrganization = ProdConfigSobj.Apttus_QPConfig__Proposald__r.APTS_LP_Sales_Organization__c;
            this.applicableProductDiscounts = ProdConfigSobj.Apttus_QPConfig__Proposald__r.APTS_Product_Discounts__c;
            this.applicableHierarchyDiscounts = ProdConfigSobj.Apttus_QPConfig__Proposald__r.APTS_Hierarchy_Discounts__c;
            this.Quotename = ProdConfigSobj.Apttus_QPConfig__Proposald__r.Name;
            this.Proposalname = ProdConfigSobj.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c;
            this.ApprovalStatus = ProdConfigSobj.Apttus_QPConfig__Proposald__r.Apttus_QPApprov__Approval_Status__c;
            
        }else if(ProdConfigSobj.Apttus_Config2__BusinessObjectType__c == 'Agreement'){
            
            this.distributionChannel = ProdConfigSobj.Apttus_CMConfig__AgreementId__r.APTS_Distribution_Channel__r.APTS_Code__c;
            this.salesOrganization = ProdConfigSobj.Apttus_CMConfig__AgreementId__r.APTS_LP_Sales_Organization__c;
            this.applicableProductDiscounts = ProdConfigSobj.Apttus_CMConfig__AgreementId__r.APTS_Product_Discounts__c;
            this.applicableHierarchyDiscounts = ProdConfigSobj.Apttus_QPConfig__Proposald__r.APTS_Hierarchy_Discounts__c;
            this.Quotename = ProdConfigSobj.Apttus_CMConfig__AgreementId__r.Name;
            this.Proposalname = '';//ProdConfigSobj.Apttus_CMConfig__AgreementId__r.Name;
            this.agreementNumber = ProdConfigSobj.Apttus_CMConfig__AgreementId__r.APTS_SAP_Reference_No__c;
            this.ApprovalStatus = ProdConfigSobj.Apttus_CMConfig__AgreementId__r.Apttus__Status__c;
            
        }else{
            
            this.hasError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Bulk load functionality is supported only for Quotation & Agreements. Please click on "Return" to go back to previous page.'));
        }
        
        this.quoteId = ProdConfigSobj.Apttus_Config2__BusinessObjectId__c;
        this.createSampleCSVFile();
    }
    
    public PageReference uploadCSV(){
        
        try{
            //System.debug('FileName: '+fileName);
            if(fileName != null){
                
                List<String> lstFileName = fileName.split('\\.');
                
                if(lstFileName.size() > 1 && lstFileName[1].toLowerCase() != 'csv'){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Incorrect File Format, Please Upload .CSV File'));
                    return null;
                }
            }
            
            
            String csvString = csvBody.toString();
            csvBody = null;
            
            List<String> csvFileLines = csvString.split(NEWLINE_DELIMITER);
            Set<String> setProdCode = new Set<String>();
            Set<String> setProdHierarchyCode = new Set<String>();
            
            if(csvFileLines.size() <= 1){
                csvFileLines.clear();
                csvFileLines = csvString.trim().split('    ');
            }
            
            if(csvFileLines.size() <= 1){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'File is blank, please upload file with data.'));
                return null;
            }
            
            //check for delimiter
            DELIMITER = getCSVDelimiter(csvFileLines[0].trim());
            system.debug('***DELIMITER: '+DELIMITER);
            if(DELIMITER == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid CSV file. please upload correct CSV file.'));
                return null;
            }
            
            for(Integer i = 1; i < csvFileLines.size(); i++){//start with 1 - skip header row.
                
                system.debug('Row: '+i+' --> '+csvFileLines[i]);
                //String cleanString = parseString(csvFileLines[i], 0);
                String cleanString = parseCSVRow(csvFileLines[i]);
                
                List<String> row = cleanString.trim().split(DELIMITER);
                System.debug('row: '+row);
                String prodHierarchyCode = row.size() > 0 && row.get(0) != null && row.get(0).trim() != '' ? row.get(0).trim() : null;//first column
                String prodCode = row.size() > 1 && row.get(1) != null && row.get(1).trim() != '' ? row.get(1).trim() : null;//second column
                Boolean isHierarchyProduct = prodCode != null ? false : true;
                String discountType = row.size() > 3 && row.get(3) != null && row.get(3) != '' ? getDiscountType(row.get(3))  : null;//fourth column
                system.debug('QTY: '+row.get(2)+' --> discountType: '+row.get(3));
                if(row.size()>4){
                    system.debug(' --> disc%: '+row.get(4));
                }
                String quantity = row.size() > 2 ? ( row.get(2) != null && row.get(2).trim() != '' ? replaceComma(row.get(2).trim()) : '1' ) : '1';//third column - default qty is 1.
                String discountPercent = row.size() > 4 && row.get(4).trim() != '' ? replaceComma(row.get(4).trim()) : null;//fifth column
                String netPrice = row.size() > 5 && row.get(5).trim() != '' ? replaceComma(row.get(5).trim()) : null;//sixth column
                
                if(prodHierarchyCode != null){
                    prodHierarchyCode = prodHierarchyCode.startsWith('00') ? prodHierarchyCode : '00' + prodHierarchyCode;
                }
                
                CSVFileData csvRoW = new CSVFileData(prodHierarchyCode, prodCode, quantity, discountType, discountPercent, netPrice, i+1);
                
                lstCSVData.add(csvRoW);
                
                system.debug('csvRoW: '+csvRoW);
                
                if(isHierarchyProduct){
                    System.debug('prodHierarchyCode: '+prodHierarchyCode);
                    setProdHierarchyCode.add(prodHierarchyCode);
                }else{
                    System.debug('prodCode: '+prodCode);
                    setProdCode.add(prodCode);
                }
            }
            
            if(setProdCode.size() > 0){
                for(Product2 prod : [SELECT Id, ProductCode 
                                    FROM Product2 
                                    WHERE IsActive = true
                                    AND ProductCode IN :setProdCode
                                    AND RecordType.Name = :APTS_Constants.LOCAL_PRODUCTS
                                    AND APTS_LP_Distribution_Channel__c = :distributionChannel
                                    AND APTS_LP_Sales_Organization__c = :salesOrganization]){
                    
                    mapProducts.put(prod.ProductCode, prod.Id);
                    //system.debug('Product Code: '+prod.ProductCode+' --> prod.Id: '+prod.Id);
                }
            }
            
            if(setProdHierarchyCode.size() > 0){
                
                for(Product2 prod : [SELECT Id, APTS_Hierarchy_Level_3_Code__c 
                                    FROM Product2 
                                    WHERE IsActive = true
                                    AND APTS_Hierarchy_Level_3_Code__c IN :setProdHierarchyCode
                                    AND RecordType.Name = :APTS_Constants.LOCAL_HIERACHY
                                    AND APTS_Hierarchy_level__c = 3
                                    AND APTS_LP_Is_Hierarchy__c = true
                                    AND APTS_Hierarchy_Level_4_Code__c = NULL]){
                    
                    mapProducts.put(prod.APTS_Hierarchy_Level_3_Code__c, prod.Id);
                    //system.debug('ProdHierarchyCode: '+prod.APTS_Hierarchy_Level_3_Code__c+' --> prod.Id: '+prod.Id);
                }
            }
            
            for(Apttus_Config2__LineItem__c lineItem : ProdConfigSobj.Apttus_Config2__LineItems__r){
                String code = lineItem.APTS_LP_Product_Code__c != null ? lineItem.APTS_LP_Product_Code__c : lineItem.APTS_LP_Product_Hierarchy__c;
                productsOnCart.add(code);
            }
            
            if(lstCSVData.size() > 0){
                
                for(CSVFileData csvRow : lstCSVData){
                    
                    csvRoW.isErrorProne = checkCSVExceptions(csvRoW);
                    uniqueProducts.add(csvRoW.getProductCode());
                }
            }
            
        }catch(Exception exp){
            system.debug('ERROR Occurred:'+exp);
            this.hasError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Occurred, Please make sure input CSV file is correct.'));
            return null;
        }
        
        PageReference pref = Page.APTS_CreateLineItems;
        pref.getParameters().put(ID, configId);
        pref.getParameters().put(CONFIG_REQUEST_ID, configRequestId);
        pref.getParameters().put(FLOW, flowName);
        pref.setRedirect(false);
        return pref;
    }
    
    //method to get CSV delimiter
    private String getCSVDelimiter(String headerRow){
        
        if(headerRow.contains(',')){
            return ',';//comma delimiter
        }else if(headerRow.contains(';')){
            return ';';//semi-colom delimiter
        }else if(headerRow.contains('   ')){
            return '    ';//tab delimiter
        }else if(headerRow.contains(':')){
            return ':';//colon delimiter
        }
        
        return null;//in valid file
    }
    
    private String getDiscountType(String discountCode){
        
        if(discountCode.toLowerCase().equals('n') || discountCode.toLowerCase().equals('net price') || discountCode.toLowerCase().equals('net price discount')){
            return 'N';
        }
        
        if(discountCode.toLowerCase().equals('s') || discountCode.toLowerCase().equals('substitute') || discountCode.toLowerCase().equals('substitute discount')){
            return 'S';
        }
        
        return discountCode;
    }
    
    private Decimal stringToDecimal(String stringToConvert){
        
        return Decimal.valueOf(stringToConvert);
    }
    
    private Boolean isValidQuantity(String qty){
        
        try{
            if(Decimal.valueOf(qty) > 0){
                return true;
            }
        }catch(Exception exp){}
        
        return false;
    }
    
    private Boolean isValidDecimal(String inputString){
        
        Boolean isValid = true;
        try{
            Decimal d = Decimal.valueOf(inputString);
        }catch(Exception exp){
            isValid =  false;
        }
        
        return isValid;
    }
    
    private Boolean isValidInteger(String qty){
        
        Boolean isValid = true;
        try{
            Decimal dec = Decimal.valueOf(qty);
            Integer intVal = Integer.valueOf(qty);
            if(Decimal.valueOf(intVal) != dec){
                isValid = false;
            }
            
        }catch(Exception e){
            isValid = false;
        }
        
        return isValid;
    }
    
    private Boolean isValidNetPrice(String netP){
        
        if(Decimal.valueOf(netP) <= 0){
            return false;
        }
        
        return true;
    }
    
    private Boolean isValidDiscount(String inputDiscount){
        
        Decimal disc = Decimal.valueOf(inputDiscount);
        if(disc <= 0 || disc >= 100){
            return false;
        }
        
        return true;
    }
    
    private Boolean isValidHierarchyQuantity(String qty){
        return qty == '1' ?  true : false;
    }
    
    private String replaceComma(String inputString){
        
        if(DELIMITER == ';' && inputString != null){
            
            List<String> tempString = inputString.split(',');
            
            if(tempString.size() == 1){
                
                tempString[0] = tempString[0].replace('.','');
                inputString = String.join(tempString,'.');
            }
            
            if(tempString.size() == 2){
                
                tempString[0] = tempString[0].replace('.','');
                tempString[1] = tempString[1].replace(',','.');
                inputString = String.join(tempString,'.');
            }
            
        }
        
        if(DELIMITER == ',' && inputString != null){
            
            List<String> tempString = inputString.split('.');
            
            if(tempString.size() == 1){
                
                tempString[0] = tempString[0].replace(',','');
                inputString = String.join(tempString,'.');
            }
            
            if(tempString.size() == 2){
                
                tempString[0] = tempString[0].replace(',','');
                tempString[1] = tempString[1].replace('.',',');
                inputString = String.join(tempString,'.');
            }
        }
        
        return inputString;
    }
    
    /*
    public String parseString(String str, Integer count){
        
        try{
            str = str.trim();
            Integer ind = str.indexOf('"');
            if(ind == -1){
                
                if(str.contains(DELIMITER) && count > 0){
                    str = str.remove(DELIMITER);
                    //system.debug('index-1: '+str);
                }
                return str;
            }
            String subString1 = str.subString(0, ind);
            
            if(count > 0){
                subString1 = subString1.remove(DELIMITER) + DELIMITER;
            }
            
            if(subString1 == DELIMITER){
                subString1 = ' ';
            }
            
            //System.debug('subString1: '+subString1);
            String subString2 = str.subString(ind+1, str.length());
            //System.debug('subString2: '+subString2);
            return subString1 + parseString(subString2, ++count);
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
        return null;
    }*/
    
    private String parseCSVRow(String rowToParse){
        
        Integer firstOccurrence = rowToParse.indexOf('"');
        String thousandSeparator = DELIMITER == ';' ? '.' : ',';
        
        if(firstOccurrence == -1){
            return rowToParse.trim();
        }
        
        String temp1 = rowToParse.subString(0, firstOccurrence);
        System.debug('temp1: '+temp1);//first part
        
        String temp2 = rowToParse.subString(firstOccurrence + 1, rowToParse.length());
        System.debug('temp2: '+temp2);
        
        Integer secondOccurrence = temp2.indexOf('"');
        String cellValue = temp2.subString(0, secondOccurrence);
        System.debug('cellValue: '+cellValue);
        
        temp2 = temp2.subString(secondOccurrence + 1, temp2.length());
        System.debug('temp2: '+temp2);
        
        if(cellValue.contains(thousandSeparator)){
            cellValue = cellValue.remove(thousandSeparator);
            System.debug('cellValue: '+cellValue);
        }
        
        String parsedRow = temp1  + cellValue + temp2; //temp1 = first part of row + cell Value (which we have removed thousand separator) + temp2 = second part of row
        System.debug('parsedRow: '+parsedRow);
        
        return parseCSVRow(parsedRow);
    }

    public void loadCartLines(){
        
        try{
        
            if(lstCSVDataErrors.size() > 0){
                return;
            }
            
            //system.debug('allowDuplicates: '+allowDuplicates);
            
            Apttus_CPQApi.CPQ.AddMultiProductRequestDO requests = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
            List<Apttus_CPQApi.CPQ.SelectedProductDO> selectedProdDOList = new List<Apttus_CPQApi.CPQ.SelectedProductDO>();
            requests.CartId = configId;
            
            List<Apttus_Config2__LineItem__c> lstLineItems = new List<Apttus_Config2__LineItem__c>();
            Map<String, Apttus_Config2__LineItem__c> mapCodeLineItems = new Map<String, Apttus_Config2__LineItem__c>();
            Map<String, String> mapDiscountType = new Map<String, String>{
                'N' => 'Net Price Discount',
                'S' => 'Substitute Discount'
            };
            
            Map<String, String> mapDiscountField = new Map<String, String>{
                'N' => 'APTS_Net_Price_Override__c',
                'S' => 'APTS_Discount_Percentage__c'
            };
            
            for(Apttus_Config2__LineItem__c lineItem : [SELECT Id, APTS_LP_Product_Hierarchy__c, APTS_LP_Product_Code__c 
                                                       FROM Apttus_Config2__LineItem__c 
                                                       WHERE Apttus_Config2__ConfigurationId__c = :configId]){
                
                String code = lineItem.APTS_LP_Product_Code__c != null ? lineItem.APTS_LP_Product_Code__c : lineItem.APTS_LP_Product_Hierarchy__c;
                mapCodeLineItems.put(code, lineItem);
            }
            
            for(CSVFileData csvRow : lstCSVData){
                
                String prodCode = csvRow.getProductCode();
                system.debug(csvRow.isHierarchyProduct() +'-> Hierarchy: ' +csvRow.prodHierarchyCode + ' -- Prod Code: '+csvRow.prodCode);
                system.debug('PROD: '+mapProducts.get(prodCode));
                
                //logic for upsert
                if((allowDuplicates && mapCodeLineItems.containsKey(prodCode)) || !mapCodeLineItems.containsKey(prodCode)){
                    //create new
                    //System.debug('***Inserting New line: '+prodCode);
                    Apttus_CPQApi.CPQ.SelectedProductDO prodDO = new Apttus_CPQApi.CPQ.SelectedProductDO();
                    prodDO.ProductId = mapProducts.get(prodCode);
                    prodDO.Quantity = stringToDecimal(csvRow.quantity);
                    prodDO.SellingTerm = 1;
                    Apttus_Config2__LineItem__c line = new Apttus_Config2__LineItem__c();
                    
                    line.APTS_Discount_Type__c = mapDiscountType.get(csvRow.discountType);
                    line.put(mapDiscountField.get(csvRow.discountType), stringToDecimal(csvRow.getDiscount()));
                    
                    prodDO.CustomFields = new List<String>();
                    prodDO.CustomFields.add('APTS_Discount_Type__c');
                    prodDO.CustomFields.add('APTS_Discount_Percentage__c');
                    prodDO.CustomFields.add('APTS_Net_Price_Override__c');
                    prodDO.CustomData = line;
                    
                    selectedProdDOList.add(prodDO);
                    
                }
                
                if(!allowDuplicates && mapCodeLineItems.containsKey(prodCode)){
                    //update existing
                    Apttus_Config2__LineItem__c line = mapCodeLineItems.get(prodCode);
                    line.Apttus_Config2__PricingStatus__c = 'Pending';
                    line.Apttus_Config2__Quantity__c = stringToDecimal(csvRow.quantity);
                    line.APTS_Discount_Type__c = mapDiscountType.get(csvRow.discountType);
                    line.put(mapDiscountField.get(csvRow.discountType), stringToDecimal(csvRow.getDiscount()));
                    //System.debug('***Updating Existing line: '+line.Id);
                    lstLineItems.add(line);
                }
            }
            
            if(selectedProdDOList.size() > 0){
                
                requests.SelectedProducts = selectedProdDOList;
                Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(requests);
            }
            
            if(lstLineItems.size() > 0){
                update lstLineItems;
            }
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
    }
    
    
    private Boolean checkCSVExceptions(CSVFileData csvRoW){
        
        Boolean hasError = true;
        //System.debug('mapProducts: '+mapProducts);
        //System.debug('uniqueProducts: '+uniqueProducts);
        if(csvRow.getProductCode() != null && !mapProducts.containsKey(csvRow.getProductCode())){
            System.debug('Product not found: '+csvRow.getProductCode());
            lstCSVDataErrors.add(new CSVLoadError(csvRow, 'Product Code/Product Hierarchy Code not found in the System.'));
        }
        
        else if(!allowDuplicates && productsOnCart.contains(csvRoW.getProductCode())){//!uniqueProducts.contains(csvRoW.getProductCode()) && 
            lstCSVDataErrors.add(new CSVLoadError(csvRow, 'Produt/Product Hierarchy is already exist on cart.'));
        }
                    
        else if(!allowDuplicates && uniqueProducts.contains(csvRoW.getProductCode())){
            lstCSVDataErrors.add(new CSVLoadError(csvRow, 'Duplicate Produt/Product Hierarchy Code found within sheet.'));
        }
        
        else if(csvRoW.prodHierarchyCode == null && csvRoW.prodCode == null){
            lstCSVDataErrors.add(new CSVLoadError(csvRow, 'Product/ Product Hierarchy Code is not specified.'));
        }
        
        else if(csvRoW.discountType == null && (csvRoW.netPrice != null || csvRoW.discountPercent != null)){
            lstCSVDataErrors.add(new CSVLoadError(csvRow, 'Discount type cannot be blank, if you have applied \'Net Price\' or \'Substitute Discount\'.'));
        }
        
        else if((csvRoW.isHierarchyProduct() && csvRoW.discountType != 'S') || (!csvRoW.isHierarchyProduct() && csvRoW.discountType != 'N') || (csvRoW.discountType != 'N' && csvRoW.discountType != 'S' && csvRoW.discountType != null)){
            String str = csvRoW.isHierarchyProduct() ? 'Valid discount for Product Hierarchy Code is \'Substitute Discount\' or \'S\'' : 'Valid discount for Product Code is \'Net Price\' or \'N\'.';
            lstCSVDataErrors.add(new CSVLoadError(csvRow, str));
        }
        
        else if(csvRoW.discountType == 'N' && csvRoW.discountPercent != null && csvRoW.netPrice == null){
            lstCSVDataErrors.add(new CSVLoadError(csvRow, 'Cannot apply Discount % when Net price discount is given.'));
        }
        
        else if(csvRoW.discountType == 'N' && csvRoW.netPrice == null){
            lstCSVDataErrors.add(new CSVLoadError(csvRow, 'Net Price cannot be blank when Net Price discount is given.'));
        }
        
        else if(csvRoW.discountType == 'S' && csvRoW.discountPercent == null && csvRoW.netPrice != null){
            lstCSVDataErrors.add(new CSVLoadError(csvRow, 'Cannot apply net price discount when substitute discount is given.'));
        }
        
        else if(csvRoW.discountType == 'S' && csvRoW.discountPercent == null){
            lstCSVDataErrors.add(new CSVLoadError(csvRow, 'Discount % cannot be blank when Substitute Discount is applied.'));
        }
        /*
        else if(!isValidDecimal(csvRoW.quantity) || !isValidQuantity(csvRoW.quantity)){
            lstCSVDataErrors.add(new CSVLoadError(csvRow, 'Quantity must be a positive number.'));
        }*/
        
        else if(!isValidInteger(csvRoW.quantity)){
            lstCSVDataErrors.add(new CSVLoadError(csvRow, System.Label.APTS_QuantityDecimalCheck));
        }
        
        else if(csvRoW.isHierarchyProduct() && !isValidHierarchyQuantity(csvRoW.quantity)){
            lstCSVDataErrors.add(new CSVLoadError(csvRow, 'Hierarchy quantity should always be 1.'));
        }
        
        else if(csvRoW.discountType == 'S' && !isValidDecimal(csvRoW.discountPercent)){
            lstCSVDataErrors.add(new CSVLoadError(csvRow, 'Discount % must be a Number.'));
        }
        
        else if(csvRoW.discountType == 'S' && !isValidDiscount(csvRoW.discountPercent)){
            lstCSVDataErrors.add(new CSVLoadError(csvRow, 'Discount % must be between 0 & 100.'));
        }
        
        else if(csvRoW.discountType == 'N' && !isValidDecimal(csvRoW.netPrice)){
            lstCSVDataErrors.add(new CSVLoadError(csvRow, 'Net Price must be a Number.'));
        }
        
        else if(csvRoW.discountType == 'N' && !isValidNetPrice(csvRoW.netPrice)){
            lstCSVDataErrors.add(new CSVLoadError(csvRow, 'Net Price must be a positive Number.'));
        }
        
        else{
            hasError = false;
        }
        
        return hasError;
    }
    
    public void reRenderPanel(){
        this.showBlock = true;
    }
    
    public PageReference doAbandon(){
        
        try{
            //delete current configuration on abandon.
            delete ProdConfigSobj;         
            
            //redirect to quote/mspa    
            return new PageReference('/'+quoteId);
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
        return null;
    }
    
    public PageReference goToCatalog(){
        return null;
    }
    
    public PageReference redirectToPricing(){
        
        PageReference pref = Page.Apttus_Config2__Pricing;
        pref.getParameters().put(ID, configId);
        pref.getParameters().put(CONFIG_REQUEST_ID, configRequestId);
        pref.getParameters().put(FLOW, flowName);
        pref.setRedirect(true);
        return pref;
    }
    
    public PageReference goBack(){
        
        PageReference pref = Page.APTS_BulkUploadProducts;
        pref.getParameters().put(ID, configId);
        pref.getParameters().put(CONFIG_REQUEST_ID, configRequestId);
        pref.getParameters().put(FLOW, flowName);
        pref.setRedirect(true);
        return pref;
    }
    
    public PageReference backToCatalog(){
        
        PageReference pref = Page.APTS_ConfigureProductsCustom;
        pref.getParameters().put(ID, configId);
        pref.getParameters().put(CONFIG_REQUEST_ID, configRequestId);
        pref.getParameters().put(FLOW, flowName);
        pref.setRedirect(true);
        return pref;
    }
    
    public PageReference downloadSampleCSV(){
        
        PageReference pref = Page.APTS_SampleBulkUploadCSVFile;
        pref.setRedirect(false);
        return pref;
    }
    
    private void createSampleCSVFile(){
        
        lstCSVSampleData.add(new CSVFileData(null, 'GHS2810164R0064', '1', 'N', null, '34.66', 1));
        lstCSVSampleData.add(new CSVFileData(null, '2CCF008856R0001', '1', 'N', null, '50.00', 2));
        lstCSVSampleData.add(new CSVFileData(null, '2CCA017429R0001', '1', 'N', null, '35', 3));
        lstCSVSampleData.add(new CSVFileData(null, '2CCS891001R0061', '1', 'N', null, '2047.28', 4));
        lstCSVSampleData.add(new CSVFileData(null, '2CDL200001R2502', '1', 'N', null, '2230.39', 5));
        lstCSVSampleData.add(new CSVFileData(null, '2CCF008681R0001', '1', 'N', null, '512.56', 6));
        lstCSVSampleData.add(new CSVFileData(null, '2CDS251001R0157', '1', 'N', null, '1736.57', 7));
        
        lstCSVSampleData.add(new CSVFileData('00S01', null, '1', 'S', '45.00', null, 8));
        lstCSVSampleData.add(new CSVFileData('00S02', null, '1', 'S', '36.80', null, 9));
        lstCSVSampleData.add(new CSVFileData('00S04', null, '1', 'S', '67.00', null, 10));
        lstCSVSampleData.add(new CSVFileData('00S05', null, '1', 'S', '43.40', null, 11));
        lstCSVSampleData.add(new CSVFileData('00C01', null, '1', 'S', '72.37', null, 12));
        lstCSVSampleData.add(new CSVFileData('00C02', null, '1', 'S', '72.38', null, 13));
        lstCSVSampleData.add(new CSVFileData('00C03', null, '1', 'S', '72.38', null, 14));
    }
    
    public class CSVFileData{
        
        public String prodHierarchyCode {get; private set;}
        public String prodCode {get; private set;}
        public String quantity {get; private set;}
        public String discountType {get; private set;}
        public String discountPercent {get; private set;}
        public String netPrice {get; private set;}
        public Boolean isErrorProne{get; set;}
        public Integer seq {get; private set;}
        
        public CSVFileData(String prodHierarchyCode, String prodCode, String quantity, String discountType, 
        String discountPercent, String netPrice, Integer seq){
                
                this.prodHierarchyCode = prodHierarchyCode;
                this.prodCode = prodCode;
                this.quantity = quantity;
                this.discountType = discountType;
                this.discountPercent = discountPercent;
                this.netPrice = netPrice;
                this.isErrorProne = false;
                this.seq = seq;
        }
        
        public Boolean isHierarchyProduct(){
            return this.prodCode != null ? false : true;
        }
        
        public String getDiscount(){
            return this.discountType == 'S' ? this.discountPercent : this.netPrice;
        }
        
        public String getProductCode(){
            return this.prodCode != null ? this.prodCode : this.prodHierarchyCode;
        }
        
    }
    
    public class CSVLoadError{
        
        public CSVFileData data{get; set;}
        public String error{get; set;}
        //public Boolean isValidDec {get; private set;}
        //public Decimal netAmountCurrency{get; private set;}
        
        public CSVLoadError(CSVFileData data, String error){
            
            this.data = data;
            this.error = error;
            //this.isValidDec = isValidDecimal();
        }
        /*
        public String getDynamicFormatString(){
            
            if(this.isValidDec){
                
                Decimal value = 1000.10;
                String formattedValue = value.format();
                String thousandSep = formattedValue.substring(1,2);
                String decimalSep = formattedValue.substring(5,6);
                return '{0,number,#'+thousandSep+'###'+thousandSep+'##0'+decimalSep+'00}';   
            }
            
            return '{0}';
        }
        
        private Boolean isValidDecimal(){
            
            Boolean isValid = true;
            try{
                this.netAmountCurrency = Decimal.valueOf(this.data.netPrice);
            }catch(Exception exp){
                isValid =  false;
            }
            
            return isValid;
        }*/
    }
}