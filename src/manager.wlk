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
		self.setActivePiece()                 // Seteo la pieza activa de forma random
		piezaActiva.fillTileMap()			  // Lleno el tilemap de la pieza activa
		game.addVisual(messager)
		insertCoin.animation()				  // Animacion de insert coin
		game.addVisual(insertCoin)			  // Agrego insert coin al juego
		
		game.addVisual(lineUnit)
		lineUnit.checkChangeLine()	
		game.addVisual(lineDozens)
		lineDozens.checkChangeLine()
	}
	// Seteo la pieza activa de forma aleatoria
	method setActivePiece() {
		piezaActiva = piezas.get(0.randomUpTo(6))
	}
	// Nueva pieza
	method setNewPiece(){
		piezaActiva.clearTileMap() 			// Limpio la pieza activa
		self.setActivePiece()				//asigno una nurva pieza random
		piezaActiva.fillTileMap()			//lleno la nueva pieza actica con valores
	}
	// Manejo de Inputs
	method keyBoardControl(){
		// Move and check collisions	
		keyboard.down().onPressDo({piezaActiva.MoveDown() if(tablero.CollideWith(piezaActiva)){piezaActiva.MoveUp()}})	
		keyboard.left().onPressDo({piezaActiva.MoveLeft() if(tablero.CollideWith(piezaActiva)){piezaActiva.MoveRight()}})	
		keyboard.right().onPressDo({piezaActiva.MoveRight() if(tablero.CollideWith(piezaActiva)){piezaActiva.MoveLeft()}})
		keyboard.up().onPressDo({piezaActiva.RotateCW() if(tablero.CollideWith(piezaActiva)){piezaActiva.RotateCCW()}})
		keyboard.num1().onPressDo({
			if(gameOver){
				self.playSound() 
				gameOver = false 
				game.removeVisual(pressStartcover)
				game.removeVisual(insertCoin)
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
				game.say(messager, "lines: " + lines.toString())
				//game.say(messager, "level: " + level.toString())
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
		game.addVisual(pressStartcover)			
		self.fillAtributes()						// Lleno lo atributos del juego
		self.keyBoardControl()						// Manejo de teclado
		self.update()								// Bucle principal del juego
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
			game.stop()
		}
	} 	
	// Subir nivel
	method levelUp() {  }			
}

object linesCounter {
	var property value = 0
}
// Mensajero para hacer pruebas
object messager inherits PieceTile (color=blanco, position=new Position(x=12, y=6)) {}

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
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//object simple {	method punctuation() = return 100 }
//object double {	method punctuation() = return 200 }
//object triple {	method punctuation() = return 400 }
//object tetris {	method punctuation() = return 800 }
