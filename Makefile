export PATH := $(shell npm bin):$(PATH)

OUT := dist

STYLES := $(shell find styles -type f -name '*.scss')
PARTIALS := $(shell find template -type f)
IMG := $(shell find img -type f)

.PHONEY: all

all: $(OUT)

clean:
	rm -rf $(OUT)

$(OUT): $(OUT)/main.css $(OUT)/index.html $(OUT)/getting-started.html $(OUT)/ccemux-api.html $(OUT)/tips.html $(OUT)/peripherals.html \
        $(OUT)/cli.html $(OUT)/img $(OUT)/favicon.ico
	touch $(OUT)

$(OUT)/main.css: $(STYLES)
	mkdir -p $(OUT)
	node-sass --output-style compressed styles/main.scss > $(OUT)/main.css

$(OUT)/%.html: pages/%.handlebars pages/data.json $(PARTIALS) template/build.js
	mkdir -p $(OUT)
	node template/build.js < $< > $@

$(OUT)/favicon.ico: img/icon/favicon.ico
	cp $< $@

$(OUT)/img: $(IMG)
	rm -rf $(OUT)/img
	cp -r img $(OUT)

pages/data.json: $(OUT)/main.css
	echo "{                                                               \
	  \"css_version\":\"$(shell sha1sum "$(OUT)/main.css" | cut -c-10)\", \
	  \"sha_short\":\"$(SHA_SHORT)\",                                     \
	  \"sha_long\":\"$(SHA)\",                                            \
	  \"date\":\"$(COMMIT_DATE)\"                                         \
	}" > "pages/data.json"

serve: $(OUT)
	# Run a HTTP server and rebuild the template & css as needed.
	# We use a negative cache time to allow for easier development
	http-server $(OUT) -c-1 & \
	while true; do \
		$(MAKE) -s dist; \
		inotifywait -q -e close_write -r template pages styles img; \
	done; \
	wait
