### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ d0eed90c-4bbd-11eb-082e-d9212f152519
begin
	using PlutoUI
	using Images
end

# ╔═╡ 09a7d84c-4bc4-11eb-1384-57d9186ccf6d
function remove_in_each_row(img, column_numbers)
	@assert size(img, 1) == length(column_numbers)

	m, n = size(img)

	img′ = similar(img, m, n-1)

	@views for (i, j) in enumerate(column_numbers)
		img′[i, 1:j-1] = img[i, 1:j-1]
		img′[i, j:end] = img[i, j+1:end]
	end

	img′
end

# ╔═╡ 6d3fe86a-4bbd-11eb-2944-ab540dd2f753
function least_energy_matrix(energies)
	m, n = size(energies)
	least_energies = copy(energies)
	for i ∈ m-1:-1:1
		for j ∈ 1:n
			lw = max(j - 1, 1)
			up = min(j + 1, n)
			least_energies[i, j] += minimum([least_energies[i+1, j′] for j′=lw:up])
		end
	end
	least_energies
end

# ╔═╡ bf10bba4-4bbf-11eb-1465-0b9cccaf91aa
function best_seam_array(energies::Array{Float64, 2})
	least_energies = least_energy_matrix(energies)
	m, n = size(least_energies)
	seam = ones(Int, m)
	_, seam[1] = findmin(least_energies[1, 1:end ])

	for i ∈ 2:m
		lw = max(seam[i-1] - 1, 1)
		up = min(seam[i-1] + 1, n)
		minval, index = findmin([least_energies[i, j′] for j′=lw:up])
		seam[i] = lw + index - 1
	end
	seam
end

# ╔═╡ 916fb4f0-4bc1-11eb-3964-a1691e6e7744
function add_seam(img, seam)
	img′ = copy(img)
	for i=1:size(img, 1)
		img′[i, seam[i]] = RGB(1, 0, 0)
	end
	img′
end

# ╔═╡ eef2bb8a-4bc2-11eb-1b49-aff2350e3675
function shrink_n(img, energies, n, imgs_list=[])
	if n == 0
		return imgs_list
	end
	
	push!(imgs_list, img)
	
	seam = best_seam_array(energies)
	
	
	img′      = remove_in_each_row(img, seam)
	energies′ =  remove_in_each_row(energies, seam)
	
	shrink_n(img′, energies′, n - 1, imgs_list)
end

