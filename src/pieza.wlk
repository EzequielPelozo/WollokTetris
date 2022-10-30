import wollok.game.*

object verde { method image() { return "tile_verde.png" } }
object rojo { method image() { return "tile_rojo.png" } }
object violeta { method image() { return "tile_violeta.png" } }
object naranja { method image() { return "tile_naranja.png" } }
object azul { method image() { return "tile_azul.png" } }
object amarillo { method image() { return "tile_amarillo.png" } }
object celeste { method image() { return "tile_celeste.png" } }
object blanco { method image() { return "tile_gris_base.png" } }

class Piece {	
	const property tilesMap = []			//mapa de tiles de la pieza
	var property relativeX = 4				//origen de la pieza en el mapa X
	var property relativeY = 20				//origen de la pieza en el mapa Y
	var property pieceMatrixLength = 3		//tamaño de lado de la matriz de la pieza
	// Metodo abstracto a sobreescribir en cada pieza
	method fillTileMap()	
	// Metodo para rotar en sentido horario	
	method RotateCW() {
		tilesMap.forEach({//Para rotar la pieza primero translado al origen			
			t => t.position(new Position(x = t.position().y() - relativeY + relativeX, 
										 y = pieceMatrixLength - 1 - (t.position().x() - relativeX) + relativeY
			))
		})
	}	
	// Metodo para rotar en sentido anti horario(se utiliza al chequear colision)
	method RotateCCW() {
		tilesMap.forEach({//Para rotar la pieza primero translado al origen			
			t => t.position(new Position(x = pieceMatrixLength - 1 - (t.position().y() - relativeY) + relativeX, 
										 y = t.position().x() - relativeX + relativeY
			))
		})
	}
	// Mover izquierda
	method MoveLeft() {
		relativeX--
		tilesMap.forEach({		
			t => t.position(new Position(x = t.position().x() - 1, 
										 y = t.position().y() 
			))
		})
	}
	// Mover derecha
	method MoveRight() {
		relativeX++
		tilesMap.forEach({		
			t => t.position(new Position(x = t.position().x() + 1, 
										 y = t.position().y() 
			))
		})
	}
	// Mover arriba (se utiliza al chequear colision)
	method MoveUp() {
		relativeY++
		tilesMap.forEach({		
			t => t.position(new Position(x = t.position().x(), 
										 y = t.position().y() + 1
			))
		})
	}
	// Mover abajo 
	method MoveDown() {
		relativeY--
		tilesMap.forEach({		
			t => t.position(new Position(x = t.position().x(), 
										 y = t.position().y() - 1
			))
		})
	}
	// Chequeo si existe fila para colision con bordes
	method existAnyRowMaxAs(row) = tilesMap.any({
		tile => tile.position().y() < 0
		//tile => tile.position().y() > row - 1 || tile.position().y() < 0
	})
	// Chequeo si existe columna para colision con bordes
	method existAnyColMaxAs(col) = tilesMap.any({
		tile => tile.position().x() > col - 1 || tile.position().x() < 0
	})
	// Chequeo si colisiona con un tile del tablero
	method existAnyTileAs(mapTile) = tilesMap.any({
		tile => tile.position().y() == mapTile.position().y() && tile.position().x() == mapTile.position().x() 
	})
	// Devuelvo la lista de tiles para estampar en tablero
	method stampTileMap() = tilesMap.map({
		tile => new PieceTile(color=blanco, position=new Position(x=tile.position().x(), y=tile.position().y()))		 
	})
	// Borrar tilemap
	method clearTileMap() {
		tilesMap.forEach({tile => game.removeVisual(tile)})
		tilesMap.clear()
		relativeX = 4
	    relativeY = 18
	}
}

class PieceS inherits Piece {
	
    override method fillTileMap() {
    	const tile1 = new PieceTile(color=rojo, position=new Position(x=relativeX+0, y=relativeY+1))
    	const tile2 = new PieceTile(color=rojo, position=new Position(x=relativeX+0, y=relativeY+2))
    	const tile3 = new PieceTile(color=rojo, position=new Position(x=relativeX+1, y=relativeY+0))
    	const tile4 = new PieceTile(color=rojo, position=new Position(x=relativeX+1, y=relativeY+1))     	
    	game.addVisual(tile1)
    	game.addVisual(tile2)
    	game.addVisual(tile3)
    	game.addVisual(tile4)
    	tilesMap.add(tile1)
		tilesMap.add(tile2)
		tilesMap.add(tile3)
		tilesMap.add(tile4)			
	}
}

class PieceZ inherits Piece {
	
