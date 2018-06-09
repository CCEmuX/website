export PATH := $(shell npm bin):$(PATH)

OUT := dist

STYLES := $(shell find styles -type f -name '*.scss')
IMG := $(shell find img -type f)

.PHONEY: all

all: $(OUT)

clean:
	rm -rf $(OUT)

$(OUT): $(OUT)/main.css $(OUT)/index.html $(OUT)/img
	touch $(OUT)
	cp img/icon/favicon.ico $(OUT)/favicon.ico

$(OUT)/main.css: $(STYLES)
	mkdir -p $(OUT)
	node-sass --output-style compressed styles/main.scss > $(OUT)/main.css

$(OUT)/index.html: template/data.json template/index.mustache
	mkdir -p $(OUT)
	mustache template/data.json template/index.mustache > $(OUT)/index.html

$(OUT)/img: $(IMG)
	rm -rf $(OUT)/img
	cp -r img $(OUT)

serve: $(OUT)
	# Run a HTTP server and rebuild the template & css as needed.
	# We use a negative cache time to allow for easier development
	http-server $(OUT) -c-1 & \
	while true; do \
		$(MAKE) -s dist; \
		inotifywait -q -e close_write -r template styles img; \
	done; \
	wait
