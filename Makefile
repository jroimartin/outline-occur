EMACS = emacs

.PHONY: check
check:
	$(EMACS) --batch \
	  -L . -l ert -l ./test/outline-occur-tests.el \
	  -f ert-run-tests-batch-and-exit
