import 'package:research_package/model.dart';


RPSliderAnswerFormat accurateSlider = RPSliderAnswerFormat.withParams(0, 100, suffix: "% accurate", divisions: 4);

RPSliderAnswerFormat frequencySlider =
  RPSliderAnswerFormat.withParams(
      0, 100, suffix: "% accurate", divisions: 4,
      options: ["Never", "Not Frequently", "Somewhat Frequently",
                "Quite Frequently", "Very Frequently"]);

RPSliderAnswerFormat helpfulnessSlider =
  RPSliderAnswerFormat.withParams(
      0, 100, divisions: 4,
      options: ["Not at all helpful", "Not so helpful", "Somewhat helpful",
                "Very helpful", "Extremely helpful"]);

RPSliderAnswerFormat frequencySlider2 =
  RPSliderAnswerFormat.withParams(
      0, 100, divisions: 3,
      options: ["Never", "Seldom", "Sometimes", "Often"]);

RPSliderAnswerFormat agreementSlider =
RPSliderAnswerFormat.withParams(
    0, 100, divisions: 4,
    options: ["Strongly disagree", "Disagree", "Neither Agree nor Disagree", "Agree", "Strongly Agree"]);

RPQuestionStep bounded0 = RPQuestionStep.withAnswerFormat(
  "bounded0",
  "Team membership is quite clear--everybody knows exactly who is and isn’t on this team.",
  accurateSlider,
);
RPQuestionStep bounded1 = RPQuestionStep.withAnswerFormat(
  "bounded1",
  "There is so much ambiguity about who is on this team that it would be nearly impossible to generate an accurate membership list.",
  accurateSlider,
);
RPQuestionStep bounded2 = RPQuestionStep.withAnswerFormat(
  "bounded2",
  "Anyone who knows this team could accurately name all its members.",
  accurateSlider,
);

RPFormStep boundedFormStep = RPFormStep.withTitle(
  "formstepID",
  [bounded0, bounded1, bounded2],
  "Questions about group bound"
);

RPQuestionStep interdependent0 = RPQuestionStep.withAnswerFormat(
  "interdependent0",
  "Members of this team have their own individual jobs to do, with little need for them to work together.",
  accurateSlider,
);
RPQuestionStep interdependent1 = RPQuestionStep.withAnswerFormat(
  "interdependent1",
  "There is so much ambiguity about who is on this team that it would be nearly impossible to generate an accurate membership list.",
  accurateSlider,
);
RPQuestionStep interdependent2 = RPQuestionStep.withAnswerFormat(
  "interdependent2",
  "Anyone who knows this team could accurately name all its members.",
  accurateSlider,
);

RPFormStep interdependentFormStep = RPFormStep.withTitle(
    "formstepID3",
    [interdependent0, interdependent1, interdependent2],
    "Questions about group stability"
);
RPQuestionStep stable0 = RPQuestionStep.withAnswerFormat(
  "stable0",
  "Members of this team have their own individual jobs to do, with little need for them to work together.",
  accurateSlider,
);
RPQuestionStep stable1 = RPQuestionStep.withAnswerFormat(
  "stable1",
  "There is so much ambiguity about who is on this team that it would be nearly impossible to generate an accurate membership list.",
  accurateSlider,
);
RPQuestionStep stable2 = RPQuestionStep.withAnswerFormat(
  "stable2",
  "Anyone who knows this team could accurately name all its members.",
  accurateSlider,
);

RPFormStep stableFormStep = RPFormStep.withTitle(
    "formstepID2",
    [stable0, stable1, stable2],
    "Questions about group interdependency"
);

List<RPChoice> endsVsMeans = [
  RPChoice.withParams("The purposes of our team are specified by others, but the means and procedures we use to accomplish them are left to us.", 3),
  RPChoice.withParams("The means or procedures we are supposed to use in our work are specified in detail by others, but the purposes of our team are left unstated.", 2),
  RPChoice.withParams("Both the purposes of our team and the means or procedures we are supposed to use in our work are specified in detail by others.", 1),
  RPChoice.withParams("Neither the purposes nor the means are specified by others for our team.", 0),
];

RPChoiceAnswerFormat endsVsMeansAnswer =
RPChoiceAnswerFormat.withParams(ChoiceAnswerStyle.SingleChoice, endsVsMeans);

RPQuestionStep endVsMeansQuestion = RPQuestionStep.withAnswerFormat(
  "questionStep0ID",
  "Ends Vs Means",
  endsVsMeansAnswer,
);

RPCompletionStep completionStep = RPCompletionStep("completionID")
  ..title = "Finished"
  ..text = "Thank you for filling out the survey!";

RPInstructionStep instructionStep = RPInstructionStep(
    identifier: "instructionID", title: "Welcome!", detailText: "For the sake of science of course...")
  ..text =
      "Please fill out this questionnaire!\n\nIn this questionnaire the questions will come after each other in a given order. You still have the chance to skip a some of them though.";

RPOrderedTask tdsLinearSurveyTask = RPOrderedTask(
  "surveyTDS",
  [
    instructionStep,
    boundedFormStep,
    interdependentFormStep,
    stableFormStep,
    endVsMeansQuestion,
    completionStep
  ],
);
