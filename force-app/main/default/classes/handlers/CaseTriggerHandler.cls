public class CaseTriggerHandler extends AbstractTriggerHandler {

    public class Factory implements TriggerHandlerFactory {
        public TriggerHandler create(List<SObject> objects, Map<Id, SObject> oldObjectsById) {
            return new CaseTriggerHandler(objects, oldObjectsById);
        }
    }

    private final List<Case> cases;
    private final Map<Id, Case> oldCasesById;

    private CaseTriggerHandler(List<SObject> cases, Map<Id, SObject> oldCasesById) {
        this.cases = cases;
        this.oldCasesById = (Map<Id, Case>) oldCasesById;
    }

    public override void afterInsert() {
        CaseController.updateAccountCount(cases, oldCasesById);
    }

    public override void afterUpdate() {
        CaseController.updateAccountCount(cases, oldCasesById);
    }

    public override void afterDelete() {
        CaseController.updateAccountCount(cases, oldCasesById);
    }

}