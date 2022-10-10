import wollok.game.*
import board.*
import pieza.*

object gameManager {
	
	var property score = 0
	var property level = 1
	var property gameOver = false
	var property lines = 0
	var property gameTime = 500
	var property sound
	// Atributos de Board y Piece
	var property tablero = new BoardMap()
	var property piezaActiva
	const property piezas = []
	// Llenar piezas y tablero
	method fillAtributes() {
		tablero.fillMapHight()
		piezas.add(new PieceS())
		piezas.add(new PieceZ())
		piezas.add(new PieceI())
		piezas.add(new PieceO())
		piezas.add(new PieceL())
		piezas.add(new PieceT())
		piezas.add(new PieceJ())
		self.setActivePiece()
		piezaActiva.fillTileMap()
		game.addVisual(messager)		
	}
	// Seteo la pieza activa
	method setActivePiece() {
		piezaActiva = piezas.get(0.randomUpTo(6))
	}
	// Manejo de Inputs
	method keyBoardControl(){
		// Move and check collisions	
		keyboard.down().onPressDo({piezaActiva.MoveDown() if(tablero.CollideWith(piezaActiva)){piezaActiva.MoveUp()}})	
		keyboard.left().onPressDo({piezaActiva.MoveLeft() if(tablero.CollideWith(piezaActiva)){piezaActiva.MoveRight()}})	
		keyboard.right().onPressDo({piezaActiva.MoveRight() if(tablero.CollideWith(piezaActiva)){piezaActiva.MoveLeft()}})
		keyboard.d().onPressDo({piezaActiva.RotateCW() if(tablero.CollideWith(piezaActiva)){piezaActiva.RotateCCW()}})
		keyboard.a().onPressDo({self.playSound()}) //empieza a reproducir con A. Esta a modo de prueba
	}
	// Actualizacion o bucle principal del juego
	method update() {
		// Cada medio segundo realizo el bucle del juego
		game.onTick(gameTime, "game update", { 
	    	piezaActiva.MoveDown() 
			if(tablero.CollideWith(piezaActiva)){	//chequeo si colisiono
				piezaActiva.MoveUp()				//si colisiono retorno una posicion hacia arriba	
				tablero.StampPiece(piezaActiva) 	//estampo pieza en tablero
				lines += tablero.CheckForLines()	//controlo las lineas que se formaron
				self.levelUp()						//control para subir de niveñ				
				piezaActiva.clearTileMap() 			//limpio la pieza activa
				self.setActivePiece()				//asigno una nurva pieza random
				piezaActiva.fillTileMap()			//lleno la nueva pieza actica con valores
				game.say(messager, "lines: " + lines.toString())
				//game.say(messager, "level: " + level.toString())
			}
			self.checkGameOver() 					//chequeo condicion de game over	
						
	    })   
	}
	
	// Reproducir audio
	method playSound(){		
    	sound = new Sound(file="original_tetris_theme_tetris_sou.mp3")
    	sound.shouldLoop(true)
    	sound.play()
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
// Mensajero para hacer pruebas
object messager inherits PieceTile (color=blanco, position=new Position(x=12, y=6)) {}

//object simple {	method punctuation() = return 100 }
//object double {	method punctuation() = return 200 }
//object triple {	method punctuation() = return 400 }
//object tetris {	method punctuation() = return 800 }
