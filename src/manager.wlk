import wollok.game.*
import board.*
import pieza.*

object gameManager {
	
	var property score = 0                    // Puntaje
	var property level = 1					  // Nivel
	var property gameOver = true              // Condicion de derrota
	var property lines = 0					  // Nunero de lineas
	var property gameTime = 500				  // Tiempo de caida de piezas
	var property sound						  // Atributo para el audio
	// Atributos de Board y Piece
	var property tablero = new BoardMap()     // Tablero del juego
	var property piezaActiva				  // Pieza activa del juego
	var property nextPiece					  // Siguiente Pieza
	const property piezas = []				  // Lista de piezas que voy a usar
	// Llenar piezas y tablero
	method fillAtributes() {
		tablero.fillMapHight()
		piezas.add(new PieceS())			  // Agrego pieza S
		piezas.add(new PieceZ())			  // Agrego pieza Z
		piezas.add(new PieceI())              // Agrego pieza I
		piezas.add(new PieceO())			  // Agrego pieza O
		piezas.add(new PieceL())			  // Agrego pieza L
		piezas.add(new PieceT())		   	  // Agrego pieza T
		piezas.add(new PieceJ())              // Agrego pieza J
		piezaActiva = self.setActivePiece()   // Seteo la pieza activa de forma random		
		piezaActiva.fillTileMap()			  // Lleno el tilemap de la pieza activa
		piezaActiva.isInUse(true)			  // registro la pieza activa en uso
		nextPiece = self.setActivePiece()     // Seteo la proxima pieza de forma random
		nextPiece. setOriginPos(12,7)		  // seteo origen de la proxima pieza
		nextPiece.fillTileMap()			      // Lleno el tilemap de la proxima pieza 
		nextPiece.isInUse(true)				  // registro la siguiente pieza como en uso		
		insertCoin.animation()				  // Animacion de insert coin
		game.addVisual(insertCoin)			  // Agrego insert coin al juego 
		game.addVisual(pressStartcover)		  // Press 1		
		game.addVisual(lineUnit)			  // Control de unidad de lieas			
		lineUnit.checkChangeLine()			  // Activo el control
		game.addVisual(lineDozens)			  // Control de decena de linea
		lineDozens.checkChangeLine()		  // Activo el control
		game.addVisual(lineHundred)			  // Control de centena de linea
		lineHundred.checkChangeLine()		  // Activo el control
	}
	// Filtro piezas no usadas
	method unusedPieceFilter() = piezas.filter({piece => !piece.isInUse()})
	// Seteo la pieza activa de forma aleatoria
	method setActivePiece() = self.unusedPieceFilter().get(0.randomUpTo(self.unusedPieceFilter().size() - 1))	
	// Nueva pieza
	method setNewPiece(){
		piezaActiva.clearTileMap() 						// Limpio la pieza activa 4 18		
		nextPiece.clearTileMap()
		nextPiece. setOriginPos(4,20)
		nextPiece.fillTileMap()			                // Lleno el tilemap de la proxima pieza 
		nextPiece.isInUse(true)		
		piezaActiva = nextPiece		
		nextPiece = self.setActivePiece()				//asigno una nurva pieza random	
		nextPiece. setOriginPos(12,7)	
		nextPiece.fillTileMap()				     		//lleno la nueva pieza actica con valores
		nextPiece.isInUse(true)
		
	}
	// Manejo de Inputs
	method keyBoardControl(){
		// Move and check collisions	
		keyboard.down().onPressDo({if(!gameOver) {piezaActiva.MoveDown() if(tablero.CollideWith(piezaActiva)){piezaActiva.MoveUp()}}})	
		keyboard.left().onPressDo({if(!gameOver) {piezaActiva.MoveLeft() if(tablero.CollideWith(piezaActiva)){piezaActiva.MoveRight()}}})	
		keyboard.right().onPressDo({if(!gameOver) {piezaActiva.MoveRight() if(tablero.CollideWith(piezaActiva)){piezaActiva.MoveLeft()}}})
		keyboard.up().onPressDo({piezaActiva.RotateCW() if(tablero.CollideWith(piezaActiva)){piezaActiva.RotateCCW()}})
		keyboard.e().onPressDo({game.stop()})
		keyboard.num1().onPressDo({
			if(gameOver){
				self.playSound() 
				gameOver = false 
				if(game.hasVisual(pressStartcover)){game.removeVisual(pressStartcover)}
				if(game.hasVisual(insertCoin)){game.removeVisual(insertCoin)}
				self.update()								// Bucle principal del juego
			}
		}) 
	}
	// Actualizacion o bucle principal del juego
	method update() {
		// Cada medio segundo realizo el bucle del juego		
		game.onTick(gameTime, "game update", { 
			if(!gameOver) {
			piezaActiva.MoveDown() 
			if(tablero.CollideWith(piezaActiva)){	// Chequeo si colisiono
				piezaActiva.MoveUp()				// Si colisiono retorno una posicion hacia arriba	
				tablero.StampPiece(piezaActiva) 	// Estampo pieza en tablero
				lines += tablero.CheckForLines()	// Controlo las lineas que se formaron
				self.levelUp()						// Control para subir de nivel	PROBAR EN OTRO ONTICK			
				self.setNewPiece()					// Seteo nueva pieza
			}
			self.checkGameOver() 					//chequeo condicion de game over			
		}						
	    })   
	}
	