# ╔═╡ ddfbf39e-4bbd-11eb-0cc1-cf33765851a3
img = imresize(load("example"), ratio=1//6)

# ╔═╡ 1d1192a8-4bca-11eb-3923-cbcda32c9654
save("test.gif", rand(RGB{N0f8}, 32, 32, 5))

# ╔═╡ 7e5def1a-4c68-11eb-197a-21120ff1d7ce
function shrink_n_matrix(img, energies, n)
	imgs_matrix = zeros(RGB, size(img)..., n÷2+1)

	imgs_matrix[:, :, 1] .= img 
	
	img′       = img
	energies′  = energies

	# Se hacen dos cortes simultaneos
	for i=1:n÷2
		for _=1:2
			seam      = best_seam_array(energies′)
			img′      = remove_in_each_row(img′ , seam)
			energies′ = remove_in_each_row(energies′, seam)
		end
		
		imgs_matrix[:, 1+i:end-i, i + 1] .= img′
	end

	imgs_matrix
end

# ╔═╡ 74da46a0-4bdc-11eb-3f0f-6b6294965d40
maxv = size(img,2) ÷ 2

# ╔═╡ 68faec36-4bcd-11eb-35d1-3561950edeb4
# save("river.gif", cat(DATA, reverse(DATA; dims=3), dims=3))

# ╔═╡ ad41b0dc-4bdf-11eb-040a-c7820821bcfd
md"## Utilities"

# ╔═╡ 30b4bad6-4bbf-11eb-3112-99218360e54e
brightness(i) = Gray(i)

# ╔═╡ 9bcf0896-4bbd-11eb-351e-1ff0ba5c1ba4
convolve(img, k) = imfilter(img, reflect(k))

# ╔═╡ 72c5adf6-4bbd-11eb-3cc0-975fd4d7244e
begin
	energy(∇x, ∇y) = sqrt.(∇x.^2 .+ ∇y.^2)
	function energy(img)
		∇y = convolve(brightness.(img), Kernel.sobel()[1])
		∇x = convolve(brightness.(img), Kernel.sobel()[2])
		energy(∇x, ∇y)
	end
end

# ╔═╡ 04db8b32-4bde-11eb-196e-813fd0a72e36
energy(img) .|> Gray

# ╔═╡ d9f47892-4bbd-11eb-1a32-f747fe112c63
E = (energy(img) .* 9 .+ 0.1 ).^10;

# ╔═╡ 32f6967a-4bdd-11eb-1518-a1adfcde96d7
Gray.(E)

# ╔═╡ 557d9d6c-4bdd-11eb-160e-31b7272cae20
LE = least_energy_matrix(E);

# ╔═╡ 8053f2fe-4bc0-11eb-3df6-db463bfb2f90
 RGB.(0.2 * LE)

# ╔═╡ eb790af0-4bc1-11eb-2450-0b7da1424bd5
add_seam(img, best_seam_array(LE))

# ╔═╡ f392f1d4-4bca-11eb-114d-0946e4466514
DATA = shrink_n_matrix(img, E, maxv);

# ╔═╡ 6caa589e-4bdc-11eb-2ba2-bd42752124e8
@bind W Slider(1:size(DATA,3))

# ╔═╡ 6662bf94-4bdc-11eb-0fb1-075ee90aeeeb
DATA[:, :, W]

# ╔═╡ 90dfcdc6-4bc7-11eb-0d4e-37314c0bb979
html"""<style>
pluto-output.rich_output[mime*="image"] {
	display: flex;
	justify-content: center
}
</style>"""

# ╔═╡ Cell order:
# ╠═d0eed90c-4bbd-11eb-082e-d9212f152519
# ╠═09a7d84c-4bc4-11eb-1384-57d9186ccf6d
# ╠═6d3fe86a-4bbd-11eb-2944-ab540dd2f753
# ╠═bf10bba4-4bbf-11eb-1465-0b9cccaf91aa
# ╠═916fb4f0-4bc1-11eb-3964-a1691e6e7744
# ╠═eef2bb8a-4bc2-11eb-1b49-aff2350e3675
# ╠═ddfbf39e-4bbd-11eb-0cc1-cf33765851a3
# ╠═04db8b32-4bde-11eb-196e-813fd0a72e36
# ╠═d9f47892-4bbd-11eb-1a32-f747fe112c63
# ╠═32f6967a-4bdd-11eb-1518-a1adfcde96d7
# ╠═557d9d6c-4bdd-11eb-160e-31b7272cae20
# ╠═8053f2fe-4bc0-11eb-3df6-db463bfb2f90
# ╠═eb790af0-4bc1-11eb-2450-0b7da1424bd5
# ╠═1d1192a8-4bca-11eb-3923-cbcda32c9654
# ╠═7e5def1a-4c68-11eb-197a-21120ff1d7ce
# ╠═74da46a0-4bdc-11eb-3f0f-6b6294965d40
# ╠═f392f1d4-4bca-11eb-114d-0946e4466514
# ╠═6662bf94-4bdc-11eb-0fb1-075ee90aeeeb
# ╠═6caa589e-4bdc-11eb-2ba2-bd42752124e8
# ╠═68faec36-4bcd-11eb-35d1-3561950edeb4
# ╟─ad41b0dc-4bdf-11eb-040a-c7820821bcfd
# ╠═72c5adf6-4bbd-11eb-3cc0-975fd4d7244e
# ╠═30b4bad6-4bbf-11eb-3112-99218360e54e
# ╠═9bcf0896-4bbd-11eb-351e-1ff0ba5c1ba4
# ╠═90dfcdc6-4bc7-11eb-0d4e-37314c0bb979
