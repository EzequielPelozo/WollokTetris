import pieza.*
import wollok.game.*

class BoardMap {
	
	const property tilesMap = []
	const property cols = 10
	const property rows = 20
	
	// Actualiza
	method Update() {}
	// Verifica si la pieza colisiona contra el tablero bool
	method CollideWith(piece) = piece.existAnyRowMaxAs(rows) ||	piece.existAnyColMaxAs(cols) ||	self.existAnyTileAs(piece)
	// Copia la pieza en el tablero
	method StampPiece(piece) {
		const map = piece.stampTileMap()
		map.forEach({tile => game.addVisual(tile)})
		tilesMap.addAll(map)
	}
	// Limpia una línea específica del tablero
	method ClearLine(row) {}
	// Busca líneas formadas en el tablero
	method CheckForLines() {
		
	}
	// Reseteo el tablero
	method Reset() {}
	// chequeo si un tile de la pieza esta en el tablero bool
	method existAnyTileAs(piece) = tilesMap.any({
		tile => piece.existAnyTileAs(tile)			     
	})
	
	//retorna un copia de la pieza
	//method copyPiece(piece) = 
}

