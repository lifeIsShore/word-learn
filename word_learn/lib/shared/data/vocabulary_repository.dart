import '../models/flashcard_item.dart';

/// Central vocabulary source. Parses the embedded CSV data for each level.
/// When Flutter asset loading is wired (WL-600), swap _raw* constants for
/// rootBundle.loadString() calls. For now the data is inlined so the app
/// runs without additional asset plumbing.
class VocabularyRepository {
  // ── Public API ────────────────────────────────────────────────────────────

  /// Words for [cefrLevel] in [targetLanguage].
  /// [targetLanguage] is currently 'de' (German); extend for WL-610.
  static List<FlashcardItem> getWords({
    String targetLanguage = 'de',
    String cefrLevel = 'b2',
  }) {
    final key = '${targetLanguage}_$cefrLevel';
    final raw = _data[key] ?? _data['de_b2']!;
    return _parse(raw, prefix: key);
  }

  /// Quick fallback for dev/demo mode — returns a stable 10-word list.
  static List<FlashcardItem> getSampleWords() =>
      getWords(targetLanguage: 'de', cefrLevel: 'b2').take(10).toList();

  // ── Parsing ───────────────────────────────────────────────────────────────

  static List<FlashcardItem> _parse(String csv, {required String prefix}) {
    final lines = csv.split('\n');
    final items = <FlashcardItem>[];
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      // Skip header row
      if (line.startsWith('German Word')) continue;
      final cols = _splitCsvLine(line);
      if (cols.length < 4) continue;
      items.add(FlashcardItem(
        id: '${prefix}_$i',
        word: cols[0].trim(),
        meaning: cols[1].trim(),
        exampleSentence: cols[2].trim(),
        exampleTranslation: cols[3].trim(),
      ));
    }
    return items;
  }

  /// Naive CSV splitter — handles quoted fields with commas inside.
  static List<String> _splitCsvLine(String line) {
    final cols = <String>[];
    final buf = StringBuffer();
    var inQuotes = false;
    for (var i = 0; i < line.length; i++) {
      final ch = line[i];
      if (ch == '"') {
        inQuotes = !inQuotes;
      } else if (ch == ',' && !inQuotes) {
        cols.add(buf.toString());
        buf.clear();
      } else {
        buf.write(ch);
      }
    }
    cols.add(buf.toString());
    return cols;
  }

  // ── Embedded CSV data ─────────────────────────────────────────────────────

  static const Map<String, String> _data = {
    'de_b2': _deB2,
  };

  static const String _deB2 = '''German Word,English Meaning,German Example Sentence,English Translation
der Arbeitgeber / die Arbeitgeberin,employer,Ein guter Arbeitgeber fördert die Weiterbildung seiner Angestellten.,A good employer encourages the further training of his employees.
der Architekt / die Architektin,architect,Die Architektin hat den Plan für das neue Bürogebäude entworfen.,The architect designed the plan for the new office building.
der Automechaniker / die Automechanikerin,car mechanic,Der Automechaniker reparierte die Bremsen meines Wagens.,The car mechanic repaired my car's brakes.
der Autoproduzent,car manufacturer,Deutschland ist bekannt für seine großen Autoproduzenten.,Germany is known for its large car manufacturers.
die Branche,industry / sector,In welcher Branche möchten Sie später arbeiten?,In which industry would you like to work later?
der Betrieb,business / company,Der Betrieb hat über 50 Mitarbeiter.,The business has over 50 employees.
der Familienbetrieb,family business,Sie führt den Familienbetrieb bereits in der dritten Generation.,She is managing the family business in the third generation already.
die Hilfsorganisation,aid agency,Er arbeitet ehrenamtlich für eine internationale Hilfsorganisation.,He works voluntarily for an international aid agency.
das internationale Unternehmen,international company,Ein internationales Unternehmen bietet oft Möglichkeiten im Ausland zu arbeiten.,An international company often offers opportunities to work abroad.
der Berufsberater / die Berufsberaterin,career counsellor,Der Berufsberater half ihr dabei eine passende Stelle zu finden.,The career counsellor helped her to find a suitable position.
die Berufsausbildung,vocational training,Eine duale Berufsausbildung dauert meist drei Jahre.,Dual vocational training usually lasts three years.
das Berufspraktikum,internship,Während des Studiums muss ich ein sechsmonatiges Berufspraktikum machen.,During my studies I have to do a six-month internship.
der Arbeitsablauf,workflow,Wir müssen den Arbeitsablauf in der Produktion optimieren.,We need to optimize the workflow in production.
der Handwerker / die Handwerkerin,craftsman / craftswoman,Der Handwerker hat das Dach schnell repariert.,The craftsman repaired the roof quickly.
die Beratungsstelle,advice centre,Die Beratungsstelle hilft Jugendlichen bei der Berufswahl.,The advice centre helps young people with their career choice.
die Stelle,position / job,Er hat sich auf eine Stelle als Ingenieur beworben.,He applied for a position as an engineer.
der Arbeitsvertrag,employment contract,Der Arbeitsvertrag wurde für zwei Jahre abgeschlossen.,The employment contract was concluded for two years.
die Kündigung,termination / resignation,Er hat seine Kündigung eingereicht.,He handed in his resignation.
das Gehalt,salary,Das Gehalt wird jeden Monat auf das Konto überwiesen.,The salary is transferred to the account every month.
die Überstunden,overtime,Für Überstunden bekommt er einen Zuschlag.,He gets a supplement for overtime.
der Urlaubsantrag,leave request,Sie hat einen Urlaubsantrag für August eingereicht.,She submitted a leave request for August.
die Fortbildung,further training / professional development,Die Firma bietet regelmäßige Fortbildungen an.,The company offers regular professional development.
der Kollege / die Kollegin,colleague,Mein Kollege hat mir bei dem Projekt geholfen.,My colleague helped me with the project.
der Vorgesetzte / die Vorgesetzte,superior / manager,Die Vorgesetzte lobte seine gute Arbeit.,The manager praised his good work.
die Besprechung,meeting,Die wöchentliche Besprechung findet montags statt.,The weekly meeting takes place on Mondays.
der Auftrag,order / assignment,Wir haben einen neuen Auftrag von einem Kunden bekommen.,We received a new order from a client.
die Fachkenntnisse,specialist knowledge,Für diese Stelle sind besondere Fachkenntnisse erforderlich.,This position requires special specialist knowledge.
die Qualifikation,qualification,Welche Qualifikationen bringen Sie für diese Stelle mit?,What qualifications do you bring for this position?
die Bewerbung,application,Er hat zehn Bewerbungen verschickt.,He sent out ten applications.
das Vorstellungsgespräch,job interview,Das Vorstellungsgespräch lief sehr gut.,The job interview went very well.
der Lebenslauf,CV / résumé,Bitte schicken Sie uns Ihren Lebenslauf.,Please send us your CV.
das Anschreiben,cover letter,Das Anschreiben sollte nicht länger als eine Seite sein.,The cover letter should be no longer than one page.
die Probezeit,probationary period,Die Probezeit beträgt sechs Monate.,The probationary period is six months.
die Vollzeitstelle,full-time position,Sie sucht eine Vollzeitstelle in der IT-Branche.,She is looking for a full-time position in the IT sector.
die Teilzeitstelle,part-time position,Er arbeitet auf einer Teilzeitstelle als Buchhalter.,He works in a part-time position as an accountant.
die Selbstständigkeit,self-employment / independence,Nach Jahren im Angestelltenverhältnis wagte er die Selbstständigkeit.,After years as an employee he ventured into self-employment.
der Unternehmer / die Unternehmerin,entrepreneur,Die Unternehmerin hat ihr Unternehmen von Grund auf aufgebaut.,The entrepreneur built her company from the ground up.
die Abteilung,department,Er leitet die Abteilung für Marketing.,He manages the marketing department.
der Abschluss,degree / conclusion,Sie hat ihren Abschluss in Wirtschaftswissenschaften gemacht.,She got her degree in economics.
die Erfahrung,experience,Ohne Berufserfahrung ist es schwer eine gute Stelle zu finden.,Without professional experience it is hard to find a good position.
die Verantwortung,responsibility,Mit der neuen Stelle übernimmt er mehr Verantwortung.,With the new position he takes on more responsibility.
die Leistung,performance / achievement,Ihre Leistung wurde mit einer Prämie belohnt.,Her performance was rewarded with a bonus.
die Prämie,bonus / premium,Der Arbeitgeber zahlt eine jährliche Prämie.,The employer pays an annual bonus.
der Personalchef / die Personalchefin,head of HR,Der Personalchef führt alle Einstellungsgespräche.,The head of HR conducts all hiring interviews.
das Netzwerk,network,Ein gutes berufliches Netzwerk ist sehr wertvoll.,A good professional network is very valuable.
die Zusammenarbeit,cooperation / collaboration,Die Zusammenarbeit zwischen den Abteilungen muss verbessert werden.,The cooperation between the departments needs to be improved.
die Verhandlung,negotiation,Die Gehaltsverhandlung war schwierig.,The salary negotiation was difficult.
der Arbeitsmarkt,labour market,Der Arbeitsmarkt ist im Wandel.,The labour market is changing.
die Arbeitslosigkeit,unemployment,Die Arbeitslosigkeit ist in dieser Region hoch.,Unemployment is high in this region.
die Gewerkschaft,trade union,Die Gewerkschaft setzt sich für bessere Arbeitsbedingungen ein.,The trade union advocates for better working conditions.
''';
}
