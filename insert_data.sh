#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
    then 
    #TEAMS
    if [[ true ]]
      then
      TEAM1=$($PSQL "select team_id from teams where name='$WINNER'")
      TEAM2=$($PSQL "select team_id from teams where name='$OPPONENT'")
      if [[ -z $TEAM1 ]]
        then
        INST1=$($PSQL "insert into teams(name) values('$WINNER')")
        TEAM1=$($PSQL "select team_id from teams where name='$WINNER'")
        if [[ $INSERT_TEAM1_RESULT == "INSERT 0 1" ]]
          then
          echo "Inserted into teams, $TEAM1"
        fi
      fi
      if [[ -z $TEAM2 ]]
        then
        INST2=$($PSQL "insert into teams(name) values('$OPPONENT')")
        TEAM2=$($PSQL "select team_id from teams where name='$OPPONENT'")
        if [[ $INSERT_TEAM2_RESULT == "INSERT 0 1" ]]
          then
          echo "Inserted into teams, $TEAM2"
        fi
      fi
    fi
    #GAMES
    INSERT_GAMES=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$TEAM1,$TEAM2,$WINNER_GOALS,$OPPONENT_GOALS)")
    if [[ $INSERT_GAMES == "INSERT 0 1" ]]
      then
      echo "Inserted into games"
    fi
  fi
done