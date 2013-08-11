class Puzzle
	constructor : (@images) ->
		
		for image in @images
			$('#previews').append('<img src="'+image+'" class="mini"/>')
		
		$('.mini').bind 'click', (event) => @changeImage event.target.src
				
		@places = []
		@initialPlaces = []
		@image = 'puzzle.jpg'
		for i in [0..7]
			x= Math.floor((i % 3)) * 110
			y= Math.floor((i / 3)) * 110
			t = new Tile(i,110,110,x,y,@image)
			@places.push t
		@places.push new Blank(8)
		@initialPlaces = @places.slice 0
		@mixup()

	mixup: () =>
		blankpos = 8
		for i in [0..10]
			randomNum = Math.floor Math.random()*9
			@switchTwo(randomNum,blankpos)
			blankpos = randomNum

	checkIfWon: () =>
		for i in [0..8]
			if @places[i] is @initialPlaces[i]
				continue
			else 
				return false
		return true

	blankPosition: () =>
		for place in [ 0..@places.length ]
			if @places[place].class is 'Blank'
				return place
			

	renderBoard : () =>
		blank = @blankPosition()
		$('#canvas').html('')
		if @checkIfWon()
			$('#canvas').append('<span id="windiv"><img src="'+@image+'"/><div class="banner"> You Won!</div><div class="bubblegum"></div></span>')
			$('#windiv').show 'slow'
		else
			for t in @places
				t.show(blank)
			$('.clickable').bind 'click', (event) =>
				toSwitch = parseInt event.target.id
				@switchTwo toSwitch, @blankPosition()
	
	switchTwo : (pos1,pos2) =>
		x = @places[pos1]
		y = @places[pos2]
		@places[pos2] = x
		@places[pos1] = y 
		@places[pos2].position = pos2
		@renderBoard()

	changeImage:(image) =>
		@image = image
		for panel in @places
			if panel.class isnt 'Blank'
				panel.image = image
		@renderBoard()


class Tile

	constructor:(@position,@width,@height,@x,@y,@image)->
		@class='Tile'
	show:(blankPosition)->
		if @isAdjacent blankPosition
			$('#canvas').append '<div id="'+@position+'" class="innerSquare imageSquare clickable"></div>' 
		else
			$('#canvas').append '<div id="'+@position+'" class="innerSquare imageSquare"></div>' 
		
		$("#"+@position).css('background-position', '-'+@x+'px -'+@y+'px')
		$("#"+@position).css('background-image', 'url(' + @image + ')')
				
	isAdjacent:(blanksPosition)->
		if blanksPosition-1 is @position and (blanksPosition%3)>0 or
		blanksPosition+1 is @position and (blanksPosition%3)<2 or
		blanksPosition+3 is @position and (blanksPosition/3)<2 or
		blanksPosition-3 is @position and (blanksPosition/3)>0
			return true
		return false
	setImage:(image)->
		@image = image
		
class Blank
	
	constructor:(@position)->
		@class='Blank'
	show:()->
		$('#canvas').append '<div class="innerSquare blank"></div>' 



$(document).ready(->
	imgs = ['puzzle.jpg','puzzle2.jpg','puzzle3.jpg','puzzle4.jpg']
	puzzle = new Puzzle(imgs)

)