    override method fillTileMap() {
    	const tile1 = new PieceTile(color=violeta, position=new Position(x=relativeX+0, y=relativeY+0))
    	const tile2 = new PieceTile(color=violeta, position=new Position(x=relativeX+0, y=relativeY+1))
    	const tile3 = new PieceTile(color=violeta, position=new Position(x=relativeX+1, y=relativeY+1))
    	const tile4 = new PieceTile(color=violeta, position=new Position(x=relativeX+1, y=relativeY+2))  
    	game.addVisual(tile1)
    	game.addVisual(tile2)
    	game.addVisual(tile3)
    	game.addVisual(tile4)
    	tilesMap.add(tile1)
		tilesMap.add(tile2)
		tilesMap.add(tile3)
		tilesMap.add(tile4)			
	}	
}

class PieceI inherits Piece {
	
    override method fillTileMap() {
    	pieceMatrixLength = 4
    	const tile1 = new PieceTile(color=naranja, position=new Position(x=relativeX+1, y=relativeY+0))
    	const tile2 = new PieceTile(color=naranja, position=new Position(x=relativeX+1, y=relativeY+1))
    	const tile3 = new PieceTile(color=naranja, position=new Position(x=relativeX+1, y=relativeY+2))
    	const tile4 = new PieceTile(color=naranja, position=new Position(x=relativeX+1, y=relativeY+3))   	
    	game.addVisual(tile1)
    	game.addVisual(tile2)
    	game.addVisual(tile3)
    	game.addVisual(tile4)	    	
    	tilesMap.add(tile1)
		tilesMap.add(tile2)
		tilesMap.add(tile3)
		tilesMap.add(tile4)			
	}	
}

class PieceO inherits Piece {
	
    override method fillTileMap() {
    	pieceMatrixLength = 2
    	const tile1 = new PieceTile(color=azul, position=new Position(x=relativeX+0, y=relativeY+0))
    	const tile2 = new PieceTile(color=azul, position=new Position(x=relativeX+0, y=relativeY+1))
    	const tile3 = new PieceTile(color=azul, position=new Position(x=relativeX+1, y=relativeY+0))
    	const tile4 = new PieceTile(color=azul, position=new Position(x=relativeX+1, y=relativeY+1))    
    	game.addVisual(tile1)
    	game.addVisual(tile2)
    	game.addVisual(tile3)
    	game.addVisual(tile4)	
    	tilesMap.add(tile1)
		tilesMap.add(tile2)
		tilesMap.add(tile3)
		tilesMap.add(tile4)	
	}
}

class PieceL inherits Piece {
	
    override method fillTileMap() {
    	const tile1 = new PieceTile(color=amarillo, position=new Position(x=relativeX+1, y=relativeY+0))
    	const tile2 = new PieceTile(color=amarillo, position=new Position(x=relativeX+1, y=relativeY+1))
    	const tile3 = new PieceTile(color=amarillo, position=new Position(x=relativeX+1, y=relativeY+2))
    	const tile4 = new PieceTile(color=amarillo, position=new Position(x=relativeX+2, y=relativeY+0))        	
    	game.addVisual(tile1)
    	game.addVisual(tile2)
    	game.addVisual(tile3)
    	game.addVisual(tile4)	    	
    	tilesMap.add(tile1)
		tilesMap.add(tile2)
		tilesMap.add(tile3)
		tilesMap.add(tile4)			
	}
}

class PieceT inherits Piece {
	
    override method fillTileMap() {
    	const tile1 = new PieceTile(color=celeste, position=new Position(x=relativeX+0, y=relativeY+1))
    	const tile2 = new PieceTile(color=celeste, position=new Position(x=relativeX+1, y=relativeY+1))
    	const tile3 = new PieceTile(color=celeste, position=new Position(x=relativeX+1, y=relativeY+2))
    	const tile4 = new PieceTile(color=celeste, position=new Position(x=relativeX+2, y=relativeY+1))   
    	game.addVisual(tile1)
    	game.addVisual(tile2)
    	game.addVisual(tile3)
    	game.addVisual(tile4)
    	tilesMap.add(tile1)
		tilesMap.add(tile2)
		tilesMap.add(tile3)
		tilesMap.add(tile4)	
	}
}

class PieceJ inherits Piece {
	
    override method fillTileMap() {
    	const tile1 = new PieceTile(color=verde, position=new Position(x=relativeX+0, y=relativeY+0))
    	const tile2 = new PieceTile(color=verde, position=new Position(x=relativeX+1, y=relativeY+0))
    	const tile3 = new PieceTile(color=verde, position=new Position(x=relativeX+1, y=relativeY+1))
    	const tile4 = new PieceTile(color=verde, position=new Position(x=relativeX+1, y=relativeY+2))    
    	game.addVisual(tile1)
    	game.addVisual(tile2)
    	game.addVisual(tile3)
    	game.addVisual(tile4)	
    	tilesMap.add(tile1)
		tilesMap.add(tile2)
		tilesMap.add(tile3)
		tilesMap.add(tile4)	
	}
}
// Tile generico
class PieceTile {
	var property color
	var property position
	var property image = color.image()
}

