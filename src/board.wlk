import pieza.*
import wollok.game.*

class BoardMap {
	
	const property tilesMap = []	//Mapa de tiles del tablero
	const property cols = 10   		//Ancho del tablero
	const property rows = 20		//Alto del tablero
	const property mapHight = []	//Mapa de enteros para recorrer en forma vertica descendente
	
	// Lleno el hight pára recorrer de forma descendente y chequear lineas formadas
	method fillMapHight() {
		(rows..0).forEach({n=>mapHight.add(n)})
	} 
	// Lleno el hight pára recorrer de forma descendente hasta una columna dada (no se usa)
	method fillMapHight(row) {
		(rows..row).forEach({n=>mapHight.add(n)})
	}
	// Verifica si la pieza colisiona contra el tablero bool
	method CollideWith(piece) = piece.existAnyRowMaxAs(rows) ||	piece.existAnyColMaxAs(cols) ||	self.existAnyTileAs(piece)
	// Copia la pieza en el tablero
	method StampPiece(piece) {
		const map = piece.stampTileMap()
		map.forEach({tile => game.addVisual(tile)})
		tilesMap.addAll(map)
	}
	// Limpia una línea específica del tablero
	method ClearLine(row) {
		self.removeRowVisualAndTiles(row)
		self.moveTilesDown(row)	
	}
	// Busca líneas formadas en el tablero retorta el numero de lineas
	method CheckForLines() {
		var lines = 0
		mapHight.forEach({
			row => if(self.allTilesOfRow(row)!= null && self.allTilesOfRowCount(row) == cols) {
				lines++
				self.ClearLine(row)				
			}
		})
		return lines
	}
	// Reseteo el tablero
	method Reset() {
		tilesMap.forEach({tile => game.removeVisual(tile)})
		tilesMap.clear()
	}
	// Chequeo si un tile de la pieza esta en el tablero bool
	method existAnyTileAs(piece) = tilesMap.any({
		tile => piece.existAnyTileAs(tile)			     
	})
	// Devuelvo la cantidad tiles de una fila
	method allTilesOfRowCount(row) = self.allTilesOfRow(row).size()
	// Devuelvo los tiles de una fila
	method allTilesOfRow(row) = tilesMap.filter({
		tile => tile.position().y() == row
	})
	// Remuevo los visual y los tiles de una fila
	method removeRowVisualAndTiles(row){
		tilesMap.forEach({tile => if(tile.position().y() == row)game.removeVisual(tile)})
		tilesMap.removeAll(self.allTilesOfRow(row))
	}
	// Muevo los tiles hacia abajo hasta una fila dada
	method moveTilesDown(row) {
		tilesMap.forEach({tile => if(tile.position().y() > row) {
			tile.position(new Position(x = tile.position().x(), y = tile.position().y() - 1))
		}})
	}
	// Chequeo condicion de derrota
	method gameOver() = tilesMap.any({tile => tile.position().y() >= rows - 2 })
}

