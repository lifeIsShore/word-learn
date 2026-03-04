# Data Directory - Vocabulary Files

This directory contains German vocabulary files for the language learning app.

## Vocabulary Files

### C1 Level
- **German C1 words (an die Arbeit).csv** (131 words) - Advanced German vocabulary

### B2 Level - Categorized by Theme

The B2 vocabulary has been organized into 13 thematic categories to make learning more focused and efficient:

#### Work & Education (650+ words)
1. **b2-work-professions.csv** (~106 words) - Professions, jobs, industries, employers
2. **b2-education-training.csv** (~28 words) - Schools, degrees, qualifications, courses  
3. **b2-work-skills-qualities.csv** - Work-related skills, personal qualities, competencies

#### Daily Life & Communication
4. **b2-communication.csv** - Speaking, writing, conveying information
5. **b2-emotions-psychology.csv** - Feelings, mental states, psychology
6. **b2-health-body.csv** - Medical vocabulary, health, body parts
7. **b2-home-living.csv** - Housing, furniture, household items

#### Society & Environment
8. **b2-social-society.csv** - Social issues, community, citizenship
9. **b2-nature-environment.csv** - Animals, plants, weather, geography
10. **b2-legal-rules.csv** - Law, regulations, permissions

#### Culture & General
11. **b2-culture-art.csv** - Literature, art, entertainment
12. **b2-general-verbs.csv** - Common B2 verbs  
13. **b2-general-mixed.csv** - Adjectives, nouns, and other words

###  Idioms & Phrases
- **redewendungs.csv** (732 entries) - English-German idioms and common phrases

## Source Files (Original Data)

- **b2-p1.csv** - Original B2 vocabulary (education/professions focus)
- **b2-p3.csv** - Original B2 vocabulary (general)

> **Note**: These source files are kept for reference. The app can load from either the categorized files or the originals.

## CSV Format

All vocabulary files follow this format:
```csv
German Word,English Meaning,German Example Sentence,English Translation
der Arbeitgeber,employer,"Ein guter Arbeitgeber...",A good employer...
```

## Adding New Vocabulary

1. Create a new CSV file in this directory
2. Use the same format as existing files (4 columns with header row)
3. Update `data-loader.js` to include the new file
4. Update `service-worker.js` to cache the new file for offline use

## Statistics

- **Total C1 words**: 131
- **Total B2 words**: ~1,223 (across all categories)
- **Total idioms/phrases**: 732
- **Grand Total**: ~2,086 vocabulary items

Perfect for B2→C1 German learners! 🇩🇪
