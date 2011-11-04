BIN=kv_login

DC=dmd
DCFLAGS=-J.

.PHONY: build
.PHONY: clean
.PHONY: distrib
.PHONY: help

build: $(BIN).d 
	$(DC) $(DCFLAGS) $(BIN).d modules/*.d -of$(BIN)
	-strip $(BIN)
	
run: build
	./$(BIN)