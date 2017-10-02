#Data Dictionary

**Data file**: nba2017-player-statistics.csv

**Source:** https://www.basketball-reference.com

**Sample:** https://www.basketball-reference.com/teams/GSW/2017.html


**Summary of data**: The file named 'nba2017-player-statistics.csv' contains common basketball statistics of 441 players from the 2017 season. Each row represents a player and each column represents a statistic of the player. There are 24 statistics per player. 

**Number of rows**: 441

**Number of columns**: 24

**Name of column and description of data**:

**1** Player: first and last names of player

**2** Team: 3-letter team abbreviations

**3** Position: player’s position in terms of C, PF, PG, SF, SG.

**4** Experience: years of experience in NBA

**5** Salary: player salary in dollars

**6** Rank: Rank of player in his team

**7** Age: Age of Player at the start of February 1st of that season.

**8** GP: Games Played during regular season

**9** GS: Games Started

**10** MIN: Minutes Played during regular season

**11** FGM: Field Goals Made

**12** FGA: Field Goal Attempts

**13** Points3: 3-Point Field Goals

**14** Points3_atts: 3-Point Field Goal Attempts

**15** Points2: 2-Point Field Goals

**16** Points2_atts: 2-Point Field Goal Attempts

**17** FTM: Free Throws Made

**18** FTA: Free Throw Attempts

**19** OREB: Offensive Rebounds

**20** DREB: Defensive Rebounds

**21** AST: Assists

**22** STL: Steals

**23** BLK: Blocks

**24** TO: Turnovers

**Notes**: This dataset has no missing value in any row or column. The values in columns 'Points3' and Points2' need to be weighted by 3 and 2 respectively, if you want to know how many points were scored.