import 'package:research_package/model.dart';

List<RPChoice> feelingsChoices0 = [
  RPChoice.withParams("Envidioso", 3),
  RPChoice.withParams("Aterrado", 2),
  RPChoice.withParams("Arrogante", 1),
  RPChoice.withParams("Odioso", 0),
];

List<RPChoice> feelingsChoices1 = [
  RPChoice.withParams("Traviesa", 3),
  RPChoice.withParams("Confortante", 2),
  RPChoice.withParams("Irritada", 1),
  RPChoice.withParams("Aburrida", 0),
];

List<RPChoice> feelingsChoices2 = [
  RPChoice.withParams("Aterrada", 3),
  RPChoice.withParams("Triste", 2),
  RPChoice.withParams("Arrogante", 1),
  RPChoice.withParams("Molesto", 0),
];

List<RPChoice> feelingsChoices3 = [
  RPChoice.withParams("Bromista", 3),
  RPChoice.withParams("Aturdido", 2),
  RPChoice.withParams("Deseoso", 1),
  RPChoice.withParams("Convencido", 0),
];


RPChoiceAnswerFormat feelingsAnswerFormat0 =
    RPChoiceAnswerFormat.withParams(ChoiceAnswerStyle.SingleChoice, feelingsChoices0, 'assets/images/readmindeyes/0.png');
RPChoiceAnswerFormat feelingsAnswerFormat1 =
RPChoiceAnswerFormat.withParams(ChoiceAnswerStyle.SingleChoice, feelingsChoices1, 'assets/images/readmindeyes/1.png');
RPChoiceAnswerFormat feelingsAnswerFormat2 =
RPChoiceAnswerFormat.withParams(ChoiceAnswerStyle.SingleChoice, feelingsChoices2, 'assets/images/readmindeyes/2.png');
RPChoiceAnswerFormat feelingsAnswerFormat3 =
RPChoiceAnswerFormat.withParams(ChoiceAnswerStyle.SingleChoice, feelingsChoices3, 'assets/images/readmindeyes/3.png');

RPQuestionStep stepEmotions0 = RPQuestionStep.withAnswerFormat(
  "questionStep0ID",
  "¿Qué palabra define mejor esta expresión?",
  feelingsAnswerFormat0,
);
RPQuestionStep stepEmotions1 = RPQuestionStep.withAnswerFormat(
  "questionStep1ID",
  "¿Qué palabra define mejor esta expresión?",
  feelingsAnswerFormat1,
);
RPQuestionStep stepEmotions2 = RPQuestionStep.withAnswerFormat(
  "questionStep2ID",
  "¿Qué palabra define mejor esta expresión?",
  feelingsAnswerFormat2,
);
RPQuestionStep stepEmotions3 = RPQuestionStep.withAnswerFormat(
  "questionStep3ID",
  "¿Qué palabra define mejor esta expresión?",
  feelingsAnswerFormat3,
);



RPCompletionStep completionStep = RPCompletionStep("completionID")
  ..title = "Finished"
  ..text = "Thank you for filling out the survey!";

RPInstructionStep instructionStep = RPInstructionStep(
    identifier: "instructionID", title: "Welcome!", detailText: "For the sake of science of course...")
  ..text =
      "Please fill out this questionnaire!\n\nIn this questionnaire the questions will come after each other in a given order. You still have the chance to skip a some of them though.";

RPOrderedTask linearSurveyTask = RPOrderedTask(
  "surveyTaskID",
  [
    instructionStep,
    stepEmotions0,
    stepEmotions1,
    stepEmotions2,
    stepEmotions3,
    completionStep
  ],
);
