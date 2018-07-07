export PATH := $(shell npm bin):$(PATH)

OUT := dist

STYLES := $(shell find styles -type f -name '*.scss')
PARTIALS := $(shell find template -type f)
IMG := $(shell find img -type f)

.PHONEY: all

all: $(OUT)

clean:
	rm -rf $(OUT)

$(OUT): $(OUT)/main.css $(OUT)/index.html $(OUT)/getting-started.html $(OUT)/img $(OUT)/favicon.ico $(OUT)/ccemux-launcher.jar
	touch $(OUT)

$(OUT)/main.css: $(STYLES)
	mkdir -p $(OUT)
	node-sass --output-style compressed styles/main.scss > $(OUT)/main.css

$(OUT)/%.html: pages/%.handlebars pages/data.json $(PARTIALS)
	mkdir -p $(OUT)
	hbs --stdout --data pages/data.json --helper './template/helpers' --partial 'template/*.handlebars' $< > $@

$(OUT)/favicon.ico: img/icon/favicon.ico
	cp $< $@

$(OUT)/ccemux-launcher.jar: launcher/build/libs/launcher-1.0-all.jar
	cp $< $@

launcher/build/libs/launcher-1.0-all.jar:
	if [ ! -d "launcher" ]; then git clone https://github.com/CCEmuX/launcher.git launcher; fi
	cd launcher && ./gradlew build

$(OUT)/img: $(IMG)
	rm -rf $(OUT)/img
	cp -r img $(OUT)

serve: $(OUT)
	# Run a HTTP server and rebuild the template & css as needed.
	# We use a negative cache time to allow for easier development
	http-server $(OUT) -c-1 & \
	while true; do \
		$(MAKE) -s dist; \
		inotifywait -q -e close_write -r template pages styles img; \
	done; \
	wait
