import 'package:research_package/model.dart';

List<RPChoice> feelingsChoices0 = [
  RPChoice.withParams("Envidioso", 3),
  RPChoice.withParams("Aterrado", 2),
  RPChoice.withParams("Arrogante", 1),
  RPChoice.withParams("Odioso", 0),
];

List<RPChoice> tds0 = [
  RPChoice.withParams("Highly accurate", 4),
  RPChoice.withParams("Quite accurate", 3),
  RPChoice.withParams("Somewhat accurate", 2),
  RPChoice.withParams("Quite inaccurate", 1),
  RPChoice.withParams("Highly inaccurate", 0),
];

RPSliderAnswerFormat mySlider = RPSliderAnswerFormat.withParams(0, 5, prefix: "Highly inaccurate", suffix: "Highly accurate", divisions: 5);




RPChoiceAnswerFormat feelingsAnswerFormat0 =
RPChoiceAnswerFormat.withParams(ChoiceAnswerStyle.SingleChoice, feelingsChoices0, asset_path: 'assets/images/readmindeyes/0.png');

RPQuestionStep stepEmotions0 = RPQuestionStep.withAnswerFormat(
  "questionStep0ID",
  "¿Qué palabra define mejor esta expresión?",
  feelingsAnswerFormat0,
);

RPQuestionStep slider0 = RPQuestionStep.withAnswerFormat(
  "questionStep1ID",
  "Team membership is quite clear--everybody knows exactly who is and isn’t on this team.",
  mySlider,
);

RPCompletionStep completionStep = RPCompletionStep("completionID")
  ..title = "Finished"
  ..text = "Thank you for filling out the survey!";

RPInstructionStep instructionStep = RPInstructionStep(
    identifier: "instructionID", title: "Welcome!", detailText: "For the sake of science of course...")
  ..text =
      "Please fill out this questionnaire!\n\nIn this questionnaire the questions will come after each other in a given order. You still have the chance to skip a some of them though.";

RPOrderedTask linearSurveyTaskAlberto = RPOrderedTask(
  "surveyTDS",
  [
    instructionStep,
    stepEmotions0,
    slider0,
    completionStep
  ],
);
