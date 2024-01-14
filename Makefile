
ifeq ($(OS),Windows_NT)
		installcmd = winget install julia -s msstore
else
		installcmd = curl -fsSL https://install.julialang.org | sh
endif

ifeq ($(OS),Windows_NT)
		cleancmd = winget uninstall julia -s msstore
else
		cleancmd = rm -rf ~/.julia
endif

run:
	julia drca.jl 

install:
	$(installcmd)

clean:
	$(cleancmd)

