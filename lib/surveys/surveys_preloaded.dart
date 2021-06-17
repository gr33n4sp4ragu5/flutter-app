import 'package:collective_intelligence_metre/domain/CIMSurvey.dart';

import '../pages/linear_survey_page.dart';
import '../pages/tds.dart';

class PreloadedSurveys {
  List preloaded_surveys = [];

  void preloadSurveys() {
    List surveys = [];
    CIMSurvey read_mind_eyes = new CIMSurvey(LinearSurveyPage(), "ReadMindEyes", SurveyState.NEW, "ninguno", "Reading the mind in the eyes");
    CIMSurvey team_diagnostic_survey = new CIMSurvey(TDSSurveyPage(), "TeamDiagnosticSurvey", SurveyState.NEW, "ninguno", "Team Diagnostic Survey");
    surveys.add(read_mind_eyes);
    surveys.add(team_diagnostic_survey);
    preloaded_surveys = surveys;
  }
}