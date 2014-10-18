var kloggr;

function Square(w, h, texture) {
	this.m_x = 0;
	this.m_y = 0;
	this.m_width = w;
	this.m_height = h;
	this.m_visible = true;
	this.texture = texture;

	this.object = Qt.createQmlObject(this.newQmlObject(w, h, texture), kloggr, "Square");
}

Object.defineProperty(Square.prototype, "x", {
						  get: function() { return this.m_x; },
						  set: function(val) { this.m_x = val; this.object.x = val; }
					  });

Object.defineProperty(Square.prototype, "y", {
						  get: function() { return this.m_y; },
						  set: function(val) { this.m_y = val; this.object.y = val; }
					  });

Object.defineProperty(Square.prototype, "width", {
						  get: function() { return this.m_width; },
						  set: function(val) { this.m_width = val; this.object.width = val; }
					  });

Object.defineProperty(Square.prototype, "height", {
						  get: function() { return this.m_height; },
						  set: function(val) { this.m_height = val; this.object.height = val; }
					  });

Object.defineProperty(Square.prototype, "visible", {
						  get: function() { return this.m_visible; },
						  set: function(val) { this.m_visible = val; this.object.visible = val; }
					  });

Square.prototype.newQmlObject = function(w, h, texture) {
	if (/#[0-9a-zA-Z]{6}/.test(texture)) {
		return "import QtQuick 2.3;\
				Rectangle {\
					width:"+w+";\
					height:"+h+";\
					color:\""+texture+"\";\
				}";
	}
	else {
		return "import QtQuick 2.3;\
				Image {\
					source:\""+texture+"\";\
					width:"+w+";\
					height:"+h+";\
				}";
	}
};
