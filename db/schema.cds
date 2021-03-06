namespace scp.cloud;
//begin add using statement

//end add using statement

using {
  managed,
  cuid,
  sap.common
} from '@sap/cds/common';

type Url : String;

type TechnicalBooleanFlag : Boolean @(
    UI.Hidden,
    Core.Computed
);

type TechnicalFieldControlFlag : Integer @(
    UI.Hidden,
    Core.Computed
);

type Criticality : Integer @(
    UI.Hidden,
    Core.Computed
);

type Identifier : String(100)@(title : 'Identifier');
@cds.autoexpose
abstract entity identified : cuid {
    identifier : Identifier not null;
}

//Bolded display of first table column values can be achieved by defining annotations Common.SemanticKey and
//Common.TextArrangement for the entities key and referring to a 'human-readable' identifier to be displayed instead.

annotate identified with @(
    Common.SemanticKey : [identifier],
    UI.Identification  : [{Value : identifier}]
) {

    ID         @Common : {
        Text            : identifier,
        TextArrangement : #TextOnly

    };
}
entity Incidents : managed, identified {
  title                   : String(50)                        @title : '{i18n>Title}';
  category                : Association to one Category       @title : '{i18n>Category}';
  priority                : Association to one Priority       @title : '{i18n>Priority}';
  incidentStatus          : Association to one IncidentStatus @title : '{i18n>IncidentStatus}';
  description             : String(1000)                      @title : '{i18n>IncidentDescription}';
  assignedIndividual      : Association to one Individual;
  incidentFlow            : Association to many IncidentFlow
                              on incidentFlow.incident = $self;
  incidentProcessTimeline : Association to many IncidentProcessTimeline
                              on incidentProcessTimeline.incident = $self;
  isDraft                 : TechnicalBooleanFlag not null default false;
  identifierFieldControl  : TechnicalFieldControlFlag not null default 7; // 7 = #Mandatory;
}

entity IncidentFlow : managed {
  key id             : UUID;
      processStep    : String(30)@title : '{i18n>ProcessStep}';
      stepStatus     : String(10)@title : '{i18n>ProcessStepStatus}';
      criticality    : Integer;
      stepStartDate  : Date      @title : '{i18n>StepStartDate}';
      stepEndDate    : Date      @title : '{i18n>StepEndDate}';
      @assert.integrity :                 false
      incident      : Association to Incidents;
}

entity IncidentProcessTimeline : managed {
  key id             : UUID;
      text           : String;
      type           : String;
      startTime      : DateTime;
      endTime        : DateTime;
      @assert.integrity : false
      incident  : Association to Incidents;
}

entity Individual : managed {
  key id                : UUID;
//Begin add additional properties

//End add additional properties
      @assert.integrity : false
      Incidents         : Association to many Incidents
                            on Incidents.assignedIndividual = $self;
}

entity IncidentsCodeList : common.CodeList {
  key code : String(20);
}

entity Category : IncidentsCodeList {}

entity Priority : IncidentsCodeList {
  criticality : Criticality not null default 3;
}

entity IncidentStatus : IncidentsCodeList {}

//add associations to external entities
