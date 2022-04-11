# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
    # 3.1.1

* System dependencies
    # gem rails 7.0.2.3
    # gem puma 5.0
    # gem tzinfo-data
    # gem bootsnap
    # gem pg
    # gem debug
    # gem sqlite3 1.4

* Configuration

    # GET	    /games  	    games#index 	return a JSON whit a collection of games
    # GET 	    /games/:id	    games#show	    display the one and only game resource
    # POST	    /games  	    games#create	create the new game with their respetive cells
    # PATCH/PUT	/games/:id  	games#update	update the one and only game resource

    # GET	    /cells  	    cells#index 	return a JSON whit a collection of cells referenceds
    # GET 	    /cells/:id	    cells#show	    display the one and only cell resource
    # PATCH/PUT	/cells/:id  	cells#update	update the one and only cell resource

* Database creation
    # Game player_name:string mines:integer rows:integer columns:integer is_winner:boolean is_game_over:boolean
    # Cell x_axis:integer y_axis:integer is_mined:boolean is_exposed:boolean is_flagged:boolean

* ...
    # 