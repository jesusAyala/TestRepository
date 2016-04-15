/**
 * ApexClass -  FindRootAccountClass 
 * Release R5
 * @author  Vasanthi (Accenture)
 * @created 2016-1-25
 * @version 1.0
 * Description: As per Req #2737(KAD-00820, KAD-00821) To find root account. (This class called from findRootAccountGUID_Batch class)
 * Created
 
  */
public class FindRootAccountClass {

    public  Map<Id, Id> accountIdAndTopParentIdMap = new Map<Id, Id>();
    public  Map<Id, Id> parentAndChildMap = new Map<Id, Id>();
    public  Set<Id> processedAccIdSet = new Set<Id>();
/**    
    *To find the root account
*/    
    public  Map<Id, Id> findTopMostParent(Set<Id> parentIdSet,  Map<Id, Id> accIdAndTopParIdMap,  Map<Id, Id> parentChildMap ) {
     
         Map<Id, Id> topParentMap = new Map<Id, Id>();
         accountIdAndTopParentIdMap = new Map<Id, Id>();
         parentAndChildMap = new Map<Id, Id>();        
         
         parentAndChildMap = parentChildMap ;
         accountIdAndTopParentIdMap = accIdAndTopParIdMap;
         topParentMap = recursiveFinding(parentIdSet);
         return topParentMap;
     }
/**    
    *To find the root account recursively
*/    
    public  Map<Id, Id> recursiveFinding(Set<Id> parentIdSet) {
        
        Set<Id> needToQueryAgainAccIdSet = new Set<Id>();
        
        if (parentIdSet.size() > 0) {
        
            Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
            Integer remainingQuery = limits.getLimitQueries() - limits.getQueries();
            
            if (remainingQuery > 0) {
                for (Account acc: [ SELECT Id, ParentId, Parent.ParentId, parent.parent.parentId, parent.parent.parent.parentId,
                    parent.parent.parent.parent.parentId, parent.parent.parent.parent.parent.parentId
                    FROM Account WHERE Id IN: parentIdSet LIMIT :remLimit ]) {
                    
                    Id parentId = null;
                    if(acc.parent.parent.parent.parent.parent.parentId != null) {
                        parentId = acc.parent.parent.parent.parent.parent.parentId;
                        needToQueryAgainAccIdSet.add(parentId);
                    } else if(acc.parent.parent.parent.parent.parentId != null) {
                        parentId =  acc.parent.parent.parent.parent.parentId;
                    } else if(acc.parent.parent.parent.parentId != null) {
                        parentId = acc.parent.parent.parent.parentId;
                    } else if(acc.parent.parent.parentId != null) {
                        parentId = acc.parent.parent.parentId;
                    } else if(acc.parent.parentId != null) {
                        parentId = acc.parent.parentId;
                    } else if(acc.parentId != null) {
                        parentId = acc.parentId;
                    } else {
                        parentId = acc.id;
                    }
                    Id childId = parentAndChildMap.get(acc.Id);
                    if (childId  != NULL) {                   
                        accountIdAndTopParentIdMap.put(childId , parentId);
                        parentAndChildMap.put(ParentId, childId); 
                    }
                }
            }
            
            if (needToQueryAgainAccIdSet.size() > 0) {
                recursiveFinding(needToQueryAgainAccIdSet);
            }
        }
        return accountIdAndTopParentIdMap;
    } 
    
}