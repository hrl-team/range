# Range
This is the repository where I am storing the data and code used to generate behavioural analyses for the publication:   
>__Two sides of the same coin: Beneficial and detrimental consequences of range adaptation in human reinforcement learning__   
Sophie Bavard, Aldo Rustichini, Stefano Palminteri   
https://advances.sciencemag.org/content/7/14/eabe0340/

## Behavioural analyses   
Run the *behavioral_analyses.m* script to produce the *data_figures.mat*.   
The script loads the raw matrix *data.mat* and extracts the variables of interest for the figures.

## Generate the figures   
Run the *figures.m* script to generate the figures.   
The script loads the file *data_figures.mat*.

## Data   
All behavioral data are stored in the raw matrix *data.mat*. The columns are ordered as follows:    
* COLUMN 1: participant number (1:800)
* COLUMN 2: phase number (0:2)
  * 0: training phase
  * 1: learning phase
  * 2: transfer phase
* COLUMN 3: trial number (1:120)
* COLUMN 4: context number (1:8)
  * 1 = 7.50 vs 2.50 learning test
  * 2 = 7.50 vs 2.50 learning test
  * 3 = 0.75 vs 0.25 learning test
  * 4 = 0.75 vs 0.25 learning test
  * 5 = 7.50 vs 0.75 transfer test
  * 6 = 2.50 vs 0.25 transfer test
  * 7 = 7.50 vs 0.25 transfer test
  * 8 = 2.50 vs 0.75 transfer test
* COLUMN 5: left symbol (1:8)
* COLUMN 6: right symbol (1:8)
* COLUMN 7: choice left/right
  * -1: left
  * 1: right
* COLUMN 8: choice accuracy
  * 0: incorrect
  * 1: correct
* COLUMN 9: outcome chosen option
  * 0: null
  * 1: positive (1pt or 10pts)
* COLUMN 10: outcome unchosen option (complete feedback only)
  * 0: null
  * 1: positive (1pt or 10pts)
* COLUMN 11: trial reaction time (ms)
* COLUMN 12: cumulated reward
* COLUMN 13: participant ID
* COLUMN 14: experiment number (1:8)
  * 1 = partial / no feedback, interleaved trials
  * 2 = partial / partial, interleaved trials
  * 3 = complete / no feedback, interleaved trials
  * 4 = complete / complete, interleaved trials
  * 5 = partial / no feedback, blocked trials
  * 6 = partial / partial, blocked trials
  * 7 = complete / no feedback, blocked trials
  * 8 = complete / complete, blocked trials
* COLUMN 15: trial order (1:2)
  * 1 = interleaved trials
  * 2 = blocked trials