	method playGame() {		
		game.title("Tetris")                        // Seteo titulo del juego
		game.width(20)								// Seteo el ancho del tablero
		game.height(20)								// Seteo el alto del tablero
		game.cellSize(25)						    // Seteo el tamaño de cada unidad del juego en pixels
		game.boardGround("tetris_background.png")   // Seteo el fondo					
		self.fillAtributes()						// Lleno lo atributos del juego
		self.keyBoardControl()						// Manejo de teclado		
		game.start()								// Inicio de juego
	}
	
	// Reproducir audio
	method playSound(){		
    	sound = new Sound(file="original_tetris_theme_tetris_sou.mp3")	   // Seteo el tema principal
    	sound.shouldLoop(true)                                             // Seteo que el tema principal se repita en loop
    	sound.play()													   // reproduzco el sonido	
	}
	// Condicion de derrota
	method checkGameOver() {
		if(tablero.gameOver()){ console.println("llegue al borde")
			game.removeTickEvent("game update")
			gameOver = true
			tablero.Reset()
			sound.stop()
			lines = 0
			//game.addVisual(insertCoin)			  // Agrego insert coin al juego 
			game.addVisual(pressStartcover)
		}
	} 	
	// Subir nivel
	method levelUp() {  }			
}
//////////////////////////////////OBJECTS///////////////////////////////////////////////////////////////////////////
object linesCounter {
	var property value = 0
}
// Mensajero para hacer pruebas
//object messager inherits PieceTile (color=blanco, position=new Position(x=12, y=6)) {}

object insertCoin {
	var property position = new Position(x = 0, y = 15)
	var property image = "text_insert_coin.png"
	
	method changeFrame(){
		if(image == "text_insert_coin.png") {
			image = "text_insert_coin_black.png"
		}else{
			image = "text_insert_coin.png"
		}
	}
	
	method animation(){
		game.onTick(800, "animacion", {self.changeFrame()})
	}
}
/////////////////////////////REFACTORIZAR CON HERENCIA/////////////////////////////////////////////////////////
object lineUnit {
	var property index = 0
	var property position = new Position(x = 18, y = 4)
	var property image = "num_" + index + ".png"
	
	method changeImage(){
		index =  gameManager.lines() % 10 	// Controlo que sea de 0 a 9
		image = "num_" + index + ".png"		// Seteo nueva imagen
	}	
	method checkChangeLine(){game.onTick(40,"check de linea",{self.changeImage()})}
}

object lineDozens {
	var property index = 0
	var property position = new Position(x = 17, y = 4)
	var property image = "num_" + index + ".png"
	
	method changeImage(){// Solo entran multiplos de 10
		if( gameManager.lines() > 9){
			index =  (gameManager.lines() * 0.1).truncate(0)  % 10 		// Controlo que sea de 0 a 9
			image = "num_" + index + ".png" 							// Seteo nueva imagen
		}		
	}	
	method checkChangeLine(){game.onTick(40,"check de linea",{self.changeImage()})}
}
object lineHundred {

	var property index = 0
	var property position = new Position(x = 16, y = 4)
	var property image = "num_" + index + ".png"

	method changeImage() { // Solo entran multiplos de 100
		if (gameManager.lines() > 99) {
			index = (gameManager.lines() * 0.01).truncate(0) % 10 // Controlo que sea de 0 a 9
			image = "num_" + index + ".png" // Seteo nueva imagen
		}
	}
	method checkChangeLine() {
		game.onTick(40, "check de linea", { self.changeImage()})
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//object simple {	method punctuation() = return 100 }
//object double {	method punctuation() = return 200 }
//object triple {	method punctuation() = return 400 }
//object tetris {	method punctuation() = return 800 }
