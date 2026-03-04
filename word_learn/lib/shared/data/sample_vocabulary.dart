import '../models/flashcard_item.dart';

/// Sample vocabulary for development. Replace with asset/CSV load or encrypted bundle later.
List<FlashcardItem> getSampleVocabulary() {
  const raw = [
    ['1', 'der Arbeitgeber / die Arbeitgeberin', 'employer',
     'Ein guter Arbeitgeber fördert die Weiterbildung seiner Angestellten.',
     'A good employer encourages the further training of his employees.'],
    ['2', 'der Architekt / die Architektin', 'architect',
     'Die Architektin hat den Plan für das neue Bürogebäude entworfen.',
     'The architect designed the plan for the new office building.'],
    ['3', 'der Automechaniker / die Automechanikerin', 'car mechanic',
     'Der Automechaniker reparierte die Bremsen meines Wagens.',
     'The car mechanic repaired my car\'s brakes.'],
    ['4', 'die Branche', 'industry / sector',
     'In welcher Branche möchten Sie später arbeiten?',
     'In which industry would you like to work later?'],
    ['5', 'der Betrieb', 'business / company',
     'Der Betrieb hat über 50 Mitarbeiter.',
     'The business has over 50 employees.'],
    ['6', 'die Berufsausbildung', 'vocational training',
     'Eine duale Berufsausbildung dauert meist drei Jahre.',
     'Dual vocational training usually lasts three years.'],
    ['7', 'das Berufspraktikum', 'internship',
     'Während des Studiums muss ich ein sechsmonatiges Berufspraktikum machen.',
     'During my studies, I have to do a six-month internship.'],
    ['8', 'der Arbeitsablauf', 'workflow',
     'Wir müssen den Arbeitsablauf in der Produktion optimieren.',
     'We need to optimize the workflow in production.'],
    ['9', 'der Handwerker / die Handwerkerin', 'craftsman / craftswoman',
     'Der Handwerker hat das Dach schnell repariert.',
     'The craftsman repaired the roof quickly.'],
    ['10', 'die Beratungsstelle', 'advice centre',
     'Die Beratungsstelle hilft Jugendlichen bei der Berufswahl.',
     'The advice centre helps young people with their career choice.'],
  ];
  return raw
      .map((row) => FlashcardItem(
            id: row[0],
            word: row[1],
            meaning: row[2],
            exampleSentence: row[3],
            exampleTranslation: row[4],
          ))
      .toList();
}
