# Whether Emotions are "Engaging" or "Disengaging" Depends on Relationship Functions

Data, analysis code, and materials for:

> Chughtai, M. K., Gendron, M., & Clark, M. S. (2025). Whether emotions are engaging or disengaging depends on relationship functions. *Affective Science, 6*(4), 700–713. https://doi.org/10.1007/s42761-025-00327-8

Preregistered hypotheses and study materials are on the project's OSF page: https://osf.io/jcxat/

## Overview

Four samples examining how frequently Americans report experiencing, expressing, and perceiving eight emotions in normatively communal versus transactional relationships, and how engaging and functional those emotions are reported to be.

| Study | N | Focus |
|---|---|---|
| 1 | 393 | Own experience and expression of respect, guilt, pride, anger |
| 2 | 394 | Perception of the same emotions in partners |
| 3 | 353 | Empathic joy, empathic sadness, hurt, love |
| 4 | 330 | Perception of the Study 3 emotions |

## Repository structure

```
DEER.Rproj                     RStudio project file - open this first
Manuscript.pdf                 Accepted manuscript (see Licensing)
Supplemental Materials.pdf     Supplemental analyses and materials
Data/
  Deidentified Raw Data/       Output of the deidentification step
  Analysis-Ready Data/         Cleaned data used by the analysis scripts
Figures/
  Manuscript Panels/           Figures 1-4 as they appear in the paper
  Study 1/ ... Study 4/        Per-study figures and residual plots
Study 1/ ... Study 4/          Cleaning and analysis scripts per study
```

Within each study folder:

- `Study*_DataCleaning_Secondary.R` — prepares analysis-ready data from deidentified data
- `Study*_PrimaryAnalyses.Rmd` — preregistered analyses reported in the paper
- `Study*_ExploratoryAnalyses.Rmd` — exploratory analyses
- `Study*_PowerAnalysis.Rmd` — a priori power analysis (Studies 1 and 3)
- `Study1_Peer_Review_Analysis.Rmd` — additional analyses requested during peer review

## Reproducing the analyses

Open `DEER.Rproj` in RStudio and run the scripts from there. All file paths are
constructed with the `here` package relative to the project root, so nothing
needs editing to run on another machine.

For a given study, run `Study*_DataCleaning_Secondary.R` first, then the
`.Rmd` analysis files.

## A note on the data

This repository begins at the **deidentified** data. Raw survey exports contain
participant identifiers and are not published here, and the initial
deidentification scripts that read them are excluded for the same reason. Every
analysis reported in the paper runs from the files included in `Data/`.

## Licensing

Different parts of this repository carry different terms:

- **Code** (`.R`, `.Rmd`) — MIT License, see [LICENSE](LICENSE).
- **Data and figures** — [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). Please cite the article.
- **`Manuscript.pdf`** — This is the author accepted manuscript. It is **not**
  released under an open license. It is subject to Springer Nature's AM terms of
  use, is not the Version of Record, and does not reflect post-acceptance
  improvements or any corrections. Cite the published version at
  https://doi.org/10.1007/s42761-025-00327-8

## Contact

Mujtaba K. Chughtai — muji.chughtai@yale.edu
Department of Psychology, Yale University
