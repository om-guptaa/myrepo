import random

# create a list of all players
all_players = list(range(1, 46))

# create a list to store the teams
teams = []

# divide the players into 5 random teams of 9 players each
for i in range(5):
    # shuffle the list of players
    random.shuffle(all_players)
    
    # divide the shuffled list into 5 groups of 9 players each
    team = [all_players[j:j+9] for j in range(0, len(all_players), 9)]
    
    # add the team to the list of teams
    teams.append(team)
    
    # print the team
    print("Team {}: {}".format(i+1, team))
