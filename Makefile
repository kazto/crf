FILES = src/crf.cr \
	src/window_manager.cr \
	src/window.cr \
	src/dir_window.cr \
	src/file_window.cr \
	src/dir.cr \
	src/file.cr

EXE = crf

all:
	crystal build src/crf.cr

${EXE}: ${FILES}

clean:
	rm ${EXE}