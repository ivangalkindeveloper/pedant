run:
	cd example && dart run custom_lint

watch:
	cd example && dart run custom_lint --watch
	
fix:
	cd example && dart run custom_lint --fix

pedant:
	cd example && dart run pedant