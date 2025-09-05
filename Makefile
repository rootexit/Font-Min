SRC_ROOT := ./src
DIST_ROOT := ./dist
CONTENT_FILE := ./content.txt

# 用 find 递归收集所有 ttf/otf
FONT_FILES := $(shell find $(SRC_ROOT) -type f \( -name '*.ttf' -o -name '*.otf' \))

clean:
	rm -rf dist/*

build: 
	sh main.sh

# 默认目标
subset:$(FONT_FILES)
	@set -e; \
	for font_file in $^; do \
		font_type=$$(basename $$(dirname $$font_file)); \
		dist_dir=$(DIST_ROOT)/$$font_type; \
		mkdir -p $$dist_dir; \
		base_name=$$(basename $$font_file); \
		echo ">> 子集化 $$font_file -> $$dist_dir/$$base_name"; \
		pyftsubset "$$font_file" --text-file="$(CONTENT_FILE)" --output-file="$$dist_dir/$$base_name"; \
	done
	@echo "✅ 所有字体压缩完成，已保存至 $(DIST_ROOT) 目录。"

.PHONY: subset